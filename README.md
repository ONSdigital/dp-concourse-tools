## Digital Publishing Concourse Tools

Build tools we use in our Concourse CI pipelines as docker images.

### Getting started

All images are currently published to Docker Hub. You will require a login to the "onsdigital" Docker Hub organisation to continue as well as write permissions to push changes to account.

On commandline run `docker login` or [see docker docs](https://docs.docker.com/engine/reference/commandline/login/)

### Contents

* [Build and Publish Image](#build-and-publish-image): How to build and publish an image
* [Tagging Docker Images](#tagging-docker-images): Guidance for tagging docker images
* [Labelling Dockerfiles](#labelling-docker-images): Guidance for adding labels to dockerfiles
* [Renaming existing images](#renaming-existing-images): How to rename an existing tagged image

### Build and Publish Image

#### Prerequisites

- You will need to know what tag you are going to give to your new image, please read the [tagging docker images](#tagging-docker-images) section before continuing
- It is desirable to add Labels to the docker image, please read through the [labelling docker images](#labelling-docker-images) section before continuing
- Check the current "latest" tagged version of docker repo has an equivalent tag so the image is not lost
  - Can use steps 1 to 4 in [renaming existing images](#renaming-existing-images) section, use step 4 to compare image tag ids for a docker repo to see if latest image tag has a copy

#### To build and publish an image:

1. Build image under unique tag abiding by instructions in [tagging docker images](#tagging-docker-images) section

```shell
# $DIR_NAME in the following is one of the directories in this repo
cd $DIR_NAME
docker build -t onsdigital/dp-concourse-tools-$(basename "${PWD}"):<tag> .
docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):<tag>
```

2. Overwrite latest with new image

```shell
cd $DIR_NAME # Unecessary step if already in directory containing dockerfile
docker build -t onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest .
docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest
```

### Tagging Docker Images

- The base image used in dockerfile should be represented as the first part of the new tag, see table below
- Other installations in the docker image should also be added to the tag

| Base Image             | Other installs                 | Tag                                 |
| ---------------------- | ------------------------------ | ----------------------------------- |
| FROM maven:3.5.0-jdk-8 | Node 8                         | 3.5.0-jdk-8-node-8                  |
| FROM golang:1.19.4     | Node 14                        | 1.19.4-node-14                      |
| FROM golang:1.19.4     | Node 14, golangci-lint v1.51.0 | 1.19.4-node-14-golangci-lint-1.51.0 |

### Labelling docker images

Use labels to assist developers to know which image they should be using and where they can find further information. Labels are added to the dockerfile and begin with the term `LABEL`, see table below of expected labels to add to your dockerfile.

**LABELS**

| Key                       | Value  | Label example                                                     | Required |
| ------------------------- | ------ | ----------------------------------------------------------------- | -------- |
| <install-name->_version   | string | LABEL go_version="1.19.4"                                         | true     |
| git_repo                  | string | LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools" | true     |
| folder                    | string | LABEL folder="node-go"                                            | true     |
| git_commit                | string | LABEL git_commit="5ef37cff8df2297d039395bf64f1be600241508c"       | true     |

### Renaming existing images

If the latest image does not exist as a specific tagged version, you will need to create a new image tagged with correct version. This will allow you to overwrite image tagged latest with new version without losing any images.

1. Find out what version the image for the existing latest version should be, [see tagging docker images](#tagging-docker-images)
1. $DIR_NAME in the following is one of the directories in this repo: `cd $DIR_NAME`
1. Pull docker image from remote to local docker instance: `docker pull -a onsdigital/dp-concourse-tools-$(basename "${PWD}")`
1. Retrieve latest image id: `docker images -a | grep dp-concourse-tools-$(basename "${PWD}")`
1. Change tag on existing image: `docker tag <image id retrieved from previous step> onsdigital/dp-concourse-tools-$(basename "${PWD}"):<tag>`
1. Push docker changes to remote dockerhub: `docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):<tag>`

Now it is safe to move on to uploading a new latest version of the image, following [build and publish image](#build-and-publish-image) section.

Contributing
------------

See [CONTRIBUTING](CONTRIBUTING.md) for details.

License
-------

Copyright © 2021, Office for National Statistics (https://www.ons.gov.uk)

Released under MIT license, see [LICENSE](LICENSE.md) for details.
