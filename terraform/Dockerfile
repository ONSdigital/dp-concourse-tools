FROM hashicorp/terraform:0.14.10

RUN apk add --update \
    bash         \
    gnupg        \
    make         \
    && rm -rf /var/cache/apk/*

RUN wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64" \
    && chmod 755 /usr/local/bin/yq

ENTRYPOINT []

CMD /bin/bash
