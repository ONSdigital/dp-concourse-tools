FROM hashicorp/terraform:0.13.6

RUN apk add --update \
    bash         \
    gnupg        \
    make         \
    && rm -rf /var/cache/apk/*

RUN wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64" \
    && chmod 755 /usr/local/bin/yq

ENTRYPOINT []

CMD /bin/bash
