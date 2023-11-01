#!/usr/bin/env bash

set -e


function build_firmware() {
  FNAME=$1

  nix-build config -o combined
  cp ./combined/glove80.uf2 "firmware/$FNAME"
  rm -r ./combined
  gum style --foreground 43 "created $FNAME"
}

function wait_for_mount() {
  VOLUME=$1

  while true; do
    if df | grep -q "/Volumes/$VOLUME"; then
      break
    fi
    sleep 0.5
  done
}
