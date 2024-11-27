#!/bin/bash
#  _   _       _   _  __ _           _   _
# | \ | | ___ | |_(_)/ _(_) ___ __ _| |_(_) ___  _ __  ___
# |  \| |/ _ \| __| | |_| |/ __/ _` | __| |/ _ \| '_ \/ __|
# | |\  | (_) | |_| |  _| | (_| (_| | |_| | (_) | | | \__ \
# |_| \_|\___/ \__|_|_| |_|\___\__,_|\__|_|\___/|_| |_|___/
# -----------------------------------------------------

# -----------------------------------------------------
# Notification with icon
function notification_icon() {
  if [ "$1" = "temp" ]; then
    notify-send -h string:category:hide "$2" "$3" --icon="$4" --expire-time="$5"
  else
    notify-send "$2" "$3" --icon="$4" --expire-time="$5"
  fi
}

# Notification without icon
function notification() {
  if [ "$1" = "temp" ]; then
    notify-send -h string:category:hide "$2" "$3" --expire-time="$4"
  else
    notify-send "$2" "$3" --expire-time="$4"
  fi
}

# -----------------------------------------------------
# Check dnd mode
if [ "$1" == "toggle" ]; then
  if [ "$(dunstctl is-paused)" == false ]; then
     dunstctl set-paused true
  else
     dunstctl set-paused false
  fi

  exit 0
fi

# -----------------------------------------------------
# Send notification
if [ "$1" == "icon" ]; then
  notification_icon "$2" "$3" "$4" "$5" "$6"
else
  notification "$2" "$3" "$4" "$5"
fi