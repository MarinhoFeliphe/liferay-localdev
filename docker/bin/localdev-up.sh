#!/usr/bin/env bash

set -ex

if [ -z "$LOCALDEV_REPO" ]; then
  echo "Must specify LOCALDEV_REPO env var"
  exit 1
fi

if [ -z "$DOCKER_NETWORK" ]; then
  echo "Must specify DOCKER_NETWORK env var"
  exit 1
fi

(sleep 5 && open "http://localhost:10350/r/(all)/overview") &

docker run \
  --name localdev-server \
  --network ${DOCKER_NETWORK} \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v localdevGradleCache:/root/.gradle \
  -v localdevLiferayCache:/root/.liferay \
  -v $LOCALDEV_REPO:/repo \
  -v $(pwd):/workspace/client-extensions \
  --expose 10350 \
  -p 10350:10350 \
  -e DO_NOT_TRACK="1" \
  localdev-server \
  tilt up -f /repo/tilt/Tiltfile --stream