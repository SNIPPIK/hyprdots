#!/usr/bin/env bash
# -----------------------------------------------------
# Send notification
notify () {
  bash ~/.config/dunst/client/notifications.sh "$1" "$2" "$3" "$4" $5
}

# -----------------------------------------------------
# __        __          _
# \ \      / /_ _ _   _| |__   __ _ _ __
#  \ \ /\ / / _` | | | | '_ \ / _` | '__|
#   \ V  V / (_| | |_| | |_) | (_| | |
#    \_/\_/ \__,_|\__, |_.__/ \__,_|_|
#                 |___/
# -----------------------------------------------------
if [ "$1" = "panel-toggle" ]; then
  if [ "$(ps -fC waybar | grep waybar | awk '{ print $8 }')" ]; then
    # If need show information
    if [ "$2" == "show" ]; then
       notify "n" "temp" "Panel" "You has disabled panel" 1500
    fi

    pkill "waybar" & sleep 0.5s & exit 0
  else
    waybar & sleep 0.5s

    # Show info
    if [ "$(ps -fC waybar | grep waybar | awk '{ print $8 }')" ]; then
      # If need show information
      if [ "$2" == "show" ]; then
        notify "n" "temp" "Panel" "You has enabled panel" 1500
      fi
    else
      notify "n" "temp" "Panel" "Fail, pls update your dotfiles" 1500
    fi
    exit 0
  fi
fi

# -----------------------------------------------------
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