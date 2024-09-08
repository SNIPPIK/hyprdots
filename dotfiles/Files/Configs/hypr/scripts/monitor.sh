#!/usr/bin/env bash
#  _   _                  _                 _   __  __             _ _
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | |  \/  | ___  _ __ (_) |_ ___  _ __ ___
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | | |\/| |/ _ \| '_ \| | __/ _ \| '__/ __|
# |  _  | |_| | |_) | |  | | (_| | | | | (_| | | |  | | (_) | | | | | || (_) | |  \__ \
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| |_|  |_|\___/|_| |_|_|\__\___/|_|  |___/
#        |___/|_|
# Support: scale factor

monitors=$(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }')
current_resolutions=$(hyprctl monitors | grep ' at' | awk '{ print $1 }' | sed -E 's/^([^.]*).*/\1/')
resolutions=$(hyprctl monitors | grep 'availableModes:' | awk '{ print $3 }' | sed -E 's/^([^.]*).*/\1/')
total_monitors=""
preset=""

# Check all monitors
for monitor in $monitors
do
    # Check all best resolutions
    for resolution in $resolutions
    do
         # Check current resolution
         for current in $current_resolutions
         do
           preset+="monitor=$monitor,$resolution,auto,$1\n"

           # If find current = best to skip
           if [ "$resolution" = "$current" ]; then
             continue
           fi

           # Configure new monitors
           total_monitors+="$monitor - $resolution\n"
           hyprctl keyword monitor "$monitor,$resolution,auto,$1"
         done
    done
done

# Create config
rm ~/.config/hypr/configuring/window/monitors.conf
printf "#This file is temp\n$preset" >> ~/.config/hypr/configuring/window/monitors.conf

sleep 2

# If not find new monitors
if [ ! "$total_monitors" ]; then
  bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Monitor calibrating" "Used best resolution" 2000
  exit 0
fi


# Send notification
if [ "$(monitors | wc -l)" -gt 1 ]; then
  bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Monitors calibrating" "$total_monitors" 2000
else
  bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Monitor calibrating" "$total_monitors" 2000
fi