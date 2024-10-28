#!/bin/sh

docker run -it --rm -v $PWD:/usr/src/app onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12 "$@"
