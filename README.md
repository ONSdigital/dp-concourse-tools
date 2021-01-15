Digital Publishing Concourse Tools
==================================

Build tools we use in our Concourse CI pipelines as docker images.

Getting started
---------------

All images are currently published to Docker Hub. You will require a login to the ONSdigital Docker Hub organisation to continue.

To build and publish an image:

```shell
# $DIR_NAME in the following is one of the directories in this repo
cd $DIR_NAME
docker build -t onsdigital/dp-concourse-tools-$DIR_NAME:latest .
docker push onsdigital/dp-concourse-tools-$DIR_NAME:latest
```

Contributing
------------

See [CONTRIBUTING](CONTRIBUTING.md) for details.

License
-------

Copyright © 2021, Office for National Statistics (https://www.ons.gov.uk)

Released under MIT license, see [LICENSE](LICENSE.md) for details.
