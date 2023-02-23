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

- You will need to know what tag you are going to give to your new image, please read the [tagging docker images documentation before continuing](#tagging-docker-images)
- It is desirable to add Labels to the docker image, please read through the [adding labels documentation before continuing](#labelling-docker-images)
- Check the current "latest" tagged version of docker repo has an equivalent tag so the image is not lost
  - Can use steps 1 to 4 in [renaming existing images documentation](#renaming-existing-images), use step 4 to compare image tag ids for a docker repo to see if latest image tag has a copy

#### To build and publish an image:

1. Build image under unique tag abiding by [tagging docker instructions](#tagging-docker-images)

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

Digital publsihing use [semantic versioning](https://semver.org/) to determine the tag

Base images and other installations on the image wil determine whether the version is bumped a major, minor or patch.

For example if the latest tagged image is tagged with v1.2.1 ...

- ... then any major upgrades to the base image and/or other installs will increase the tag by 1 major version: tag moves to v2.0.0
- ... then any minor upgrades to the base image and/or other installs will increase the tag by 1 minor version: tag moves to v1.3.0
- ... then any patch upgrades to the base image and/or other installs will increase the tag by 1 patch version: tag moves to v1.2.2

If base image or installations have a mixture of major, minor or patch upgrades then the precedence/rank is major > minor > patch. For example
if the base image is incremented by minor version only but and installation increments by a major version then tag would move from 1.2.1 to 2.0.0, as the major version change of installation takes precedence over the minor version change of base image.

See table below for further examples 

| Current latest tag | Upgrades (base image or installations) | New Tag    |
| ------------------ | -------------------------------------- | ---------- |
| v1.2.1             | PATCH change only                      | v1.2.2     |
| v1.2.1             | MINOR change only                      | v1.3.0     |
| v1.2.1             | MAJOR change only                      | v2.0.0     |
| v1.2.1             | PATCH and MINOR changes                | v1.3.0     |
| v1.2.1             | PATCH and MAJOR changes                | v2.0.0     |
| v1.2.1             | MINOR and MAJOR changes                | v2.0.0     |
| v1.2.1             | PATCH, MINOR and MAJOR changes         | v2.0.0     |


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

Now it is safe to move on to uploading a new latest version of the image, [following build and publish image steps](#build-and-publish-image)

Contributing
------------

See [CONTRIBUTING](CONTRIBUTING.md) for details.

License
-------

Copyright © 2021, Office for National Statistics (https://www.ons.gov.uk)

Released under MIT license, see [LICENSE](LICENSE.md) for details.
