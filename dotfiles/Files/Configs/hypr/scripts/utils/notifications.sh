#!/bin/bash
# -----------------------------------------------------
# All notifications
NOTIFY=1

# -----------------------------------------------------
# Notification with icon
notify_icon() {
  if [ "$1" = "temp" ]; then
    notify-send "$2" "$3" --icon="$4" --expire-time="$5" --transient
  else
    notify-send "$2" "$3" --icon="$4" --expire-time="$5"
  fi
}

# Notification without icon
notify() {
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
  notify_icon "$2" "$3" "$4" "$5" "$6"
else
  notify "$2" "$3" "$4" "$5"
fi