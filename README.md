# Digital Publishing Concourse Tools

Build tools we use in our Concourse CI pipelines as docker images.

We now get images from the AWS CI account Private ECR.

All images have been copied from Docker Hub into AWS CI account Private ECR.

## Tagging strategy

- The base image used in dockerfile should be represented as the first part of the new tag, see table below
- Other installations in the docker image should also be added to the tag

| Base Image             | Other installs                 | Tag                                 |
|------------------------|--------------------------------|-------------------------------------|
| FROM maven:3.5.0-jdk-8 | Node 8                         | 3.5.0-jdk-8-node-8                  |
| FROM golang:1.19.4     | Node 14                        | 1.19.4-node-14                      |
| FROM golang:1.19.4     | Node 14, golangci-lint v1.51.0 | 1.19.4-node-14-golangci-lint-1.51.0 |

## Labelling docker images

Use labels to assist developers to know which image they should be using and where they can find further information. Labels are added to the dockerfile and begin with the term `LABEL`, see table below of expected labels to add to your dockerfile.

| Key                     | Value  | Label example                                                     | Required |
|-------------------------|--------|-------------------------------------------------------------------|----------|
| <install-name->_version | string | LABEL go_version="1.19.4"                                         | true     |
| git_repo                | string | LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools" | true     |
| folder                  | string | LABEL folder="node-go"                                            | true     |
| git_commit              | string | LABEL git_commit="5ef37cff8df2297d039395bf64f1be600241508c"       | true     |

## Building and publishing images

### Prerequisites

- You will need to know what tag you are going to give to your new image, please read the [Tagging strategy](#tagging-strategy) section before continuing
- It is desirable to add Labels to the docker image, please read through the [labelling docker images](#labelling-docker-images) section before continuing
- If you are creating a completely new image that has not been used before, you will first need to create the Repository name in the AWS ECR Private registry - before building and pushing the image.
- If you are using colima, ensure you have done the following:

```bash
brew install docker-buildx

mkdir -p ~/.docker/cli-plugins

ln -s $(which docker-buildx) ~/.docker/cli-plugins/docker-buildx

colima restart

docker buildx version
```

> :warning: **Check the current "latest" tagged version of docker repo has an equivalent "version" tag so the image is not lost**
You can check this on selecting the image you want to change in AWS CI account Private ECR, searching for dp-concourse-tools. If you can only see a latest tag listed or no other images have a `DIGEST` SHA that matches other `version` tagged images you will need to follow the [version tagging for things with only latest tags](#version-tagging-for-things-with-only-latest-tags) guide before progressing with building an image.

There is now an alternate method to the below - see [Deploying via Makefile](#deploying-via-makefile)

1. Build image under unique tag abiding by instructions in [Tagging strategy](#tagging-strategy) section

    ```shell
    # $TOOL_DIR in the following is one of the directories in this repo
    cd dp-concourse-tools/$TOOL_DIR
    docker build -t <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG> .
    ```

2. Push the new image and tag to AWS CI account Private ECR.

    ```shell
    aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com

    docker push <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG>
    ```

3. Re-tag the image you just built with the latest tag and push to AWS CI account Private ECR (effectively making your new image the latest one)

    ```shell
    docker tag <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG> <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest
    docker push <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest
    ```

### Deploying via Makefile

To do all the steps above by the Makefile targets you can do the following:

```sh
    TOOL="my tool" AWS_ACCOUNT_ID="my account id" NEW_TAG="my tag" make new
```

- TOOL is the name of the directory
- AWS_ACCOUNT_ID can be retrieved from the `dp-ci` account
- NEW_TAG should follow the versioning above

This only builds and deploys a tagged image, it does not add a `latest` tag.

For the majority of use cases we should *not* be using `latest` tag. There are exceptions however, for example [Go libraries](https://github.com/ONSdigital/dp-standards/blob/main/DEPENDENCY_UPGRADING.md#go-based-apps-and-libraries)

To build and deploy an image with a latest tag you can do the following:

```sh
    TOOL="my tool" AWS_ACCOUNT_ID="my account id" NEW_TAG="my tag" make new-latest
```

## Version tagging for things with only latest tags

If the `latest` image does not exist as a specific tagged `version`, you will need to create a new image tagged with correct `version` first. This will allow you to overwrite image tagged `latest` with new `version` without losing any images.

1. Find out what tag the image for the existing latest version should be, see the [Tagging strategy](#tagging-strategy) section

2. Pull the remote docker image

    ```shell
    aws ecr get-login-password --region eu-west-2 --profile dp-ci | docker login --username AWS --password-stdin <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com

    docker pull <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-<TOOL_NAME>:latest
    ```

3. Change tag on latest image just pulled to the tag determined in step 1

    ```shell
    docker tag <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-<TOOL_NAME>:latest <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-<TOOL_NAME>:<NEW_TAG>
    ```

4. Push the new tag to AWS CI account Private ECR:

    ```shell
    docker push <AWS CI account id>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-<TOOL_NAME>:<NEW_TAG>
    ```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright © 2021, Office for National Statistics (<https://www.ons.gov.uk>)

Released under MIT license, see [LICENSE](LICENSE.md) for details.
