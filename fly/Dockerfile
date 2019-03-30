FROM alpine:3.8

RUN apk add --no-cache \
        bash           \
        curl           \
        make           \
        ruby           \
        && rm -rf /var/cache/apk/*

RUN curl -o /usr/local/bin/fly https://github.com/concourse/concourse/releases/download/v3.10.0/fly_linux_amd64 \
    && chmod +x /usr/local/bin/fly

CMD /bin/bash
