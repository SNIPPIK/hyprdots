#!/bin/sh
# -----------------------------------------------------
restart() {
  # Terminate already running bar instances
  killall -q "$1"

  # Wait until the processes have been shut down
  while pgrep -x "$1" >/dev/null; do sleep 1; done
}
# -----------------------------------------------------

# Restart waybar
if [ "$1" = "waybar" ]; then
  restart "waybar"
  sleep 0.5
  waybar
fi
# -----------------------------------------------------

# Restart hyprpaper
if [ "$1" = "hyprpaper" ]; then
  restart "hyprpaper"
  sleep 0.5
  hyprpaper
fi