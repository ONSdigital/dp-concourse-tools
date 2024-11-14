FROM ubuntu:focal-20241011

# Label docker image
LABEL ubuntu_version="ubuntu:focal-20241011"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="ubuntu-20"
LABEL git_commit="1a6c965fd00b4e4fa5145f53c131a5540f1a8808"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ca-certificates && \
    apt-get clean

CMD /bin/bash
