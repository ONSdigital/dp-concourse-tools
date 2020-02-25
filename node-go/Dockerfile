FROM golang:1.13.8

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install nodejs=8.* && \
    apt-get clean

CMD /bin/bash
