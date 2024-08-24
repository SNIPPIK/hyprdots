#!/bin/sh
#  ____      _                 _                ____           _             _
# |  _ \ ___| | ___   __ _  __| |   ___  _ __  |  _ \ ___  ___| |_ __ _ _ __| |_
# | |_) / _ \ |/ _ \ / _` |/ _` |  / _ \| '__| | |_) / _ \/ __| __/ _` | '__| __|
# |  _ <  __/ | (_) | (_| | (_| | | (_) | |    |  _ <  __/\__ \ || (_| | |  | |_
# |_| \_\___|_|\___/ \__,_|\__,_|  \___/|_|    |_| \_\___||___/\__\__,_|_|   \__|
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