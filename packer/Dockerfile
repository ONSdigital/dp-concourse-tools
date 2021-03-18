FROM alpine:3

ENV ANSIBLE_VERSION=2.10.6-r0
ENV PACKER_VERSION=1.7.0

RUN apk add --no-cache \
        bash \
        curl \
        gnupg \
        gzip \
        make \
        git \
        ansible=$ANSIBLE_VERSION

RUN curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" | \
    zcat > /usr/local/bin/packer && chmod +x /usr/local/bin/packer
