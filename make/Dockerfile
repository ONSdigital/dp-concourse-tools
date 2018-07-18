FROM alpine:3.8

RUN apk add --no-cache \
        bash           \
        make           \
        tar            \
        gzip           \
        zip            \
        && rm -rf /var/cache/apk/*

CMD /bin/bash
