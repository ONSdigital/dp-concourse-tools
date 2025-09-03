SHELL := bash

DOCKER_VERSION = 20.10.24

ECR_AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --profile dp-ci --query Account --output text)
ECR_AWS_ACCOUNT_URL = $(ECR_AWS_ACCOUNT).dkr.ecr.eu-west-2.amazonaws.com
IMAGE_NAME = ${ECR_AWS_ACCOUNT_URL}/onsdigital/dcind

.PHONY: build
build:
	docker build -t ${IMAGE_NAME} \
		--build-arg DOCKER_VERSION=${DOCKER_VERSION} \
		.

.PHONY: publish
publish:
	aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${ECR_AWS_ACCOUNT_URL}

	docker push ${IMAGE_NAME}

.PHONY: prune
prune:
	docker system prune
