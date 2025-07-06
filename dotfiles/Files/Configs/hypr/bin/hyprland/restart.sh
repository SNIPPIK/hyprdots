#!/usr/bin/env bash
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

  hyprctl reload
fi
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
      hyprctl notify 1 3000 "rgb(ffffff)" "Panel | You has disabled panel"
    fi

    sleep 1s && pkill "waybar"
    exit 0
  else
    # If need show information
    if [ "$2" == "show" ]; then
      hyprctl notify 1 3000 "rgb(ffffff)" "Panel | You has enabled panel"
    fi

    sleep 1s
    waybar &

    # Show error info
    if [ -z "$(ps -fC waybar | grep waybar | awk '{ print $8 }')r" ]; then
      hyprctl notify 0 3000 "rgb(ff0000)" "Panel | Fail, pls enable retry!"
    fi
  fi
fi

if [ "$1" = "panel-restart" ]; then
  ps_waybar="$(ps -fC waybar | grep waybar | awk '{ print $8 }')"

  if [ "$ps_waybar" ]; then
    # If need show information
    if [ "$2" == "show" ]; then
      hyprctl notify 1 3000 "rgb(ffffff)" "Panel | You has restarted panel"
    fi

    sleep 1s && pkill "waybar" && waybar &
    exit 0
  else
    # If need show information
    if [ "$2" == "show" ]; then
      hyprctl notify 1 3000 "rgb(ffffff)" "Panel | You has restarted panel"
    fi

    sleep 1s
    waybar &

    # Show error info
    if [ -z "$(ps -fC waybar | grep waybar | awk '{ print $8 }')r" ]; then
      hyprctl notify 0 3000 "rgb(ff0000)" "Panel | Fail, pls enable retry!"
    fi
  fi
fi