FROM golang:1.24.1

LABEL go_version=1.24.1
LABEL nancy_version=1.0.46
LABEL git_repo=https://github.com/ONSdigital/dp-concourse-tools
LABEL folder=nancy
LABEL git_commit=39d389d5fc325d37880b20636f3b51c62894479c

RUN wget -O /usr/local/bin/nancy "https://github.com/sonatype-nexus-community/nancy/releases/download/v1.0.46/nancy-v1.0.46-linux-amd64" \
    && chmod 755 /usr/local/bin/nancy

CMD /bin/bash
