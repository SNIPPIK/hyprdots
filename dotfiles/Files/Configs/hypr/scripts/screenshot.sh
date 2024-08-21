#!/bin/sh
# -----------------------------------------------------
directory="${HOME}/Pictures/Screenshots"
file="$(date "+%H:%M:%S %d.%m.%Y").png"
# -----------------------------------------------------
# Notification
notify() {
  bash ~/.config/hypr/scripts/utils/notifications.sh "icon" "temp" "Screenshot" "$1" "$2" 4000
}
# -----------------------------------------------------
# Create directory
if [ ! -d "$directory" ]; then
  mkdir "$directory"
fi
# -----------------------------------------------------
# Create screenshot region
if [ "$1" = "region" ]; then
  grim -g "$(slurp)" "$directory/$file"
  wl-copy < "$directory/$file"
  notify "Save in\n- Pictures/Screenshots/$file" "$directory/$file"
fi
# -----------------------------------------------------
# Create screenshot fullscreen
if [ "$1" = "fullscreen" ]; then
  grim "$directory/$file"
  wl-copy < "$directory/$file"
  notify "Save in\n- Pictures/Screenshots/$file" "$directory/$file"
fi