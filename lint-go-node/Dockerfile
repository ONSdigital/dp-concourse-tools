ARG GOLANG_VERSION="1.26.1-bookworm"

FROM golang:$GOLANG_VERSION

ARG GOLANG_VERSION
ARG NODEJS_VERSION="20.20.1"
ARG GOLANGCILINT_VERSION="2.11.3"

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Label docker image
LABEL go_version="$GOLANG_VERSION"
LABEL node_version="$NODEJS_VERSION"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="lint-go-node"
LABEL git_commit="$COMMIT"

# Setup Node, Install Node, and Install redocly
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=$NODEJS_VERSION* && \
    apt-get clean && \
    npm install -g @redocly/cli

CMD ["/bin/bash"]
