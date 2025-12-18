ARG GOLANG_VERSION="1.25.5"

FROM golang:$GOLANG_VERSION

ARG GOLANG_VERSION
ARG DIS_VULNCHECK_VERSION="v0.3.0"
# COMMIT should be provided from outside the build file as a build-arg
ARG COMMIT

LABEL go_version="$GOLANG_VERSION"
LABEL dis_vulncheck_version="${DIS_VULNCHECK_VERSION}"
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder=vulncheck
LABEL git_commit="$COMMIT"

RUN go install golang.org/x/vuln/cmd/govulncheck@latest
RUN go install github.com/ONSdigital/dis-vulncheck@${DIS_VULNCHECK_VERSION}

CMD ["/bin/bash"]
