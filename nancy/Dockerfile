FROM golang:1.24.1

LABEL go_version=1.24.1
LABEL nancy_version=1.0.46
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder=nancy
LABEL git_commit=1c88d357db947b763033d5a7ff26376b792c1b59

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.46/nancy-v1.0.46-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

CMD /bin/bash
