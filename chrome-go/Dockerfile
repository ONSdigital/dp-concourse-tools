FROM golang:1.24.5-bullseye

RUN wget -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update && \
    apt-get -y install google-chrome-stable && \
    apt-get clean

CMD /bin/bash
