# ONS version of taylorsilva/dcind

This image is used to run component tests in CI

Files were copied from: https://github.com/taylorsilva/dcind

> [!IMPORTANT]
> The upstream repo is no longer maintained.

They were then adjusted and updated such that the resulting image works for both:

  Ubuntu 22.04 and Ubuntu 20.04

to aid updating Concourse VM's from Ubuntu 20.04 to Ubuntu 22.04

## Build and push to AWS ECR instructions

### Prerequisites

Log in to the AWS CI account and in "Elastic Container Registry" ensure there is a repository named "onsdigital/dcind".

If it is missing, create it.

### Building and pushing container to AWS ECR

In a terminal, run:

```shell
make build publish
```

The `publish` might fail if you are no longer using docker-desktop. A possible fix for this is to remove the following line from `~/.docker/config.json`:

```json
    "credsStore": "desktop",
```

And try again.
