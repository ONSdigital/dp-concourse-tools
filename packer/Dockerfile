FROM williamyeh/ansible:alpine3

RUN apk add --update bash curl gzip make && rm -rf /var/cache/apk/*

RUN curl https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip | \
    zcat > /usr/local/bin/packer && chmod +x /usr/local/bin/packer
