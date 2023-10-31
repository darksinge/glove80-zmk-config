#!/usr/bin/env bash

set -eu

# nix-build config --store /nix-store -o combined
nix-build config -o combined

for arg in "$@"; do
 if [ "$arg" == "--build-only" ]; then
  break
 fi
done

NOW=$(date -u +"%Y%m%d%H%M%S")
cp combined/glove80.uf2 ./firmware/${TIMESTAMP:-"$NOW"}-glove80.uf2
