GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

TOOL?=changeme
AWS_ACCOUNT_ID?=changeme

.PHONY: new
new: check-env build login deploy deploy-latest ## Builds and deploys images to ECR

.PHONY: check-env
check-env: ## Checks mandatory environment variables
	@if [ "$(TOOL)" = "changeme" ]; then \
		echo "TOOL is set to changeme - please set it to continue"; \
		exit 1; \
	fi
	@if [ "$(AWS_ACCOUNT_ID)" = "changeme" ]; then \
		echo "AWS_ACCOUNT_ID is set to changeme - please set it to continue"; \
		exit 1; \
	fi
	@if [[ -z "$(NEW_TAG)" ]]; then \
		echo "NEW_TAG is not set - please set it to continue"; \
		exit 1; \
	fi

.PHONY: build
build: ## Builds a specific image 
	cd ${TOOL}; \
	docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${TOOL}"):$(NEW_TAG) .

.PHONY: login
login: ## Logs in to AWS and Docker
	aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com

.PHONY: deploy
deploy: ## Deploys an image to ECR
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${TOOL}"):$(NEW_TAG)

.PHONY: deploy-latest
deploy-latest: ## Tags image as latest and deploys to ECR
	docker tag ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${TOOL}"):$(NEW_TAG) ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${TOOL}"):latest; \
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${TOOL}"):latest

.PHONY: help
help: ## Show help page for list of make targets
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
