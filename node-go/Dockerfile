FROM golang:1.9.1

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash

RUN apt-get -y update  && \
    apt-get -y upgrade && \
    apt-get -y install nodejs

CMD /bin/bash
