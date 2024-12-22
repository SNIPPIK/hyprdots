#!/bin/sh
notification_timeout=1000
icon=~/.config/hypr/icons/translate.png

# Switch language
if [ $1 == "show" ]; then
  lang=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')
  notify-send -t $notification_timeout -h string:category:volume "Language" "$lang language" -i "$icon"
fi