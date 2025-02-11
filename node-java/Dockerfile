FROM maven:3.8.8-eclipse-temurin-8

RUN apt-get -y update \
    && apt-get -y install xz-utils make \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://nodejs.org/dist/v22.13.1/node-v22.13.1-linux-x64.tar.xz -o node.tar.xz \
    && tar -xf node.tar.xz -C /usr/local --strip-components=1 \
    && rm node.tar.xz

CMD /bin/bash
