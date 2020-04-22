FROM golang:1.13.8

RUN curl -o $GOPATH/bin/nancy -sL https://github.com/sonatype-nexus-community/nancy/releases/download/v0.2.0/nancy-linux.amd64-v0.2.0 && chmod 755 $GOPATH/bin/nancy

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=8.* && \
    apt-get clean

CMD /bin/bash
