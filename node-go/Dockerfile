ARG BASE_IMAGE_GOLANG_VERSION="1.25.1-bookworm"

FROM golang:$BASE_IMAGE_GOLANG_VERSION

ARG BASE_IMAGE_GOLANG_VERSION
ARG NODE_VERSION="20.19.2"

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Label docker image
LABEL go_version="$BASE_IMAGE_GOLANG_VERSION"
LABEL node_version="$NODE_VERSION"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="node-go"
LABEL git_commit="$COMMIT"

# Setup Node
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash

# Install Node
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=$NODE_VERSION* && \
    apt-get clean

CMD ["/bin/bash"]
