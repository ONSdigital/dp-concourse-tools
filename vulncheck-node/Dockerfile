ARG GOLANG_VERSION="1.25.1"

FROM golang:$GOLANG_VERSION

ARG GOLANG_VERSION
ARG DIS_VULNCHECK_VERSION="v0.2.0"
ARG NODEJS_VERSION="20.19.2"
# COMMIT should be provided from outside the build file as a build-arg
ARG COMMIT

LABEL go_version="$GOLANG_VERSION"
LABEL dis_vulncheck_version="${DIS_VULNCHECK_VERSION}"
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder=vulncheck-node
LABEL git_commit="$COMMIT"
LABEL node_version="${NODEJS_VERSION}"

# Add vulncheck dependencies
RUN go install golang.org/x/vuln/cmd/govulncheck@latest
RUN go install github.com/ONSdigital/dis-vulncheck@${DIS_VULNCHECK_VERSION}

# Setup for node
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash

# Add node
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=$NODEJS_VERSION* && \
    apt-get clean

CMD ["/bin/bash"]
