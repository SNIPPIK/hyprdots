#!/bin/sh
# -----------------------------------------------------
directory="${HOME}/Pictures/Screenshots"
file="$(date "+%H:%M:%S %d.%m.%Y").png"
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
fi
# -----------------------------------------------------
# Create screenshot fullscreen
if [ "$1" = "fullscreen" ]; then
  grim "$directory/$file"
  wl-copy < "$directory/$file"
fi