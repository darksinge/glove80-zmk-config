#!/usr/bin/env bash

set -e

BG="234"
FG="117"

VOLUME="GLV80LHBOOT"
TS=$(date -u +"%Y%m%d%H%M%S")
OUTFILE="$TS-glove80.uf2"
PROMPT=1
BUILD=1
BUILD_ONLY=0
PICK_FIRMWARE=0

function usage() {
  echo "Usage: flash.sh [OPTIONS]"
  echo
  echo "Options:"
  echo "  --no-prompt               Disables interactive prompts during execution."
  echo "  -p, --pick-firmware       Enables firmware selection mode."
  echo "  -o, --outfile             Specifies the output file for the script's results."
  echo "  --no-build                Disables the build process."
  echo "  --build-only              Executes only the build process, without other script actions."
  echo "  -h, --help                Displays this help message."
}

for arg in "$@"; do
  case "$arg" in
    '--no-prompt')
      PROMPT=0
      ;;

    '-p' | '--pick-firmware')
      PICK_FIRMWARE=1
      ;;

    '-o' | '--outfile')
      OUTFILE="$arg"
      ;;

    '--no-build')
      BUILD=0
      ;;

    '--build-only')
      BUILD_ONLY=1
      ;;
    '--help' | '-h')
      usage
      exit 0
      ;;
  esac
done

clear;

if [ $BUILD_ONLY == 1 ]; then
  BUILD=1
fi

if [ $BUILD == 1 ]; then
  gum spin \
    --spinner minidot --title.foreground "$FG" \
    --title "Building firmware..." \
    --show-output \
    -- bash -c "source ./scripts/functions.sh && build_firmware $OUTFILE"
fi

if [ $BUILD_ONLY == 1 ]; then
  exit 0
fi

if [ $PICK_FIRMWARE == 1 ]; then
  OUTFILE=$(ls -1 ./firmware | grep '.uf2$' | gum filter)
fi

if [ $PROMPT == 1 ]; then
  gum confirm --prompt.background "$BG" --prompt.foreground "$FG" \
    --selected.background "$FG" \
    --selected.foreground "$BG" \
    "Would you like to flash the firmware now?" && true || exit 0
fi

gum style \
	--foreground "$FG" --border-foreground 212 --border double \
	--align center --margin "1 2" --padding "1 1" \
	"Please put your Glove80 into bootloader mode"

gum spin \
  --spinner points --title.foreground "$FG" \
  --title "Searching for Glove80 mount point" \
  -- bash -c "source ./scripts/functions.sh && wait_for_mount ${VOLUME}"

gum spin \
  --spinner line --title.foreground "$FG" \
  --title "Copying firmware..." \
  -- cp "firmware/$OUTFILE" "/Volumes/$VOLUME/" > /dev/null || true

osascript -e 'display notification "Glove80 keyboard flashing successful" with title "Glove80 Firmware Build Script" subtitle "Keyboard flashing complete."'

(sleep 4.5 && clear_disk_not_ejected_notifications > /dev/null || true) & disown
