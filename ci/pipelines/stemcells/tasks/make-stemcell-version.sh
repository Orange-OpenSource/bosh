#!/usr/bin/env bash

set -e -x

[ -f published-stemcell/version ] || exit 1


mkdir -p out

echo "$(cat published-stemcell/version).0.0" > out/semver
