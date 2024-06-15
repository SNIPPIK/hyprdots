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
fi


#Change wallpaper
if [ "$1" == "wallpaper" ]; then
  directory=~/Pictures/Wallpapers
  monitor=`hyprctl monitors | grep Monitor | awk '{print $2}'`

  if [ -d "$directory" ]; then
      random_background=$(ls $directory/* | shuf -n 1)

      hyprctl hyprpaper unload all

      sleep 1
      hyprctl hyprpaper preload $random_background
      hyprctl hyprpaper wallpaper "$monitor, $random_background"
  fi
fi


#Gamemode
if [ "$1" == "gamemode" ]; then
  if [ -f ~/.cache/gamemode ]; then
      hyprctl keyword animations:enabled true
      hyprctl keyword decoration:blur:enabled true
      rm ~/.cache/gamemode
      notify-send "Gamemode deactivated" "Animations and blur enabled"
  else
      hyprctl keyword animations:enabled false
      hyprctl keyword decoration:blur:enabled false
      echo "Gamemode enable" > ~/.cache/gamemode
      notify-send "Gamemode activated" "Animations and blur disabled"
  fi
fi


#Remove unused packages
if [ "$1" == "remove-packages" ]; then
  alacritty -e sudo pacman -Qdtq & sudo pacman -Rns -
fi

#Update packages
if [ "$1" == "update-packages" ]; then
  alacritty -e sudo pacman -Syu
fi