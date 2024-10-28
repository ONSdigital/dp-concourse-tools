#!/usr/bin/env bash

# this is missing: '-e INPUT_FILE='helloworld.py'
# to see that the error exit code will come back to the caller that any python app
# being run by the container in concourse CI will get error exit code

docker run -it --rm -v $PWD:/usr/src/app onsdigital/dp-concourse-tools-python-minimal:3.20.3-python-3.12 helloworld.py

exit_code=$?

echo "The exit code is:"

# should see '1'

echo $exit_code
