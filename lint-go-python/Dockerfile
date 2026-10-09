ARG GOLANG_VERSION="1.27.2-bookworm"
ARG PYTHON_VERSION="3.15"

FROM golang:${GOLANG_VERSION} AS go-base
ARG GOLANGCILINT_VERSION="2.14.0"

RUN GOTOOLCHAIN=local go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v${GOLANGCILINT_VERSION} \
    && golangci-lint version

FROM python:${PYTHON_VERSION}-bookworm

ARG GOLANG_VERSION
ARG PYTHON_VERSION
ARG GOLANGCILINT_VERSION="2.14.0"
ARG RUFF_VERSION="0.16.10"
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
