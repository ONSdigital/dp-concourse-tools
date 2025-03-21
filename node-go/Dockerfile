FROM golang:1.24.1-bullseye

# Label docker image
LABEL go_version="1.24.1-bullseye"
LABEL node_version="20"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="node-go"
LABEL git_commit="25e88233ab25f22ccc4e76672a3288dfcecb5752"

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.42/nancy-v1.0.42-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=20.* && \
    apt-get clean

CMD /bin/bash
