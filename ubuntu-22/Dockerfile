# 'UBUNTU_VERSION' below needs a default value, and is replaced by build-arg in Makefile
ARG UBUNTU_VERSION="jammy-20260509"

FROM ubuntu:${UBUNTU_VERSION}
ARG UBUNTU_VERSION

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Label docker image
LABEL ubuntu_version="${UBUNTU_VERSION}"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="ubuntu-22"
LABEL git_commit="$COMMIT"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ca-certificates && \
    apt-get clean

CMD [ "/bin/bash" ]
