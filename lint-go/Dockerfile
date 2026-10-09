ARG GOLANG_VERSION="1.27.2-bookworm"

FROM golang:$GOLANG_VERSION

# Has to be redeclared
ARG GOLANG_VERSION
ARG GOLANGCILINT_VERSION="2.14.0"

LABEL go_version="${GOLANG_VERSION}"
LABEL golangci-lint_version="$GOLANGCILINT_VERSION"

# binary will be $(go env GOPATH)/bin/golangci-lint
RUN GOTOOLCHAIN=local go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v${GOLANGCILINT_VERSION} \
    && golangci-lint version

CMD /bin/bash
