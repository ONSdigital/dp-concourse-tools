ARG GOLANG_VERSION="1.24.9"
ARG DOCKER_VERSION="24.0.7-dind"

FROM docker:$DOCKER_VERSION

ARG GOLANG_VERSION
ARG DOCKER_VERSION

# COMMIT should be set from outside the buildfile as a build-arg
ARG COMMIT

# Label docker image
LABEL go_version="$GOLANG_VERSION"
LABEL docker_version="$DOCKER_VERSION"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="docker-go"
LABEL git_commit="$COMMIT"

# Add image utilities 
RUN apk add --no-cache make bash curl tar build-base

# Setup Go
ARG GO_TAR_FILE="go$GOLANG_VERSION.linux-amd64.tar.gz"
RUN curl -LO https://golang.org/dl/${GO_TAR_FILE} \
    && tar -C /usr/local -xzf ${GO_TAR_FILE} \
    && rm ${GO_TAR_FILE}

# Add Go to Path
ENV PATH="/usr/local/go/bin:$PATH"
ENV CGO_ENABLED=1

ADD start_docker.sh /start_docker.sh
RUN chmod +x /start_docker.sh

# Force Go to use module mode
ENV GO111MODULE=on
ENV GOPATH=/go
ENV PATH="$GOPATH/bin:$PATH"

# Add Chromium as well, Chrome not provided for Alpine images
RUN apk update && apk add --no-cache chromium

CMD ["/bin/bash"]
