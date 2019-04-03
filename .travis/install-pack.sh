#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# TODO use a released version of pack once there is a release to consume
# wget -qO- https://github.com/buildpack/pack/releases/download/v0.1.0/pack-0.1.0-linux.tar.gz | tar xvz -C $HOME/bin
# export PATH="$HOME/bin:$PATH"

# master as of 2019-04-02
GO111MODULE=on go get github.com/buildpack/pack/cmd/pack@d8ba851f1a0d9181f4265239bead7ab1fa6882c7
