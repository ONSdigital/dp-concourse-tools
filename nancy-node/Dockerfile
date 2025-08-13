ARG GOLANG_VERSION="1.24.6-bookworm"

FROM golang:$GOLANG_VERSION

ARG NODEJS_VERSION="20.19.2"
ARG NANCY_VERSION="1.0.51"

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Has to be redeclared
ARG GOLANG_VERSION

LABEL go_version="$GOLANG_VERSION"
LABEL nancy_version="$NANCY_VERSION"
LABEL node_version="$NODEJS_VERSION"
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder="nancy-node"
LABEL git_commit="$COMMIT"

# Add Nancy
ADD "https://github.com/sonatype-nexus-community/nancy/releases/download/v$NANCY_VERSION/nancy-v$NANCY_VERSION-linux-amd64" /usr/local/bin/nancy
RUN chmod 755 /usr/local/bin/nancy

# Setup for node
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash

# Add node
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=$NODEJS_VERSION* && \
    apt-get clean

CMD ["/bin/bash"]
