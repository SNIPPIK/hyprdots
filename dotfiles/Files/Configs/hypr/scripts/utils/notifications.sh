#!/bin/bash
#  _   _       _   _  __ _           _   _
# | \ | | ___ | |_(_)/ _(_) ___ __ _| |_(_) ___  _ __  ___
# |  \| |/ _ \| __| | |_| |/ __/ _` | __| |/ _ \| '_ \/ __|
# | |\  | (_) | |_| |  _| | (_| (_| | |_| | (_) | | | \__ \
# |_| \_|\___/ \__|_|_| |_|\___\__,_|\__|_|\___/|_| |_|___/
# -----------------------------------------------------
# All notifications
NOTIFY=1

# -----------------------------------------------------
# Notification with icon
notification_icon() {
  if [ "$1" = "temp" ]; then
    notify-send "$2" "$3" --icon="$4" --expire-time="$5" --transient
  else
    notify-send "$2" "$3" --icon="$4" --expire-time="$5"
  fi
}

# Notification without icon
notification() {
  if [ "$1" = "temp" ]; then
    notify-send "$2" "$3" --expire-time="$4" --transient
  else
    notify-send "$2" "$3" --expire-time="$4"
  fi
}

# -----------------------------------------------------
# If disable notification
if [ "$NOTIFY" == 0 ]; then
  exit 0
fi
# -----------------------------------------------------
# Send notification
if [ "$1" == "icon" ]; then
  notification_icon "$2" "$3" "$4" "$5" "$6"
else
  notification "$2" "$3" "$4" "$5"
fi