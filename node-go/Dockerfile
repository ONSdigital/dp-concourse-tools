FROM golang:1.15.7

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.11/nancy-v1.0.11-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=13.* && \
    apt-get clean

CMD /bin/bash
