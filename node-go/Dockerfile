FROM golang:1.19.4

# Label docker image
LABEL go_version="1.19.4"
LABEL node_version="14"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="node-go"
LABEL git_commit=""

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.29/nancy-v1.0.29-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=14.* && \
    apt-get clean

CMD /bin/bash
