FROM alpine:latest

RUN apk update \
    && apk upgrade \
    && apk add --no-cache --update \
       ca-certificates \
       bash \
       make \
    && rm -rf /var/cache/apk/* 

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v0.1.14/nancy-linux.amd64-v0.1.14" \
    && chmod 755 /usr/local/bin/nancy

CMD /bin/bash
