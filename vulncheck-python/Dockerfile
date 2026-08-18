ARG GOLANG_VERSION="1.26.6-bookworm"
ARG PYTHON_VERSION="3.14"

FROM golang:${GOLANG_VERSION} AS go-base
ARG DIS_VULNCHECK_VERSION="v0.6.0"

RUN go install golang.org/x/vuln/cmd/govulncheck@latest && \
	go install github.com/ONSdigital/dis-vulncheck@${DIS_VULNCHECK_VERSION}

FROM python:${PYTHON_VERSION}-bookworm

ARG GOLANG_VERSION
ARG PYTHON_VERSION
ARG DIS_VULNCHECK_VERSION="v0.6.0"
ARG PIP_AUDIT_VERSION="2.10.1"
ARG COMMIT

ENV GOPATH="/go"
ENV PATH="/usr/local/go/bin:/go/bin:${PATH}"

LABEL go_version="${GOLANG_VERSION}"
LABEL python_version="${PYTHON_VERSION}"
LABEL dis_vulncheck_version="${DIS_VULNCHECK_VERSION}"
LABEL pip_audit_version="${PIP_AUDIT_VERSION}"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="vulncheck-python"
LABEL git_commit="${COMMIT}"

COPY --from=go-base /usr/local/go /usr/local/go
COPY --from=go-base /go/bin/dis-vulncheck /go/bin/dis-vulncheck

RUN apt-get update && \
	apt-get -y install --no-install-recommends ca-certificates git && \
	pip install --no-cache-dir pip-audit==${PIP_AUDIT_VERSION} && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
