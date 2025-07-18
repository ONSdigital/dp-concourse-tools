FROM golang:1.24.5-bullseye

ARG GOLANGCILINT_VERSION="2.1.6"

LABEL go_version="1.24.5-bullseye"
LABEL golangci-lint_version="$GOLANGCILINT_VERSION"

# binary will be $(go env GOPATH)/bin/golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCILINT_VERSION

CMD /bin/bash
