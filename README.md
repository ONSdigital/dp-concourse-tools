## Digital Publishing Concourse Tools


Build tools we use in our Concourse CI pipelines as docker images.

### Getting started

All images are currently published to Docker Hub. You will require a login to the "onsdigital" Docker Hub organisation to continue as well as write permissions to push changes to account.

On commandline run `docker login` or [see docker docs](https://docs.docker.com/engine/reference/commandline/login/)

If the latest image does not exist as a specific tagged version, you will need to create a new image tagged with correct version. This will allow you to overwrite image tagged latest with new version without losing any images.

1. Rename existing image:
   1. Find out what version the image for the existing latest version should be.
      1. It should match the base image version of the dockerfile appended with rc tag, `rc-1` for first image using base image of golang 1.19.3 would result in a tag of `1.19.3-rc.1`. An update to the dockerfile that did not change the base image should move to `1.19.3-rc.2`. An update to the docker file that changed the base image to Go version to 1.19.4 will result in tag to be `1.19.4-rc.1`
   1. Pull docker image from remote to local docker instance: `docker pull -a onsdigital/dp-concourse-tools-$(basename "${PWD}")`
   1. Retrieve latest image id: `docker images -a | grep dp-concourse-tools-$(basename "${PWD}")`
   1. Change tag on existing image: `docker tag <image id retrieved from previous step> onsdigital/dp-concourse-tools-$(basename "${PWD}"):<version, e.g. 1.19.4-rc.1>`
   1. Push docker changes to remote dockerhub: `docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):<version>`

Now it is safe to move on to uploading a new latest version of the image, following steps below.

2. To build and publish an image:

```shell
# $DIR_NAME in the following is one of the directories in this repo
cd $DIR_NAME
docker build -t onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest .
docker push onsdigital/dp-concourse-tools-$(basename "${PWD}"):latest
```

Follow steps in 1. to create a duplicate image tagged with correct semantic version.

Contributing
------------

See [CONTRIBUTING](CONTRIBUTING.md) for details.

License
-------

Copyright © 2021, Office for National Statistics (https://www.ons.gov.uk)

Released under MIT license, see [LICENSE](LICENSE.md) for details.
