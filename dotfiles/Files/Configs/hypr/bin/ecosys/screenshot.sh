#!/bin/bash
#  ____                               _           _
# / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_
# \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __|
#  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_
# |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__|
# -----------------------------------------------------
directory="${HOME}/Pictures/Screenshots"
file="$(date "+%H:%M:%S %d.%m.%Y").png"
# -----------------------------------------------------
# Notification
function notify() {
  bash ~/.config/dunst/client/notifications.sh "icon" "temp" "Screenshot" "$1" "$2" 4000
}

# Check file
function find_screenshot() {
  if [ ! -f "$directory/$file" ]; then
    exit 0
  fi

  wl-copy < "$directory/$file"
  notify "Save in - Pictures/Screenshots/$file" "$directory/$file"
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
  find_screenshot
fi
# -----------------------------------------------------
# Create screenshot fullscreen
if [ "$1" = "fullscreen" ]; then
  grim "$directory/$file"
  find_screenshot
fi