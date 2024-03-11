#!/usr/bin/env node

// set -e

// BG="234"
// FG="117"

// VOLUME="GLV80LHBOOT"

// # clear;

// # Find the most recently created file starting with glove80.uf2 and ending in .zip
// ls -lt $HOME/Downloads/glove80.uf2*.zip 2>/dev/null | head -n 1 | awk '{print $9}'

// exit 0

// gum style \
// 	--foreground "$FG" --border-foreground 212 --border double \
// 	--align center --margin "1 2" --padding "1 1" \
// 	"Please put your Glove80 into bootloader mode"

// gum spin \
//   --spinner points --title.foreground "$FG" \
//   --title "Searching for Glove80 mount point" \
//   -- bash -c "source ./scripts/functions.sh && wait_for_mount ${VOLUME}"

// gum spin \
//   --spinner line --title.foreground "$FG" \
//   --title "Copying firmware..." \
//   -- cp "firmware/$OUTFILE" "/Volumes/$VOLUME/" > /dev/null || true

// osascript -e 'display notification "Glove80 keyboard flashing successful" with title "Glove80 Firmware Build Script" subtitle "Keyboard flashing complete."'

// (sleep 4.5 && clear_disk_not_ejected_notifications > /dev/null || true) & disown

const fs = require("node:fs");
const path = require("node:path");
const { execSync } = require("node:child_process");

const re = /^glove80.uf2 \((?<revision>\d+)\)\.zip/;

const cmds = {
  load: [
    `gum style`,
    `--foreground "$FG" --border-foreground 212 --border double`,
    `--align center --margin "1 2" --padding "1 1"`,
    `"Please put your Glove80 into bootloader mode"`,
  ].join(" "),
};

const getRevision = (fname) => {
  const match = fname.match(re);
  const rev = +match?.at(1);
  return rev || -1;
};

const main = () => {
  const dir = path.join(process.env.HOME, "Downloads");

  const files = fs.readdirSync(dir).filter((file) => re.test(file));

  files.sort((a, b) => {
    return getRevision(b) - getRevision(a);
  });

  const file = files
    .at(0)
    .replace("(", "\\(")
    .replace(")", "\\)")
    .replace(" ", "\\ ");

  const zipPath = path.join(dir, file);
  console.log("zipPath:", zipPath);
  execSync(`unzip -j ${zipPath} glove80.uf2`);
  // execSync(cmds.load);
};

if (require.main === module) {
  main();
}
