FROM maven:3.8.8-eclipse-temurin-8

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install nodejs=8.* make \
    && rm -rf /var/lib/apt/lists/*

CMD /bin/bash
