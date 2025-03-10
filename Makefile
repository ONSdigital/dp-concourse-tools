DIR_NAME := terraform-alpine
DOCKERFILE := $(DIR_NAME)/Dockerfile
ECR_REPO_BASE := onsdigital/dp-concourse-tools
ECR_REPO := $(ECR_REPO_BASE)-$(DIR_NAME)
ECR_PROFILE_NAME ?= dp-ci
ECR_AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query "Account" --output text --profile $(ECR_PROFILE_NAME))
AWS_REGION ?= eu-west-2
ECR_REGISTRY := $(ECR_AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

# Extract ARG values with the suffix _VERSION and format them as <VERSION>-<PRODUCT>
TAG := $(shell grep '^ARG .*_VERSION=' $(DOCKERFILE) | \
        sed 's/ARG //' | awk -F'[_=]' '{print $$3 "-" $$1}' | \
        tr '\n' '-' | sed 's/-$$//' | tr '[:upper:]' '[:lower:]')

check_tag:
	@if [ -z "$(TAG)" ]; then \
		echo "❌ No ARGs with _VERSION found in $(DOCKERFILE). Exiting."; \
		exit 1; \
	fi
	@echo "Generated tag: $(TAG)"

create_ecr_repo:
	@echo "Ensuring ECR repository exists: $(ECR_REPO)..."
	@if ! aws ecr describe-repositories --repository-names $(ECR_REPO) --region $(AWS_REGION) --profile $(ECR_PROFILE_NAME) > /dev/null 2>&1; then \
		echo "🚀 Repository $(ECR_REPO) does not exist. Creating..."; \
		REPO_ARN=$$(aws ecr create-repository --repository-name $(ECR_REPO) --image-tag-mutability IMMUTABLE --image-scanning-configuration scanOnPush=true --region $(AWS_REGION) --profile $(ECR_PROFILE_NAME) --query 'repository.repositoryArn' --output text); \
		echo "✅ Repository created successfully! ARN: $$REPO_ARN"; \
	else \
		echo "✅ Repository $(ECR_REPO) already exists."; \
	fi

check_ecr:
	@echo "Checking if ECR repository $(ECR_REPO) exists..."
	@if ! aws ecr describe-repositories --repository-names $(ECR_REPO) --region $(AWS_REGION) --profile $(ECR_PROFILE_NAME) > /dev/null 2>&1; then \
		echo "❌ Repository $(ECR_REPO) does not exist. Run 'make create_ecr_repo' first."; \
		exit 1; \
	fi
	@echo "✅ Repository $(ECR_REPO) exists."
	@echo "Checking if tag '$(TAG)' exists in ECR..."
	@if aws ecr describe-images --repository-name $(ECR_REPO) --region $(AWS_REGION) --profile $(ECR_PROFILE_NAME) --query 'imageDetails[?imageTags[?contains(@, `$(TAG)`)]].imageTags' --output text | grep -q $(TAG); then \
		echo "❌ Image with tag '$(TAG)' already exists in ECR repository $(ECR_REPO). Exiting."; \
		exit 1; \
	fi
	@echo "✅ Tag '$(TAG)' is available for use."

build_local:
	@$(MAKE) check_tag
	docker build -t $(ECR_REPO):$(TAG) -f $(DOCKERFILE) $(DIR_NAME)
	docker tag $(ECR_REPO):$(TAG) $(ECR_REPO):latest

build_remote:
	@$(MAKE) check_tag
	@$(MAKE) create_ecr_repo
	@$(MAKE) check_ecr
	docker build -t $(ECR_REGISTRY)/$(ECR_REPO):$(TAG) -f $(DOCKERFILE) $(DIR_NAME)
	docker tag $(ECR_REGISTRY)/$(ECR_REPO):$(TAG) $(ECR_REGISTRY)/$(ECR_REPO):latest

push:
	@$(MAKE) build_remote
	@echo "🛠️  Logging into ECR..."
	@aws ecr get-login-password --region $(AWS_REGION) --profile $(ECR_PROFILE_NAME) | docker login --username AWS --password-stdin $(ECR_REGISTRY) || (echo "❌ Failed to log in to ECR"; exit 1)

	@echo "🚀 Pushing $(ECR_REGISTRY)/$(ECR_REPO):$(TAG)..."
	@docker push $(ECR_REGISTRY)/$(ECR_REPO):$(TAG) || (echo "❌ Failed to push $(ECR_REGISTRY)/$(ECR_REPO):$(TAG)"; exit 1)
	@echo "✅ Successfully pushed $(ECR_REGISTRY)/$(ECR_REPO):$(TAG)"

	@if aws ecr describe-images --repository-name $(ECR_REPO) --profile $(ECR_PROFILE_NAME) --image-ids imageTag=latest > /dev/null 2>&1; then \
		echo "🗑️  Deleting remote 'latest' tag..."; \
		output=$$(aws ecr batch-delete-image --repository-name $(ECR_REPO) --profile $(ECR_PROFILE_NAME) --image-ids imageTag=latest --output json); \
		failures=$$(echo "$$output" | jq -r '.failures | length'); \
		if [ "$$failures" -eq 0 ]; then \
			echo "✅ 'latest' Tag deleted!"; \
		else \
			echo "❌ Tag deletion for 'latest' failed, this means the image currently tagged with 'latest' is not correct, this NEEDS to be resolved"; \
			exit 1; \
		fi; \
	else \
		echo "ℹ️  Remote 'latest' tag does not exist. Skipping deletion."; \
	fi
	@echo "🚀 Pushing $(ECR_REGISTRY)/$(ECR_REPO):latest..."
	@docker push $(ECR_REGISTRY)/$(ECR_REPO):latest || (echo "❌ Failed to push $(ECR_REGISTRY)/$(ECR_REPO):latest"; exit 1)
	@echo "✅ Successfully pushed $(ECR_REGISTRY)/$(ECR_REPO):latest"
