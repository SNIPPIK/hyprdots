#!/usr/bin/env bash
# -----------------------------------------------------
# __        __          _
# \ \      / /_ _ _   _| |__   __ _ _ __
#  \ \ /\ / / _` | | | | '_ \ / _` | '__|
#   \ V  V / (_| | |_| | |_) | (_| | |
#    \_/\_/ \__,_|\__, |_.__/ \__,_|_|
#                 |___/
# -----------------------------------------------------
if [ "$1" = "panel-toggle" ]; then
  ps_waybar="$(ps -fC waybar | grep waybar | awk '{ print $8 }')"

  if [ "$ps_waybar" ]; then
    # If need show information
    if [ "$2" == "show" ]; then
      hyprctl notify 1 2000 "rgb(ffffff)" "Panel | You has disabled panel"
    fi

    sleep 1s && pkill "waybar"
    exit 0
  else
    # If need show information
    if [ "$2" == "show" ]; then
      hyprctl notify 1 2000 "rgb(ffffff)" "Panel | You has enabled panel"
    fi

    sleep 1s
    hyprctl dispatch exec waybar

    # Show error info
    if [ -z "$(ps -fC waybar | grep waybar | awk '{ print $8 }')r" ]; then
      hyprctl notify 0 2000 "rgb(ff0000)" "Panel | Fail, pls enable retry!"
    fi
  fi
fi

# -----------------------------------------------------
#  _   _                  _                 _
# | | | |_   _ _ __  _ __| | __ _ _ __   __| |
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
# |  _  | |_| | |_) | |  | | (_| | | | | (_| |
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
#        |___/|_|
# --------------------------------------------
if [ "$1" == "restart" ]; then
  if [ "$2" == "show" ]; then
      hyprctl notify 2 2000 "rgb(ffffff)" "Hyprland | Reload configs"
  fi

  # Restart wallpaper engine
  bash ~/.config/hypr/scripts/tools/wallpaper.sh "engine"

  # Restart panel
  pkill "waybar" && hyprctl dispatch exec waybar

  hyprctl reload
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