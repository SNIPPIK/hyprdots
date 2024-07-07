#!/bin/bash
# by SNIPPIK (2024)
# -----------------------------------------------------

#Restart waybar
if [ "$1" == "restart-waybar" ]; then
  # Terminate already running bar instances
  killall -q waybar

  # Wait until the processes have been shut down
  while pgrep -x waybar >/dev/null; do sleep 1; done

  sleep 0.5
  waybar

  echo "OK - restart waybar"
  exit 1
fi


#Remove unused packages
if [ "$1" == "remove-packages" ]; then
  packages=`sudo pacman -Qdtq`

  if [ -z "$packages" ]; then
    echo "Not find packages for remove"
  else
    sudo pacman -Qdtq | sudo pacman -Rsc -
  fi

  sleep 5
  exit 1
fi

#Update packages
if [ "$1" == "update-packages" ]; then
  alacritty -e sudo pacman -Syu
fi