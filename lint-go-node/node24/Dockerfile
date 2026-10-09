ARG GOLANG_VERSION="1.27.2-bookworm"

FROM golang:$GOLANG_VERSION

ARG GOLANG_VERSION
ARG NODEJS_VERSION="24.21.0"
ARG GOLANGCILINT_VERSION="2.14.0"

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Label docker image
LABEL go_version="$GOLANG_VERSION"
LABEL node_version="$NODEJS_VERSION"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="lint-go-node-24"
LABEL git_commit="$COMMIT"
LABEL golangci-lint_version="$GOLANGCILINT_VERSION"

# binary will be $(go env GOPATH)/bin/golangci-lint
RUN GOTOOLCHAIN=local go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v${GOLANGCILINT_VERSION} \
    && golangci-lint version

# Setup Node, Install Node, and Install redocly / asyncapi
RUN curl -sL https://deb.nodesource.com/setup_24.x | bash && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=$NODEJS_VERSION* && \
    apt-get clean && \
    npm install -g @redocly/cli \
    npm install -g @asyncapi/cli

CMD ["/bin/bash"]
