ARG GOLANG_VERSION="1.25.1"

FROM golang:$GOLANG_VERSION

ARG GOLANG_VERSION
ARG NANCY_VERSION="1.0.51"
# COMMIT should be provided from outside the build file as a build-arg
ARG COMMIT

LABEL go_version="$GOLANG_VERSION"
LABEL nancy_version="$NANCY_VERSION"
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder=nancy
LABEL git_commit="$COMMIT"

# Add nancy
ADD "https://github.com/sonatype-nexus-community/nancy/releases/download/v$NANCY_VERSION/nancy-v$NANCY_VERSION-linux-amd64" /usr/local/bin/nancy
RUN chmod 755 /usr/local/bin/nancy

CMD ["/bin/bash"]
