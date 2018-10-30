#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail


pack create-builder -b builder-riff.toml projectriff/buildpack:latest
