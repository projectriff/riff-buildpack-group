#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`
id=`docker image inspect projectriff/builder --format '{{.Id}}' | awk '{print substr($1, 8, 12)}'`
CI_TAG="${version}-ci-${id}"

gcloud auth activate-service-account --key-file <(echo $GCLOUD_CLIENT_SECRET | base64 --decode)

# function build template
sed "s|projectriff/builder:latest|projectriff/builder:${CI_TAG}|" riff-function-clusterbuildtemplate.yaml > riff-function-clusterbuildtemplate-${CI_TAG}.yaml
sed "s|projectriff/builder:latest|projectriff/builder:${version}|" riff-function-clusterbuildtemplate.yaml > riff-function-clusterbuildtemplate-${version}.yaml

gsutil cp -a public-read riff-function-clusterbuildtemplate-${CI_TAG}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp -a public-read riff-function-clusterbuildtemplate-${version}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp -a public-read riff-function-clusterbuildtemplate-${CI_TAG}.yaml gs://projectriff/riff-buildtemplate/riff-function-clusterbuildtemplate.yaml

# application build template
gsutil cp -a public-read riff-application-clusterbuildtemplate.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuildtemplate-${CI_TAG}.yaml
gsutil cp -a public-read riff-application-clusterbuildtemplate.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuildtemplate-${version}.yaml
gsutil cp -a public-read riff-application-clusterbuildtemplate.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuildtemplate.yaml
