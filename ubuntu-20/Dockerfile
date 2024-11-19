# 'UBUNTU_VERSION' below needs a default value, and is replaced by build-arg in Makefile
ARG UBUNTU_VERSION="focal-20241011"

FROM ubuntu:${UBUNTU_VERSION}
ARG UBUNTU_VERSION

# Label docker image
LABEL ubuntu_version="${UBUNTU_VERSION}"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL folder="ubuntu-20"
LABEL git_commit="5fff27f41bee13899ee7e5e84aa25b823627f685"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ca-certificates && \
    apt-get clean

CMD [ "/bin/bash" ]
