FROM maven:3.9.9-eclipse-temurin-17

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install make && \
    rm -rf /var/lib/apt/lists/* 

CMD /bin/bash
