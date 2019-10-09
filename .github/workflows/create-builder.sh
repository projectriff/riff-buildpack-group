#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

pack create-builder -b builder.toml projectriff/builder:latest
