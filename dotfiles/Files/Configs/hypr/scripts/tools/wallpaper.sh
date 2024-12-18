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
RANDOM_WALLPAPER_INTERVAL=300
FPS_WALLPAPER=50
function saveFile() {
   # Create cache file
   if [ ! -f "$cache_file" ]; then
      touch "$cache_file"
      echo "$1" > "$cache_file"
   else
      echo "$1" > "$cache_file"
   fi
}


# --------------------SWWW-----------------------------
#  ______        ____        ____        __
# / ___\ \      / /\ \      / /\ \      / /
# \___ \\ \ /\ / /  \ \ /\ / /  \ \ /\ / /
#  ___) |\ V  V /    \ V  V /    \ V  V /
# |____/  \_/\_/      \_/\_/      \_/\_/
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
    swww img --transition-type "$(random_type)" "$1" --transition-fps $FPS_WALLPAPER

    # Create cache file
    saveFile "$1"

    sleep 2
    swww clear-cache
}
# --------------------SWWW-----------------------------


#  _   _                  ____
# | | | |_   _ _ __  _ __|  _ \ __ _ _ __   ___ _ __
# | |_| | | | | '_ \| '__| |_) / _` | '_ \ / _ \ '__|
# |  _  | |_| | |_) | |  |  __/ (_| | |_) |  __/ |
# |_| |_|\__, | .__/|_|  |_|   \__,_| .__/ \___|_|
#        |___/|_|                   |_|
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
# ------------------HyperPaper-------------------------


#  _   _ _   _ _
# | | | | |_(_) |___
# | | | | __| | / __|
# | |_| | |_| | \__ \
#  \___/ \__|_|_|___/
# Notification
function notify() {
  if [ ! "$4" ]; then
    bash ~/.config/dunst/client/notifications.sh "$1" "$2" "Wallpaper engine" "$3" 2000
  else
    bash ~/.config/dunst/client/notifications.sh "$1" "$2" "Wallpaper engine" "$3" "$4" 2000
  fi
}
# Restart wallpaper engine
function restart_wallpaper() {
  # For swww
  if [ "$(pacman -Qs swww)" ]; then
    # If find process to has kill
    if [ "$(ps -fC swww)" ]; then
       pkill swww
       hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Restart swww"
    else
       hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Using swww"
    fi

    hyprctl dispatch exec swww init
    hyprctl dispatch exec swww-daemon --format xrgb

  # For hyprpaper
  elif [ "$(pacman -Qs hyprpaper)" ]; then
    # If find process to has kill
    if [ "$(ps -fC hyprpaper)" ]; then
      pkill hyprpaper
      hyprctl notify 1 2000 "rgb(ff0000)" "Wallpaper Engine | Restart hyprpaper"
    else
      hyprctl notify 1 2000 "rgb(ff0000)" "Wallpaper Engine | Using hyprpaper"
    fi

    hyprctl dispatch exec hyprpaper

  # Not found wallpaper engine
  else
      hyprctl notify 3 10000 "rgb(ff0000)" "Not found engine. Please install hyprpaper or swww!"
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
    hyprctl notify 3 10000 "rgb(ff0000)" "Not found engine. Please install hyprpaper or swww!"
    exit 0
  fi
}
# ---------------------Utils---------------------------


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
      hyprctl notify 3 10000 "rgb(ff0000)" "Fail select wallpaper. Not found $WALLPAPERS_DIR"
      exit 0
   fi

   selected "$random_background"
# -----------------------------------------------------
# User selected image
elif [ "$1" == "select" ]; then
  selected_wallpaper=$(find "${WALLPAPERS_DIR}" -type f -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${WALLPAPERS_DIR}"/"$A\n" ; done | rofi_cmd)

  if [[ $selected_wallpaper == "" ]]; then
     exit 1
  fi
  selected "$WALLPAPERS_DIR/$selected_wallpaper"
# -----------------------------------------------------
# Auto change wallpaper
elif [ "$1" == "auto" ]; then
  while true; do
      echo "work"
      random_background="$(find -L "$WALLPAPERS_DIR" -type f | shuf -n 1)"
      selected "$random_background"
      sleep "$RANDOM_WALLPAPER_INTERVAL"
  done
fi


#  _   _ _   _ _
# | | | | |_(_) |___
# | | | | __| | / __|
# | |_| | |_| | \__ \
#  \___/ \__|_|_|___/
# -----------------------------------------------------
# Select engine or restart engine, and load last wallpaper
if [ "$1" == "engine" ]; then
  file="$HOME/Pictures/Wallpapers/hyprland.png"

  # If find cache wallpaper
  if [ -f "$cache_file" ]; then
     file="$(cat "$cache_file")"
  fi

  # Restart engine
  restart_wallpaper
  sleep 2s
  selected "$file"
fi