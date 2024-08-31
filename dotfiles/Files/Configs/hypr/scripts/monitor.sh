#!/usr/bin/env bash
#  _   _                  _                 _   __  __             _ _
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | |  \/  | ___  _ __ (_) |_ ___  _ __ ___
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | | |\/| |/ _ \| '_ \| | __/ _ \| '__/ __|
# |  _  | |_| | |_) | |  | | (_| | | | | (_| | | |  | | (_) | | | | | || (_) | |  \__ \
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| |_|  |_|\___/|_| |_|_|\__\___/|_|  |___/
#        |___/|_|

# Transforms
#0 -> normal (no transforms)
#1 -> 90 degrees
#2 -> 180 degrees
#3 -> 270 degrees
#4 -> flipped
#5 -> flipped + 90 degrees
#6 -> flipped + 180 degrees
#7 -> flipped + 270 degrees

monitors=$(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }')
resolutions=$(hyprctl monitors | grep 'availableModes:' | awk '{ print $3 }' | sed -E 's/^([^.]*).*/\1/')
total_monitors=""

# Find all monitors
for monitor in $monitors; do
    # Set best resolution
    for resolution in $resolutions; do
      total_monitors+="$monitor - $resolution\n"

      hyprctl keyword monitor "$monitor,$resolution,$1"
    done
done

sleep 2
bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Monitor calibrate" "$total_monitors" 2000