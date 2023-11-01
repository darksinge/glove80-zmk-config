#!/usr/bin/env bash

set -e


BG="234"
FG="117"
FG_WARN="16"

TS=$(date -u +"%Y%m%d%H%M%S")
FILE="$TS-glove80.uf2"
VOLUME="GLV80LHBOOT"

gum spin --spinner minidot --title.foreground "$FG" --title "Building firmware..." --show-output -- bash -c "source ./scripts/functions.sh && build_firmware $FILE"

gum confirm --prompt.background "$BG" --prompt.foreground "$FG" --selected.background "$FG" --selected.foreground "$BG" "Would you like to flash the firmware now?" && true || exit 0

gum style \
	--foreground "212" --border-foreground 6 --border double \
	--align center --margin "1 2" --padding "1 1" \
	'Please put your Glove80 into bootloader mode'

gum spin --spinner dot --title.foreground "$FG" --title "Searching for Glove80 keyboard..." -- bash -c "source ./scripts/functions.sh && wait_for_mount ${VOLUME}"
gum spin --spinner dot --title.foreground "$FG" --title "Copying firmware..." -- cp "firmware/$FILE" "/Volumes/$VOLUME/"

