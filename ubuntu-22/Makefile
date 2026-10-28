SHELL := bash

ECR_AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --profile dp-ci --query Account --output text)
ECR_AWS_ACCOUNT_URL = $(ECR_AWS_ACCOUNT).dkr.ecr.eu-west-2.amazonaws.com
UBUNTU_YEAR_NAME = ubuntu22.04
UBUNTU_VERSION = jammy-20261020
IMAGE_NAME = ${ECR_AWS_ACCOUNT_URL}/onsdigital/dp-concourse-tools-ubuntu-22:${UBUNTU_YEAR_NAME}-${UBUNTU_VERSION}
IMAGE_PLATFORM = linux/amd64

.PHONY: build
build:
	docker build --platform=${IMAGE_PLATFORM} -t ${IMAGE_NAME} --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg COMMIT=$(git rev-parse HEAD) .

.PHONY: verify-platform
verify-platform:
	@actual=$$(docker image inspect --format '{{.Os}}/{{.Architecture}}' ${IMAGE_NAME}) || exit 1; \
	if [ "$$actual" != "${IMAGE_PLATFORM}" ]; then \
		echo "Expected ${IMAGE_NAME} to target ${IMAGE_PLATFORM}, got $$actual" >&2; \
		exit 1; \
	fi

.PHONY: publish
publish: verify-platform
	aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${ECR_AWS_ACCOUNT_URL}

	docker push ${IMAGE_NAME}

.PHONY: prune
prune:
	docker system prune
