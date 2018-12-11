#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

wget -qO- https://github.com/buildpack/pack/releases/download/v0.0.7/pack-0.0.7-linux.tar.gz | tar xvz -C $HOME/bin
export PATH="$HOME/bin:$PATH"

