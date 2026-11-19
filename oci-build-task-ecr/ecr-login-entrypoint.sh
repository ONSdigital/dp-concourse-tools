#!/bin/sh
set -e

if [ -z "$AWS_REGION" ]; then
    echo "AWS_REGION not set"
    exit 1
fi

if [ -z "$ECR_REPOSITORY_URI" ]; then
    echo "ECR_REPOSITORY_URI not set"
    exit 1
fi

echo "Starting ECR authentication process..."

if [ "${ECR_AUTH}" = "true" ]; then
  #Login to ECR -> Create Docker config -> Save
  echo "ECR authentication enabled, logging in to ${ECR_REPOSITORY_URI}..."
  
  mkdir -p ${HOME}/.docker
    
  ECR_TOKEN=$(aws ecr get-login-password --region ${AWS_REGION})
  AUTH_TOKEN=$(echo "AWS:${ECR_TOKEN}" | base64)
  DOCKER_CONFIG=$(jq -n --arg ecr_registry "$ECR_REPOSITORY_URI" --arg auth_token "$AUTH_TOKEN" '{"auths":{($ecr_registry): {"auth": $auth_token}}}')
  
  echo "Generated Docker config"

  echo $DOCKER_CONFIG > $HOME/.docker/config.json  

  echo "Successfully authenticated with ECR"
else
  echo "ECR authentication not enabled, skipping..."
fi

echo "Running build command..."
exec /usr/bin/build "$@"