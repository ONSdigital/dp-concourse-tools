ARG GOLANG_VERSION="1.26.0-bookworm"

FROM golang:$GOLANG_VERSION

# Has to be redeclared
ARG GOLANG_VERSION

LABEL go_version="$GOLANG_VERSION"
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder="chrome-go"

ARG CHROME_KEY_NAME="/usr/share/keyrings/google-linux-signing-key.gpg"

RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o "$CHROME_KEY_NAME" \
    && echo "deb [signed-by=$CHROME_KEY_NAME] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update && \
    apt-get -y install google-chrome-stable && \
    apt-get clean

CMD /bin/bash
