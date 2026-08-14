ARG GOLANG_VERSION="1.26.6-bookworm"
ARG PYTHON_VERSION="3.13"

FROM golang:${GOLANG_VERSION} AS go-base
ARG GOLANGCILINT_VERSION="2.12.2"

RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | \
    sh -s -- -b $(go env GOPATH)/bin v${GOLANGCILINT_VERSION}

FROM python:${PYTHON_VERSION}-bookworm

ARG GOLANG_VERSION
ARG PYTHON_VERSION
ARG GOLANGCILINT_VERSION="2.12.2"
ARG RUFF_VERSION="0.16.2"
ARG COMMIT

ENV GOPATH="/go"
ENV PATH="/go/bin:/usr/local/go/bin:${PATH}"

LABEL go_version="${GOLANG_VERSION}"
LABEL python_version="${PYTHON_VERSION}"
LABEL golangci-lint_version="${GOLANGCILINT_VERSION}"
LABEL ruff_version="${RUFF_VERSION}"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="lint-go-python"
LABEL git_commit="${COMMIT}"

COPY --from=go-base /usr/local/go /usr/local/go
COPY --from=go-base /go/bin/golangci-lint /go/bin/golangci-lint

RUN apt-get update && \
    apt-get -y install --no-install-recommends ca-certificates git && \
    pip install --no-cache-dir ruff==${RUFF_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
