ARG GOLANG_VERSION="1.24.6-bookworm"

FROM golang:$GOLANG_VERSION

# Has to be redeclared
ARG GOLANG_VERSION

LABEL go_version="$GOLANG_VERSION"
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder="chrome-go"


RUN wget -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update && \
    apt-get -y install google-chrome-stable && \
    apt-get clean

CMD /bin/bash
