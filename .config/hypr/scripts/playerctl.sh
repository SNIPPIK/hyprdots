#!/bin/sh
# -----------------------------------------------------
# Player toggle
WAYBAR_PLAYER=1
# -----------------------------------------------------
icon=""
space="-----------------------------------------------------------------------"
# -----------------------------------------------------

# Playerctl
if [ $WAYBAR_PLAYER = 1 ]; then
  class=$(playerctl metadata --format '{{lc(status)}}')

  if [ "$class" = "playing" ] || [ "$class" = "paused" ]; then
    title=$icon" "$(playerctl metadata --format '{{title}}')
    tooltip="$space\n"
    tooltip+=$(playerctl metadata --format '🎶: {{ playerName }}\n👤: {{ artist }}\n💽: {{ title }}\n🕐: {{ duration(position) }} - {{ duration(mpris:length) }}')
    tooltip+="\n$space"

  elif [ "$class" = "stopped" ]; then
    title=
  fi

cat <<EOF
{ "text":"$title", "tooltip":"$tooltip", "class": "$class"}
EOF
fi
