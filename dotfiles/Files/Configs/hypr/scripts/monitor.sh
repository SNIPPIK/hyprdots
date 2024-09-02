#!/usr/bin/env bash
#  _   _                  _                 _   __  __             _ _
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | |  \/  | ___  _ __ (_) |_ ___  _ __ ___
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | | |\/| |/ _ \| '_ \| | __/ _ \| '__/ __|
# |  _  | |_| | |_) | |  | | (_| | | | | (_| | | |  | | (_) | | | | | || (_) | |  \__ \
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| |_|  |_|\___/|_| |_|_|\__\___/|_|  |___/
#        |___/|_|
# Support: scale factor

monitors=$(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }')
resolutions=$(hyprctl monitors | grep 'availableModes:' | awk '{ print $3 }' | sed -E 's/^([^.]*).*/\1/')
total_monitors=""

# Find all monitors
for monitor in $monitors; do
    # Set best resolution
    for resolution in $resolutions; do
      total_monitors+="$monitor - $resolution\n"

      hyprctl keyword monitor "$monitor,$resolution,auto,$1"
    done
done

sleep 2

# Send notification
if [ "$(monitors | wc -l)" -gt 1 ]; then
  bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Monitors calibrated" "$total_monitors" 2000
else
  bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Monitor calibrated" "$total_monitors" 2000
fi