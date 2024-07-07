#!/bin/bash
# by SNIPPIK (2024)
# -----------------------------------------------------

selected() {
    monitor=`hyprctl monitors | grep Monitor | awk '{print $2}'`

    #Change wallpaper image
    hyprctl hyprpaper preload "$1"
    hyprctl hyprpaper wallpaper "$monitor, $1"

    #Unload wallpaper image
    sleep 2
    hyprctl hyprpaper unload "$1"
}

#Restart hyprpaper
if [ "$1" == "restart" ]; then
  # Terminate already running bar instances
  killall -q hyprpaper

  # Wait until the processes have been shut down
  while pgrep -x hyprpaper >/dev/null; do sleep 1; done

  sleep 0.5
  hyprpaper

  exit 1
fi

#Restart hyprpaper
if [ "$1" == "select" ]; then
  selected "$2"
  exit 1
fi

#Change wallpaper
if [ "$1" == "random" ]; then
  #Directory wallpapers
  directory=~/Pictures/Wallpapers/
  random_background=""

  #Find image wallpaper
  if [ -d "$directory" ]; then
    random_background="$(find -L $directory -type f | shuf -n 1)"
  fi

  #Apply image
  selected "$random_background"
  exit 1
fi