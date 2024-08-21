#!/bin/sh
# -----------------------------------------------------
# Player toggle
WAYBAR_PLAYER=1
# -----------------------------------------------------
icon=""
space="                                                                                                                "
# -----------------------------------------------------
# Notification a change wallpaper
notify() {
  bash ~/.config/hypr/scripts/utils/notifications.sh "no-icon" "temp" "Player | $2" "$1" 1500
}

# -----------------------------------------------------
# Info a current track
if [ "$1" = "info" ] && [ $WAYBAR_PLAYER = 1 ]; then
  class=$(playerctl metadata --format '{{lc(status)}}')

  if [ "$class" = "playing" ] || [ "$class" = "paused" ]; then
    title=$icon" "$(playerctl metadata --format '{{title}}')
  elif [ "$class" = "stopped" ]; then
    title=
  fi

echo "$title"
fi

# -----------------------------------------------------
# Skip track
if [ "$1" = "skip" ]; then
  notify "$(playerctl metadata --format '{{ artist }} - {{ title }}')" "Skip"
  playerctl next
fi

# -----------------------------------------------------
# Pause/Resume track
if [ "$1" = "toggle" ]; then
  class=$(playerctl metadata --format '{{lc(status)}}')

  if [ "$class" = "playing" ]; then
    notify "$(playerctl metadata --format '{{ artist }} - {{ title }}')" "Pause"
    playerctl play-pause
  elif [ "$class" = "paused" ]; then
    notify "$(playerctl metadata --format '{{ artist }} - {{ title }}')" "Resume"
    playerctl play-pause
  fi
fi

# -----------------------------------------------------
# Added a volume track
if [ "$1" = "seek+" ]; then
  playerctl position 5+
  notify "$(playerctl metadata --format '{{ artist }} - {{ title }}')\n🕐 $(playerctl metadata --format '{{ duration(position) }}')" "Seek"
fi

# -----------------------------------------------------
# Added a volume track
if [ "$1" = "seek-" ]; then
  playerctl position 5-
  notify "$(playerctl metadata --format '{{ artist }} - {{ title }}')\n🕐 $(playerctl metadata --format '{{ duration(position) }}')" "Seek"
fi