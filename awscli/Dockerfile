FROM alpine:3.7

RUN apk add --update \
    bash         \
    gnupg        \
    jq           \
    py-pip       \
    && rm -rf /var/cache/apk/* \
    && wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/3.2.0/yq_linux_amd64" \
    && chmod 755 /usr/local/bin/yq

RUN pip install awscli
