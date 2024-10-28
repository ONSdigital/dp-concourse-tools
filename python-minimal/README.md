# Minimal python in Alpine image

## Build and push to AWS ECR instructions

Log in to the AWS CI account and in "Elastic Container Registry" ensure there is a repository named "onsdigital/dp-concourse-tools-python-minimal".

If it is missing, create it.

Then in a terminal, first initialise:

```shell
export ECR_AWS_ACCOUNT_ID=<AWS CI account id>
```

Then execute these 4 lines:

```shell
docker build -t onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12 -f Dockerfile.alpine-python-minimal .

aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin $(ECR_AWS_ACCOUNT_ID).dkr.ecr.eu-west-2.amazonaws.com

docker tag onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12 $(ECR_AWS_ACCOUNT_ID).dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12

docker push $(ECR_AWS_ACCOUNT_ID).dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12
```

## Support test apps used to test the built Dockerfile image is suitable for CI

Test app run my container:
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
