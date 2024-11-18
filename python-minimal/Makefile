SHELL := bash

ECR_AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --profile dp-ci --query Account --output text)
ECR_AWS_ACCOUNT_URL = $(ECR_AWS_ACCOUNT).dkr.ecr.eu-west-2.amazonaws.com
PYTHON_VERSION=3.12
ALPINE_VERSION=3.20.3
IMAGE_ALIAS = onsdigital/dp-concourse-tools-python-minimal:${ALPINE_VERSION}-python-${PYTHON_VERSION}

.PHONY: build
build:
	docker build -t ${IMAGE_ALIAS} --build-arg PYTHON_VERSION=${PYTHON_VERSION} --build-arg ALPINE_VERSION="${ALPINE_VERSION}" -f Dockerfile.alpine-python-minimal .

	docker tag ${IMAGE_ALIAS} ${ECR_AWS_ACCOUNT_URL}/${IMAGE_ALIAS}

.PHONY: publish
publish:
	aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${ECR_AWS_ACCOUNT_URL}

	docker push ${ECR_AWS_ACCOUNT_URL}/${IMAGE_ALIAS}

.PHONY: test
test: test-pass test-fail

# These tests demonstrate that the execution of a python app in the container returns error codes, which are needed when 
# this container is used in the concourse CI system.

.PHONY: test-pass
# This demonstrates that the python app passed to the docker container executes ok and returns a zero exit code
test-pass:
	docker run -it --rm -e INPUT_FILE='helloworld.py' -v $$PWD:/usr/src/app $(IMAGE_ALIAS) helloworld.py

.PHONY: test-fail
# This demonstrates that the python app passed to the docker container executes and detects a problem and returns a non-zero (fail) exit code
test-fail:
	@echo "docker run -it --rm -v \$$PWD:/usr/src/app $(IMAGE_ALIAS) helloworld.py"
	@if docker run -it --rm -v $$PWD:/usr/src/app $(IMAGE_ALIAS) helloworld.py; then \
		echo "This should have failed !"; \
		exit 1; \
	else \
		echo "The test worked because the helloworld.py returned a non-zero code"; \
		exit 0; \
	fi

# get to the python repl terminal in the container
.PHONY: py-repl
py-repl:
	@echo "To exit the python repl, type: exit(0)"
	docker run -it --rm -v $PWD:/usr/src/app $(IMAGE_ALIAS)
