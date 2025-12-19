## https://hub.docker.com/_/alpine/tags
ARG BASE_IMAGE_ALPINE_VERSION=3.21.2

FROM alpine:${BASE_IMAGE_ALPINE_VERSION} AS builder

## https://github.com/helm/helm/releases
ARG HELM_VERSION=3.2.1
## https://releases.hashicorp.com/terraform/
ARG TERRAFORM_VERSION=1.10.5
# https://kubernetes.io/releases/
ARG KUBECTL_VERSION=1.32.1

# Install dependencies
RUN apk add --update --no-cache curl ca-certificates upx binutils

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
# Optimise binary size
RUN strip --strip-unneeded /usr/local/bin/terraform
RUN upx --best --lzma /usr/local/bin/terraform

# # Install Helm
RUN curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xvz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64
# Optimise binary size
RUN strip --strip-unneeded /usr/local/bin/helm
RUN upx --best --lzma /usr/local/bin/helm

# # Install kubectl
RUN curl -sLO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl
# Optimise binary size
RUN strip --strip-unneeded /usr/local/bin/kubectl
RUN upx --best --lzma /usr/local/bin/kubectl

# Install AWS CLI
# RUN apk add --no-cache aws-cli



FROM alpine:${BASE_IMAGE_ALPINE_VERSION}

ARG TAG
ARG COMMIT

# Metadata Labels
LABEL org.opencontainers.image.title="Dissemination Terraform Image"
LABEL org.opencontainers.image.description="Alpine based image with Terraform, Helm, and kubectl. For compatibility with Dissemination terraform structure and EKS deployments."
LABEL org.opencontainers.image.source="https://github.com/ONSdigital/dp-concourse-tools/terraform-alpine"
LABEL org.opencontainers.image.documentation="https://github.com/ONSdigital/dp-concourse-tools/terraform/README.md"
LABEL org.opencontainers.image.version=${TAG}
LABEL org.opencontainers.image.revision=${COMMIT}
# org.opencontainers.image.vendor
# org.opencontainers.image.licenses
# org.opencontainers.image.ref.name
# org.opencontainers.image.created
# org.opencontainers.image.authors
# org.opencontainers.image.url

# Install git, jq , aws-cli and openssh
RUN apk add --no-cache git jq aws-cli openssh

# Copy binaries from builder stage
COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl

# Copy scripts into the image
COPY assume-role /usr/local/bin/assume-role
RUN chmod +x /usr/local/bin/assume-role
COPY git-credentials /usr/local/bin/git-credentials
RUN chmod +x /usr/local/bin/git-credentials
