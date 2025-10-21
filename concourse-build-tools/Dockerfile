## https://hub.docker.com/_/alpine/tags
ARG BASE_IMAGE_ALPINE_VERSION=3.21.2

FROM alpine:${BASE_IMAGE_ALPINE_VERSION} AS builder

# https://github.com/cli/cli/releases
ARG GITHUB_CLI_VERSION=2.79.0

# Install dependencies
RUN apk add --update --no-cache curl ca-certificates upx binutils

# Install GitHub CLI
RUN curl -sL https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz | tar -xvz && \
    mv gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh && \
    chmod +x /usr/local/bin/gh && \
    rm -rf gh_${GITHUB_CLI_VERSION}_linux_amd64
# Optimise binary size
RUN strip --strip-unneeded /usr/local/bin/gh
RUN upx --best --lzma /usr/local/bin/gh


FROM alpine:${BASE_IMAGE_ALPINE_VERSION}

ARG TAG
ARG COMMIT

# Metadata Labels
LABEL org.opencontainers.image.title="Dissemination Concourse Build Image"
LABEL org.opencontainers.image.description="Alpine based image with bash, git, jq, AWS CLI, openssh, yq, curl and sed. Image to be used by the Dissemination Concourse."
LABEL org.opencontainers.image.source="https://github.com/ONSdigital/dp-concourse-tools/concourse-build-tools"
LABEL org.opencontainers.image.documentation="https://github.com/ONSdigital/dp-concourse-tools/README.md"
LABEL org.opencontainers.image.version=${TAG}
LABEL org.opencontainers.image.revision=${COMMIT}

# Install git, jq , aws-cli and openssh
RUN apk add --no-cache bash git jq aws-cli openssh yq curl sed

# Copy binaries from builder stage
COPY --from=builder /usr/local/bin/gh /usr/local/bin/gh

# Copy scripts into the image
COPY assume-role /usr/local/bin/assume-role
RUN chmod +x /usr/local/bin/assume-role
COPY git-credentials /usr/local/bin/git-credentials
RUN chmod +x /usr/local/bin/git-credentials
