# oci-build-task-ecr image

Based off the Concourse CI [oci-build-task](https://github.com/concourse/oci-build-task) image, which is the most recent way of building Docker images in Concourse.

Unlike the older [docker-image-resource](https://github.com/concourse/docker-image-resource/) task, the `oci-build-task` task does not support pushing to OCI image repositories other than `docker.io`.

This image comes with AWS CLI installed + an shell script for an entrypoint to:
1. Authenticate with a provider ECR registry
2. Export the credentials for the registry to the Docker config at `~/.docker/config.json`
3. Execute the normal build task

## Usage

This image should be used the same way as the `oci-build-task` image, so for full examples view either:
1. [The README in their repository](https://github.com/concourse/oci-build-task)
2. Their guide for [building and pushing an image](https://concourse-ci.org/building-and-pushing-an-image.html)

For using ECR as a repository, the following params must be set:
- `ECR_AUTH` should be set to `true`
- `ECR_REPOSITORY_URI` must match the ECR repository you wish to access
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION` must be set to the relevant AWS credentials

You must also set the `path` of `run` in the Concourse CI task to be `/usr/local/bin/ecr-login-entrypoint.sh`

E.g.
```yaml
params:
    CONTEXT: .
    DOCKERFILE: Dockerfile
    AWS_ACCESS_KEY_ID: ((aws_access_key_id))
    AWS_SECRET_ACCESS_KEY: ((aws_secret_access_key))
    AWS_REGION: ((aws_region))
    ECR_REPOSITORY_URI: ((aws_ecr_registry_uri))
    ECR_AUTH: true
run:
    path: /usr/local/bin/ecr-login-entrypoint.sh
```