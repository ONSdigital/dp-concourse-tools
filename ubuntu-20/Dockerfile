FROM ubuntu:focal-20241011

# Label docker image
LABEL ubuntu_version="ubuntu:focal-20241011"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="ubuntu-20"
LABEL git_commit="5fff27f41bee13899ee7e5e84aa25b823627f685"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ca-certificates && \
    apt-get clean

CMD /bin/bash
