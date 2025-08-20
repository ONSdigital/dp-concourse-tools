FROM concourse/oci-build-task:master AS builder

LABEL oci_build_task_version="master"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL git_commit="1757c56a789415bd6a0e25f8176f6fcdfc2be590"
LABEL folder="oci-build-task-ecr"

RUN apk update && apk add --no-cache aws-cli jq

FROM builder as final

COPY ecr-login-entrypoint.sh /usr/local/bin/ecr-login-entrypoint.sh
RUN chmod +x /usr/local/bin/ecr-login-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ecr-login-entrypoint.sh"]
