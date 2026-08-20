ARG GOLANG_VERSION="1.26.6"
# dind version 29 is not yet compatible with testcontainers-go - please
# ensure compatibility before updating to a newer version of dind.
ARG DOCKER_VERSION="28.5.2-dind"
ARG PYTHON_VERSION="3.14"

FROM python:${PYTHON_VERSION}-alpine AS python-base

FROM docker:${DOCKER_VERSION}

ARG GOLANG_VERSION
ARG DOCKER_VERSION
ARG PYTHON_VERSION

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Label docker image
LABEL go_version="${GOLANG_VERSION}"
LABEL docker_version="${DOCKER_VERSION}"
LABEL python_version="${PYTHON_VERSION}"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="docker-go-python"
LABEL git_commit="${COMMIT}"

# Add image utilities
RUN apk add --no-cache make bash curl tar build-base

# Copy Python runtime and pip from the Python image.
COPY --from=python-base /usr/local/ /usr/local/

# Setup Go
ARG GO_TAR_FILE="go${GOLANG_VERSION}.linux-amd64.tar.gz"
RUN curl -LO https://golang.org/dl/${GO_TAR_FILE} && \
    tar -C /usr/local -xzf ${GO_TAR_FILE} && \
    rm ${GO_TAR_FILE}

# Add Go and Python tools to PATH
ENV PATH="/usr/local/go/bin:/go/bin:${PATH}"
ENV CGO_ENABLED=1

ADD start_docker.sh /start_docker.sh
RUN chmod +x /start_docker.sh

# Force Go to use module mode
ENV GO111MODULE=on
ENV GOPATH=/go

# Add Chromium as well, Chrome not provided for Alpine images
RUN apk update && apk add --no-cache chromium

CMD ["/bin/bash"]
