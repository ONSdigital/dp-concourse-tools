FROM alpine:latest

RUN apk update \
    && apk add --no-cache --update \
       ca-certificates \
       bash \
       make \
    && rm -rf /var/cache/apk/*

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.8/nancy-v1.0.8-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

CMD /bin/bash
