#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# TODO use a released version of pack once there is a release to consume
# wget -qO- https://github.com/buildpack/pack/releases/download/v0.0.8/pack-0.0.8-linux.tar.gz | tar xvz -C $HOME/bin
# export PATH="$HOME/bin:$PATH"

# master as of 2019-03-21
GO111MODULE=on go get github.com/buildpack/pack/cmd/pack@ebc7c99fc236c4757c6138dfe9234e575f56fb18
