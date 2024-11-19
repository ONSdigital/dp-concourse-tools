SHELL := bash

ECR_AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --profile dp-ci --query Account --output text)
ECR_AWS_ACCOUNT_URL = $(ECR_AWS_ACCOUNT).dkr.ecr.eu-west-2.amazonaws.com
UBUNTU_YEAR_NAME = ubuntu20.4
UBUNTU_VERSION = focal-20241011
IMAGE_NAME = ${ECR_AWS_ACCOUNT_URL}/onsdigital/dp-concourse-tools-ubuntu-20:${UBUNTU_YEAR_NAME}-${UBUNTU_VERSION}

.PHONY: build
build:
	docker build -t ${IMAGE_NAME} --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} .

.PHONY: publish
publish:
	aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${ECR_AWS_ACCOUNT_URL}

	docker push ${IMAGE_NAME}

.PHONY: prune
prune:
	docker system prune
