#!/bin/bash
set -euo pipefail

SCREENSHOT_FILENAME=$(date +'%Y-%m-%dT%H:%M:%S%z_grim.jpg')
SCREENSHOT_FILENAME_ABSOLUTE=$HOME/Images/$SCREENSHOT_FILENAME
notify-send "Screen capture" "Capture to: $SCREENSHOT_FILENAME_ABSOLUTE"
grim $SCREENSHOT_FILENAME_ABSOLUTE
