# Minimal python in Alpine image

## Build and push to AWS ECR instructions

### Prerequsites

Log in to the AWS CI account and in "Elastic Container Registry" ensure there is a repository named "onsdigital/dp-concourse-tools-python-minimal".

If it is missing, create it.

### Building and pushing container to AWS ECR

In a terminal, run:

```shell
make build
```

## Run tests for the created Docker image

This minimal app will be run in the container by the tests below it:
  helloworld.py

Test command showing a pass:

```shell
make test-pass
```

Test command to show fail:

```shell
make test-fail
```

Run all tests:

```shell
make test
```

To get to the python REPL command line in the container, use:

```shell
make py-repl
```
