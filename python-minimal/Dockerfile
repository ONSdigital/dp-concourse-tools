# This Dockerfile was derived from:
#    https://github.com/CrafterKolyan/tiny-python-docker-image/blob/main/Dockerfile.scratch-minimal

# 'ALPINE_VERSION' below needs a default value, and is replaced by build-arg in Makefile
ARG ALPINE_VERSION="3.20.3"

FROM alpine:${ALPINE_VERSION} AS builder
ARG PYTHON_VERSION

RUN apk add --no-cache python3~=${PYTHON_VERSION}
WORKDIR /usr/lib/python${PYTHON_VERSION}
RUN python -m compileall -o 2 .
RUN find . -name "*.cpython-*.opt-2.pyc" | awk '{print $1, $1}' | sed 's/__pycache__\///2' | sed 's/.cpython-[0-9]\{2,\}.opt-2//2' | xargs -n 2 mv
# The following saves 15MB
# with the following commented out, when running python script it first outputs these warnings:
#   Could not find platform independent libraries <prefix>
#   Could not find platform dependent libraries <exec_prefix>
# which are typically not a problem, but if you require whats been removed, please build a new image (which will be larger)
# and use that instead of making this image larger.
RUN find . -mindepth 1 | grep -v -E '^\./(encodings)([/.].*)?$' | xargs rm -rf
# The following saves 10MB
RUN find . -name "*.py" -delete
# The following saves 10MB
RUN find . -name "__pycache__" -exec rm -r {} +

# With the above the RUN's in place, final image size is ~ 15.1MB

FROM alpine:${ALPINE_VERSION} AS final
ARG PYTHON_VERSION

COPY --from=builder /usr/bin/python3 /usr/bin/python3
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/lib/libpython${PYTHON_VERSION}.so.1.0 /usr/lib/libpython${PYTHON_VERSION}.so.1.0
COPY --from=builder /usr/lib/python${PYTHON_VERSION}/ /usr/lib/python${PYTHON_VERSION}/

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# This gets us to the: Python Standard REPL, thus allowing the exit code of the python script
# to be returned to the concourse CI executor of this docker image:
ENTRYPOINT ["/usr/bin/python3"]
