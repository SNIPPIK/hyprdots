#!/bin/bash
# __        __    _ _
# \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __
#  \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#   \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#    \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                    |_|         |_|
# -----------------------------------------------------
cache_file="$HOME/.cache/current_wallpaper"
WALLPAPERS_DIR=$HOME/Pictures/Wallpapers
function saveFile() {
   # Create cache file
   if [ ! -f "$cache_file" ]; then
      touch "$cache_file"
      echo "$1" > "$cache_file"
   else
      echo "$1" > "$cache_file"
   fi
}
# ------------------SWWW-------------------------------
#  ______        ____        ____        __
# / ___\ \      / /\ \      / /\ \      / /
# \___ \\ \ /\ / /  \ \ /\ / /  \ \ /\ / /
#  ___) |\ V  V /    \ V  V /    \ V  V /
# |____/  \_/\_/      \_/\_/      \_/\_/
# ------------------SWWW-------------------------------
function random_type() {
  case $((1 + $RANDOM % 2)) in
    1)
      printf "wipe"
      ;;
    2)
      printf "wave"
      ;;
  esac
}
function sel_sww() {
    swww img --transition-type "$(random_type)" "$1"

    # Create cache file
    saveFile "$1"

    sleep 2
    swww clear-cache
}
# ------------------HyperPaper-------------------------
#  _   _                  ____
# | | | |_   _ _ __  _ __|  _ \ __ _ _ __   ___ _ __
# | |_| | | | | '_ \| '__| |_) / _` | '_ \ / _ \ '__|
# |  _  | |_| | |_) | |  |  __/ (_| | |_) |  __/ |
# |_| |_|\__, | .__/|_|  |_|   \__,_| .__/ \___|_|
#        |___/|_|                   |_|
# ------------------HyperPaper-------------------------
function sel_hyprpaper() {
    for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }'); do
          #Change wallpaper image
          hyprctl hyprpaper preload "$1"
          hyprctl hyprpaper wallpaper "$monitor,$1"
    done

    # Create cache file
    saveFile "$1"

    #Unload wallpaper image
    sleep 2
    hyprctl hyprpaper unload all
}
# -----------------------------------------------------
# Notification
function notify() {
  if [ ! "$4" ]; then
    bash ~/.config/dunst/client/notifications.sh "$1" "$2" "Wallpaper engine" "$3" 2000
  else
    bash ~/.config/dunst/client/notifications.sh "$1" "$2" "Wallpaper engine" "$3" "$4" 2000
  fi
}
# Select wallpaper engine for restarting
function restart_wallpaper() {
  # Restart wallpaper engine
  if [ "$(pacman -Qs swww)" ]; then
      killall -q "swww-daemon"
      sleep 0.5
      swww-daemon
  elif [ "$(pacman -Qs hyprpaper)" ]; then
      killall -q "hyprpaper"
      sleep 0.5
      hyprpaper
  fi
}
# Select wallpaper engine for change image
function selected() {
  # Use SWWW
  if [ "$(pacman -Qs swww)" ]; then
      sel_sww "$1"
  # Use hyprpaper
  elif [ "$(pacman -Qs hyprpaper)" ]; then
    sel_hyprpaper "$1"
  # Not found wallpaper engine
  else
    notify "n" "n" "Not found engine.\n Please install hyprpaper or swww!"
    exit 0
  fi
}
# -----------------------------------------------------
# Dialog rofi - select wallpapers
function rofi_cmd() {
  rofi -dmenu \
  -i \
  -p "Select wallpaper to change" \
  -theme windows/wallpaper
}
# -----------------------------------------------------


#  ____       _           _     _____
# / ___|  ___| | ___  ___| |_  |_   _|   _ _ __   ___  ___
# \___ \ / _ \ |/ _ \/ __| __|   | || | | | '_ \ / _ \/ __|
#  ___) |  __/ |  __/ (__| |_    | || |_| | |_) |  __/\__ \
# |____/ \___|_|\___|\___|\__|   |_| \__, | .__/ \___||___/
#                                    |___/|_|
# Change random wallpaper
if [ "$1" == "random" ]; then
   random_background=""

   #Find image wallpaper
   if [ -d "$WALLPAPERS_DIR" ]; then
      random_background="$(find -L "$WALLPAPERS_DIR" -type f | shuf -n 1)"
   else
      notify "n" "n" "Fail select wallpaper. Not found $WALLPAPERS_DIR"
      exit 0
   fi

   selected "$random_background"
# Load last wallpaper
elif [ "$1" == "last" ]; then
  if [ -f "$cache_file" ]; then
      file=$(cat "$cache_file")

      # Notify
      if [ -n "$1" ]; then
         notify "icon" "temp" "Load last wallpaper" "$file"
      fi

      sleep 1
      selected "$file"
  fi
# -----------------------------------------------------
# Auto switching wallpapers
elif [ "$1" == "auto" ]; then
  while true
  do
      bash ~/.config/hypr/scripts/tools/wallpaper.sh random
      sleep 2m
  done
# -----------------------------------------------------
# User selected image
elif [ "$1" == "select" ]; then
  selected_wallpaper=$(find "${WALLPAPERS_DIR}" -type f -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${WALLPAPERS_DIR}"/"$A\n" ; done | rofi_cmd)

  if [[ $selected_wallpaper == "" ]]; then
     exit 1
  fi
  selected "$WALLPAPERS_DIR/$selected_wallpaper"
fi


#  _   _ _   _ _
# | | | | |_(_) |___
# | | | | __| | / __|
# | |_| | |_| | \__ \
#  \___/ \__|_|_|___/
# Restart wallpaper engine
if [ "$1" == "restart" ]; then
  bash ~/.config/hypr/scripts/utils/reload.sh wallpaper
  bash ~/.config/hypr/scripts/tools/wallpaper.sh last
# -----------------------------------------------------
# Select engine
elif [ "$1" == "engine" ]; then
  # For swww
  if [ "$(pacman -Qs swww)" ]; then
      notify "n" "temp" " - Using swww"
      swww init
      swww-daemon --format xrgb

  # For hyprpaper
  elif [ "$(pacman -Qs hyprpaper)" ]; then
      notify "n" "temp" " - Using hyprpaper"
      hyprpaper
  # Not found wallpaper engine
  else
      notify "n" "n" "Not found engine.\n Please install hyprpaper or swww!"
      exit 0
  fi
fi