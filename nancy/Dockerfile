FROM golang:1.19.4

LABEL go_version=1.19.4
LABEL nancy_version=1.0.29
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder=nancy
LABEL git_commit=89424ebec30e26eb2a668d89d533e58e015e1166

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.29/nancy-v1.0.29-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

CMD /bin/bash
