SHELL := bash

ECR_AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --profile dp-ci --query Account --output text)
ECR_AWS_ACCOUNT_URL = $(ECR_AWS_ACCOUNT).dkr.ecr.eu-west-2.amazonaws.com
UBUNTU_VERSION = ubuntu20.4-focal-20241011
IMAGE_ALIAS = onsdigital/dp-concourse-tools-ubuntu-20:${UBUNTU_VERSION}

.PHONY: build
build:
	docker build -t ${ECR_AWS_ACCOUNT_URL}/${IMAGE_ALIAS} -f Dockerfile .

.PHONY: publish
publish:
	aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${ECR_AWS_ACCOUNT_URL}

	docker push ${ECR_AWS_ACCOUNT_URL}/${IMAGE_ALIAS}

.PHONT: prune
prune:
	docker system prune
