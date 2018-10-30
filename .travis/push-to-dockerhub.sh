#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`
docker tag projectriff/buildpack:latest projectriff/buildpack:${version}
docker tag projectriff/buildpack:latest projectriff/buildpack:${version}-ci-${TRAVIS_COMMIT}

docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
docker push projectriff/buildpack