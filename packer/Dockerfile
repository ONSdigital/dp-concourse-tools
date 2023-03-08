# Due to this faccessat2 change: https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.14.0#faccessat2
# we need to continue to use alpine 3.13 until we upgrade to using Docker 20.10.0 or greater, AND libseccomp 2.4.4
# or greater on concourse workers.
FROM ubuntu:20.04

# IF you update the packer version here you should also rebuild the https://github.com/ONSdigital/packer-resource
ENV PACKER_VERSION=1.7.8
LABEL "packer_version"="1.7.8"


ENV ANSIBLE_VERSION=2.10.7
LABEL "ansible_version"="2.10.7"
Run apt update
RUN apt-get -y install \
        bash \
        curl \
        gnupg \
        gzip \
        make \
        git \
        python3-pip \
        dpkg 

RUN pip3 install ansible-base==$ANSIBLE_VERSION
RUN pip3 install ansible==$ANSIBLE_VERSION

RUN curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" | \
        zcat > /usr/local/bin/packer && chmod +x /usr/local/bin/packer

RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
LABEL "session-manager-plugin"="latest"

RUN dpkg -i session-manager-plugin.deb