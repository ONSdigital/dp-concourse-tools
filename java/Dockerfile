FROM maven:3.10.0-eclipse-temurin-17

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install make && \
    rm -rf /var/lib/apt/lists/* 

CMD /bin/bash
