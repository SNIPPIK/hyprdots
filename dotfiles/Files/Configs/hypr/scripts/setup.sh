#!/usr/bin/env bash
#  _   _                  _                 _   __  __             _ _
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | |  \/  | ___  _ __ (_) |_ ___  _ __ ___
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | | |\/| |/ _ \| '_ \| | __/ _ \| '__/ __|
# |  _  | |_| | |_) | |  | | (_| | | | | (_| | | |  | | (_) | | | | | || (_) | |  \__ \
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| |_|  |_|\___/|_| |_|_|\__\___/|_|  |___/
#        |___/|_|
# -----------------------------------------------------
# Support: scale factor
if [ "$1" = "monitors" ]; then
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
             preset+="monitor=$monitor,$resolution,auto,$2\n"

             # If find current = best to skip
             if [ "$resolution" = "$current" ]; then
               continue
             fi

             # Configure new monitors
             total_monitors+="$monitor - $resolution\n"
             hyprctl keyword monitor "$monitor,$resolution,auto,$2"
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
fi


# __        __          _
# \ \      / /_ _ _   _| |__   __ _ _ __
#  \ \ /\ / / _` | | | | '_ \ / _` | '__|
#   \ V  V / (_| | |_| | |_) | (_| | |
#    \_/\_/ \__,_|\__, |_.__/ \__,_|_|
#                 |___/
# -----------------------------------------------------
if [ "$1" = "panel-toggle" ]; then
  if [ $(ps -fC waybar | grep waybar | awk '{ print $8 }') ]; then
    bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Panel" "Your panel disabled" 1500
    pkill "waybar"
  else
    bash ~/.config/hypr/scripts/utils/notifications.sh "n" "temp" "Panel" "Your panel enabled" 1500
    waybar
  fi
fi


#  ____  _            _              _   _
# | __ )| |_   _  ___| |_ ___   ___ | |_| |__
# |  _ \| | | | |/ _ \ __/ _ \ / _ \| __| '_ \
# | |_) | | |_| |  __/ || (_) | (_) | |_| | | |
# |____/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|
# -----------------------------------------------------
# Automatically connect saved devices
if [ "$1" = "bluetooth" ]; then
  # List of connected devices
  devices=$(bluetoothctl devices | awk '{ print $2 }')

  # If not connected devices
  if [ ! "$devices" ]; then
      exit 0
  fi

  # Scan the list of connected devices
  for device in $devices
  do
    # Connect to device
    bluetoothctl connect "$device"
  done
fi


#          _                 _           _    _                                     _        _
# __  ____| | __ _        __| | ___  ___| | _| |_ ___  _ __        _ __   ___  _ __| |_ __ _| |___
# \ \/ / _` |/ _` |_____ / _` |/ _ \/ __| |/ / __/ _ \| '_ \ _____| '_ \ / _ \| '__| __/ _` | / __|
#  >  < (_| | (_| |_____| (_| |  __/\__ \   <| || (_) | |_) |_____| |_) | (_) | |  | || (_| | \__ \
# /_/\_\__,_|\__, |      \__,_|\___||___/_|\_\\__\___/| .__/      | .__/ \___/|_|   \__\__,_|_|___/
#            |___/                                    |_|         |_|
# -----------------------------------------------------
if [ "$1" = "xdp" ]; then
  sleep 1
  killall -e xdg-desktop-portal-hyprland
  killall -e xdg-desktop-portal-wlr
  killall xdg-desktop-portal
  /usr/lib/xdg-desktop-portal-hyprland &
  sleep 2
  /usr/lib/xdg-desktop-portal &
fi