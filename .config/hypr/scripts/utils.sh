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


#Change wallpaper
if [ "$1" == "wallpaper" ]; then
  directory=~/Pictures/Wallpapers
  directory_quality=~/Pictures/Wallpapers/Quality

  if [ -d "$directory_quality" ]; then
    random_background="$(find $directory_quality | shuf -n 1)"

    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $random_background
    hyprctl hyprpaper wallpaper ", $random_background"
  elif [ -d "$directory" ]; then
    random_background=$(ls $directory/* | shuf -n 1)

    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $random_background
    hyprctl hyprpaper wallpaper ", $random_background"
  fi

  echo "OK - wallpaper"
  exit 1
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

    echo "OK - gamemode"
    exit 1
fi


#Remove unused packages
if [ "$1" == "remove-packages" ]; then
  packages=`sudo pacman -Qdtq`

  if [ -z "$packages" ]; then
    echo "Not find packages for remove"
  else
    sudo pacman -Rns "$packages"
  fi

  sleep 5
  exit 1
fi

#Update packages
if [ "$1" == "update-packages" ]; then
  alacritty -e sudo pacman -Syu
fi