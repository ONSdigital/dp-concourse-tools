FROM alpine:3.8

RUN apk add --no-cache \
        bash           \
        curl           \
        make           \
        ruby-dev       \
        gnupg          \
        tar            \
        libc-dev       \
        gcc            \
        && rm -rf /var/cache/apk/*

RUN gem install json --no-document

RUN cd /usr/local/bin \
    && curl -L https://github.com/concourse/concourse/releases/download/v5.7.2/fly-5.7.2-linux-amd64.tgz | tar -xvz \
    && chmod +x /usr/local/bin/fly

CMD /bin/bash
