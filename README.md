# Digital Publishing Concourse Tools

Build tools we use in our Concourse CI pipelines as docker images.

All images are currently published to Docker Hub. You will require a login to the [onsdigital](https://hub.docker.com/orgs/onsdigital/repositories) Docker Hub organisation to view as well as write permissions to push changes to account. (The write permissions are usually restricted to TLs and Platform team)

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

> :warning: **Check the current "latest" tagged version of docker repo has an equivalent "version" tag so the image is not lost**
You can check this on selecting the image you want to change [dockerhub](https://hub.docker.com/repositories/onsdigital?search=dp-concourse-tools). If you can only see a latest tag listed or no other images have a `DIGEST` SHA that matches other `version` tagged images you will need to follow the [version tagging for things with only latest tags](#version-tagging-for-things-with-only-latest-tags) guide before progressing with building an image

1. Build image under unique tag abiding by instructions in [Tagging strategy](#tagging-strategy) section

    ```shell
    # $TOOL_DIR in the following is one of the directories in this repo
    cd dp-concourse-tools/$TOOL_DIR
    docker build -t onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG> .
    ```

2. Push the new image and tag to dockerhub

    ```shell
    docker login #You need to login to dockerhub via the cli before continuing
    docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG>
    ```

3. Re-tag the image you just built with the latest tag and push to dockerhub (effectively making your new image the latest one)

    ```shell
    docker tag onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG> onsdigital/dp-concourse-tools-$(basename "${PWD}"):<NEW_TAG>
    docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest
    ```

## Version tagging for things with only latest tags

If the `latest` image does not exist as a specific tagged `version`, you will need to create a new image tagged with correct `version` first. This will allow you to overwrite image tagged `latest` with new `version` without losing any images.

1. Find out what tag the image for the existing latest version should be, see the [Tagging strategy](#tagging-strategy) section
1. Pull the remote docker image

    ```shell
    docker pull onsdigital/dp-concourse-tools-<TOOL_NAME>:latest
    ```

1. Change tag on latest image just pulled to the tag determined in step 1

    ```shell
    docker tag onsdigital/dp-concourse-tools-<TOOL_NAME>:latest onsdigital/dp-concourse-tools-<TOOL_NAME>:<NEW_TAG>
    ```

1. Push the new tag to dockerhub:

    ```shell
    docker push onsdigital/dp-concourse-tools-<TOOL_NAME>:<NEW_TAG>
    ```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright © 2021, Office for National Statistics (<https://www.ons.gov.uk>)

Released under MIT license, see [LICENSE](LICENSE.md) for details.
