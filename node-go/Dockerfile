FROM golang:1.9.2

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash

RUN apt-get -y update  && \
    apt-get -y upgrade && \
    apt-get -y install nodejs

CMD /bin/bash
