#!/bin/sh
# Player toggle
WAYBAR_PLAYER=1

# Playerctl
if [ $WAYBAR_PLAYER == 1 ]; then
  class=$(playerctl metadata --format '{{lc(status)}}')
  icon=""

  if [[ $class == "playing" ]] || [[ $class == "paused" ]]; then
    info=$(playerctl metadata --format '{{artist}} - {{title}}')

    text=$icon" "$info
  elif [[ $class == "stopped" ]]; then
    text=
  fi

  echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"
fi
