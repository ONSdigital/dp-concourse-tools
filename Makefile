# Variables
## The directory in this repository that contains the image Dockerfile to be built
TOOL_DIR ?=
## The name of the dockerfile to use. Default is Dockerfile.
DOCKERFILE_NAME ?= Dockerfile
_DOCKERFILE := $(TOOL_DIR)/$(DOCKERFILE_NAME)
## The ECR repository base name, this is used in ECR to group images. Default is onsdigital/dp-concourse-tools.
ECR_REPO_BASE ?= onsdigital/dp-concourse-tools
_ECR_REPO := $(ECR_REPO_BASE)-$(TOOL_DIR)
## The aws profile to be used for signing into AWS ECR. Default is dp-ci.
ECR_PROFILE_NAME ?= dp-ci
_ECR_AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query "Account" --output text --profile $(ECR_PROFILE_NAME))
## The region where ECR is located. Default is eu-west-2.
ECR_AWS_REGION ?= eu-west-2
_ECR_REGISTRY := $(_ECR_AWS_ACCOUNT_ID).dkr.ecr.$(ECR_AWS_REGION).amazonaws.com
_BASE_VERSION ?= $(shell grep '^ARG BASE_IMAGE_.*_VERSION=' $(_DOCKERFILE) | awk -F'=' '{print $$2}')
_BASE_PREFIX := $(if $(_BASE_VERSION),$(_BASE_VERSION)-,)
## The tag to be used for the image. The default value is derived from ARG values from those with the suffix _VERSION.
# This creates the format as <PRODUCT>-<VERSION>, if the suffix begins with BASE_IMAGE_ then only the version will be used.
TAG ?= $(_BASE_PREFIX)$(shell grep '^ARG .*_VERSION=' $(_DOCKERFILE) | \
        grep -v '^ARG BASE_IMAGE_' | \
        sed -E 's/^ARG ([A-Z0-9_]+)_VERSION=(.*)/\1-\2/' | \
        tr '[:upper:]' '[:lower:]' | \
        tr '_' '-' | tr '\n' '-' | sed 's/-$$//')

## Whether this image should be tagged as latest. Default is true.
TAG_AS_LATEST := true
_COMMIT := $(shell git rev-parse HEAD)

_COLOUR_RESET := \033[0m
_COLOUR_GREEN := \033[32m
_COLOUR_RED := \033[31m
_COLOUR_YELLOW := \033[33m
_COLOUR_BLUE := \033[34m
_COLOUR_CYAN := \033[36m

# Targets and definitions

.DEFAULT_GOAL := help

.PHONY: help push build_remote build_local

help: ## Show help page for list of make targets and variables.
	@echo ""
	@echo "Usage:"
	@echo "  $(_COLOUR_YELLOW)make$(_COLOUR_RESET) $(_COLOUR_GREEN)<target>$(_COLOUR_RESET)"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} \
		/^[a-zA-Z_-]+:.*?##/ {printf "    ${_COLOUR_YELLOW}%-20s${_COLOUR_GREEN}%s${_COLOUR_RESET}\n", $$1, $$2} \
		/^## / {desc = substr($$0, 4)} \
		/^[A-Z0-9_]+ *[:?+]?=/ { \
			if (desc) { \
				split($$0, parts, /[:?+]?=/); \
				var = parts[1]; gsub(/^[ \t]+|[ \t]+$$/, "", var); \
				vars[var] = desc; desc = ""; \
			} \
		} \
		END { \
			if (length(vars)) { \
				printf "\nVariables:\n"; \
				for (v in vars) printf "    ${_COLOUR_YELLOW}%-20s${_COLOUR_GREEN}%s${_COLOUR_RESET}\n", v, vars[v]; \
			} \
		}' $(MAKEFILE_LIST)

define check_dockerfile
	if [ -z "$(TOOL_DIR)" ]; then \
		echo "❌  No TOOL_DIR supplied, please provide a TOOL_DIR directory name to use. Exiting."; \
		exit 1; \
	fi
endef

define check_tag
	if [ -z "$(TAG)" ]; then \
		echo "❌  No ARGs with _VERSION found in $(_DOCKERFILE) Or a manual TAG supplied. Exiting."; \
		exit 1; \
	fi;\
	if [ "$(TAG_AS_LATEST)" != "true" ] && [ "$(TAG_AS_LATEST)" != "false" ] ; then \
		echo "❌  TAG_AS_LATEST must be either 'true' or 'false' otherwise I don't know what to do. Exiting."; \
		exit 1; \
	fi;\
	echo "$(_COLOUR_YELLOW)ECR_REPO: $(_COLOUR_BLUE)$(_ECR_REPO)"; \
	echo "$(_COLOUR_YELLOW)TAG: $(_COLOUR_BLUE)$(TAG)"; \
	echo "$(_COLOUR_YELLOW)TAG_AS_LATEST: $(_COLOUR_BLUE)$(TAG_AS_LATEST)"; \
	echo "$(_COLOUR_YELLOW)COMMIT: $(_COLOUR_BLUE)$(_COMMIT) $(_COLOUR_RESET)"; \
	read -p "Check the above, if happy do you want to proceed? (y/n)" confirm; \
	if [ "$$confirm" != "y" ]; then \
		echo "$(_COLOUR_YELLOW)Ok I'll do nothing$(_COLOUR_RESET)"; \
		exit 1; \
	fi
endef

_check_and_create_ecr_repo:
	@echo "Checking if I need to create the repository: $(_ECR_REPO)..."
	@if ! aws ecr describe-repositories --repository-names $(_ECR_REPO) --region $(ECR_AWS_REGION) --profile $(ECR_PROFILE_NAME) > /dev/null 2>&1; then \
		echo "🚀  Repository $(_ECR_REPO) does not exist. Creating..."; \
		REPO_ARN=$$(aws ecr create-repository --repository-name $(_ECR_REPO) --image-tag-mutability IMMUTABLE --image-scanning-configuration scanOnPush=true --region $(ECR_AWS_REGION) --profile $(ECR_PROFILE_NAME) --query 'repository.repositoryArn' --output text); \
		echo "✅  Repository created successfully! ARN: $$REPO_ARN"; \
	else \
		echo "✅  Repository $(_ECR_REPO) already exists."; \
		echo "Checking if tag '$(TAG)' exists in ECR..."; \
		if aws ecr describe-images --repository-name $(_ECR_REPO) --region $(ECR_AWS_REGION) --profile $(ECR_PROFILE_NAME) --query 'imageDetails[?imageTags[?contains(@, `$(TAG)`)]].imageTags' --output text | grep -q $(TAG); then \
			echo "❌  Image with tag '$(TAG)' already exists in ECR repository $(_ECR_REPO). Exiting."; \
			exit 1; \
		fi; \
		echo "✅  Tag '$(TAG)' is available for use."; \
	fi

_check_ecr:
	@echo "Checking if ECR repository $(_ECR_REPO) exists..."
	@if ! aws ecr describe-repositories --repository-names $(_ECR_REPO) --region $(ECR_AWS_REGION) --profile $(ECR_PROFILE_NAME) > /dev/null 2>&1; then \
		echo "❌  Repository $(_ECR_REPO) does not exist."; \
		exit 1; \
	fi
	@echo "✅  Repository $(_ECR_REPO) exists."
	@echo "Checking if tag '$(TAG)' exists in ECR..."
	@if aws ecr describe-images --repository-name $(_ECR_REPO) --region $(ECR_AWS_REGION) --profile $(ECR_PROFILE_NAME) --query 'imageDetails[?imageTags[?contains(@, `$(TAG)`)]].imageTags' --output text | grep -q $(TAG); then \
		echo "❌  Image with tag '$(TAG)' already exists in ECR repository $(_ECR_REPO). Exiting."; \
		exit 1; \
	fi
	@echo "✅  Tag '$(TAG)' is available for use."

build_local: ## Build a local version of the image for testing
	@$(call check_dockerfile);
	@echo "$(_COLOUR_GREEN)This is just a local build you wont break anything in ECR!$(_COLOUR_RESET)";
	@$(call check_tag);
	@docker build \
		--build-arg COMMIT=$(_COMMIT) \
		--build-arg TAG=$(TAG) \
		-t $(_ECR_REPO):$(TAG) \
		-f $(_DOCKERFILE) $(TOOL_DIR);
	@if [ "$(TAG_AS_LATEST)" = "true" ]; then \
		docker tag $(_ECR_REPO):$(TAG) $(_ECR_REPO):latest ; \
	fi

_build_remote:
	@$(call check_dockerfile);
	@echo "$(_COLOUR_RED)You are about to make changes to in ECR!$(_COLOUR_RESET)"; \
	$(call check_tag);
	@$(MAKE) _check_and_create_ecr_repo
	@docker build \
		--build-arg COMMIT=$(_COMMIT) \
		--build-arg TAG=$(TAG) \
	  -t $(_ECR_REGISTRY)/$(_ECR_REPO):$(TAG) \
		-f $(_DOCKERFILE) $(TOOL_DIR);
	@if [ "$(TAG_AS_LATEST)" = "true" ]; then \
		docker tag $(_ECR_REGISTRY)/$(_ECR_REPO):$(TAG) $(_ECR_REGISTRY)/$(_ECR_REPO):latest ; \
	fi

push: ## Build and push the image to the remote AWS ECR
	@$(MAKE) _build_remote
	@echo "🔐  Logging into ECR..."
	@aws ecr get-login-password --region $(ECR_AWS_REGION) --profile $(ECR_PROFILE_NAME) | docker login --username AWS --password-stdin $(_ECR_REGISTRY) || (echo "❌  Failed to log in to ECR"; exit 1)
	@echo "🚀  Pushing $(_ECR_REGISTRY)/$(_ECR_REPO):$(TAG)..."
	@docker push $(_ECR_REGISTRY)/$(_ECR_REPO):$(TAG) || (echo "❌  Failed to push $(_ECR_REGISTRY)/$(_ECR_REPO):$(TAG)"; exit 1)
	@echo "✅  Successfully pushed $(_ECR_REGISTRY)/$(_ECR_REPO):$(TAG)"
	@if [ "$(TAG_AS_LATEST)" = "true" ]; then \
		if aws ecr describe-images --repository-name $(_ECR_REPO) --profile $(ECR_PROFILE_NAME) --image-ids imageTag=latest > /dev/null 2>&1; then \
			echo "🗑️  Deleting remote 'latest' tag..."; \
			output=$$(aws ecr batch-delete-image --repository-name $(_ECR_REPO) --profile $(ECR_PROFILE_NAME) --image-ids imageTag=latest --output json); \
			failures=$$(echo "$$output" | jq -r '.failures | length'); \
			if [ "$$failures" -eq 0 ]; then \
				echo "✅  'latest' Tag deleted!"; \
			else \
				echo "❌ Tag deletion for 'latest' failed, this means the image currently tagged with 'latest' is not correct, this NEEDS to be resolved"; \
				exit 1; \
			fi; \
		else \
			echo "ℹ️  Remote 'latest' tag does not exist. Skipping deletion."; \
		fi; \
		echo "🚀 Pushing $(_ECR_REGISTRY)/$(_ECR_REPO):latest..."; \
		docker push $(_ECR_REGISTRY)/$(_ECR_REPO):latest || (echo "❌  Failed to push $(_ECR_REGISTRY)/$(_ECR_REPO):latest"; exit 1); \
		echo "✅  Successfully pushed $(_ECR_REGISTRY)/$(_ECR_REPO):latest"; \
	fi
