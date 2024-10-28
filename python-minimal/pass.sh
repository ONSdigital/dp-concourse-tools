#!/usr/bin/env bash

docker run -it --rm -e INPUT_FILE='helloworld.py' -v $PWD:/usr/src/app onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12 helloworld.py

exit_code=$?

echo "The exit code is:"

# should see '0'

echo $exit_code
