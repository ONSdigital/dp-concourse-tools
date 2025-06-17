FROM golang:1.24.4-bullseye

ARG NODEJS_VERSION="20.19.2"

# Label docker image
LABEL go_version="1.24.4-bullseye"
LABEL node_version="$NODEJS_VERSION"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="node-go"
LABEL git_commit="25e88233ab25f22ccc4e76672a3288dfcecb5752"

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.48/nancy-v1.0.48-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=$NODEJS_VERSION* && \
    apt-get clean

CMD /bin/bash
