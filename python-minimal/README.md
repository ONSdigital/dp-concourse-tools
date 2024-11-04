# Minimal python in Alpine image

## Build and push to AWS ECR instructions

Log in to the AWS CI account and in "Elastic Container Registry" ensure there is a repository named "onsdigital/dp-concourse-tools-python-minimal".

If it is missing, create it.

Then in a terminal, first initialise (update `<AWS CI account id>` with the account ID value):

```shell
export ECR_AWS_ACCOUNT_URL=<AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com
export PYTHON_VERSION=3.12
export ALPINE_VERSION=3.20.3
export IMAGE_ALIAS=onsdigital/dp-concourse-tools-python-minimal:${ALPINE_VERSION}-python-${PYTHON_VERSION}
```

Then execute these 4 lines:

```shell
docker build -t ${IMAGE_ALIAS} -f Dockerfile.alpine-python-minimal .

aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin ${ECR_AWS_ACCOUNT_URL}

docker tag ${IMAGE_ALIAS} ${ECR_AWS_ACCOUNT_URL}/${IMAGE_ALIAS}

docker push ${ECR_AWS_ACCOUNT_URL}/${IMAGE_ALIAS}
```

## Run tests for the created Docker image

This minimal app will be run in the container by the tests below it:
  helloworld.py

Test command showing a pass:

```shell
pass.sh
```

Test command to show fail:

```shell
fail.sh
```

To get to the python REPL command line, use:

```shell
pyt.sh
```
