#!/bin/bash -eux

# Timeout for waiting for Docker to be ready (in seconds)
TIMEOUT=${TIMEOUT:-30}
WAIT_INTERVAL=2

dockerd &
echo "Checking if Docker is up..."

# Start the timer
SECONDS=0

while true; do
  if docker info > /dev/null 2>&1; then
    echo "Docker is up and running!"
    break
  fi

  # Check if we've exceeded the timeout
  if [ "$SECONDS" -ge "$TIMEOUT" ]; then
    echo "Timeout reached: Docker is not up after $TIMEOUT seconds."
    exit 1
  fi

  echo "Waiting for Docker to be ready..."
  sleep "$WAIT_INTERVAL"
done
