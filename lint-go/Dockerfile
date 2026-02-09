ARG GOLANG_VERSION="1.24.13-bookworm"

FROM golang:$GOLANG_VERSION

# Has to be redeclared
ARG GOLANG_VERSION
ARG GOLANGCILINT_VERSION="2.8.0"

LABEL go_version="${GOLANG_VERSION}"
LABEL golangci-lint_version="$GOLANGCILINT_VERSION"

# binary will be $(go env GOPATH)/bin/golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCILINT_VERSION

CMD /bin/bash
