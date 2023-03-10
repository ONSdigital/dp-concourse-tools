FROM ubuntu:22.04

RUN apt update
RUN apt-get -y install \
        curl \
        gzip \
        make \
        git \
        python3-pip

ENV ANSIBLE_CORE_VERSION=2.14.3
LABEL "ansible_core_version"=${ANSIBLE_CORE_VERSION}
RUN pip3 install ansible-core==${ANSIBLE_CORE_VERSION} 

ENV PACKER_VERSION=1.8.6
LABEL "packer_version"=${PACKER_VERSION}
RUN curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" | \
        zcat > /usr/local/bin/packer && chmod +x /usr/local/bin/packer

ENV SESSION_MANAGER_PLUGIN_VERSION=1.2.398.0
LABEL "session-manager-plugin"=${SESSION_MANAGER_PLUGIN_VERSION}
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/${SESSION_MANAGER_PLUGIN_VERSION}/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"

RUN dpkg -i session-manager-plugin.deb