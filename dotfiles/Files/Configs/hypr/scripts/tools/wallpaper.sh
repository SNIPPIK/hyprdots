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
# -----------------------------------------------------
# Apply image in hyprctl
selected() {
    monitor=$(hyprctl monitors | grep Monitor | awk '{print $2}')

    #Change wallpaper image
    hyprctl hyprpaper preload "$1"
    hyprctl hyprpaper wallpaper "$monitor, $1"

    # Create cache file
    if [ ! -f "$cache_file" ]; then
        touch "$cache_file"
        echo "$1" > "$cache_file"
    else
        echo "$1" > "$cache_file"
    fi

    #Unload wallpaper image
    sleep 2
    hyprctl hyprpaper unload all
}
# -----------------------------------------------------
# Load last wallpaper
last() {
     if [ -f "$cache_file" ]; then
         file=$(cat "$cache_file")

         if [ -n "$1" ]; then
            notify "temp" "$1" "$file"
         fi

         sleep 1
         selected "$file"
     else
       notify "n" "Not found wallpaper cache file \n- $cache_file"
     fi
}
# -----------------------------------------------------
# Notification
notify() {
  bash ~/.config/hypr/scripts/utils/notifications.sh "icon" "$1" "Hyprpaper" "$2" "$3" 1500
}
# -----------------------------------------------------
# Run rofi
rofi_cmd() {
  rofi -dmenu \
  -i \
  -p "Select wallpaper to change" \
  -theme windows/wallpaper
}
# -----------------------------------------------------
# Select random image
wallpaper_random() {
    random_background=""

    #Find image wallpaper
    if [ -d "$WALLPAPERS_DIR" ]; then
      random_background="$(find -L "$WALLPAPERS_DIR" -type f | shuf -n 1)"
    else
      notify "temp" "Fail select wallpaper. Not found $WALLPAPERS_DIR"
      exit 1
    fi

    selected "$random_background"
}

# -----------------------------------------------------
# Restart hyprpaper
if [ "$1" == "restart" ]; then
  ~/.config/hypr/scripts/utils/reload.sh hyprpaper

  last "Restart wallpaper engine"
  exit 1
# -----------------------------------------------------
# Load last wallpaper
elif [ "$1" == "last" ]; then
  last "Load last wallpaper"
# -----------------------------------------------------
# Change random wallpaper
elif [ "$1" == "random" ]; then
  wallpaper_random
  exit 1
# -----------------------------------------------------
# Selected image
elif [ "$1" == "select" ]; then
  selected_wallpaper=$(find "${WALLPAPERS_DIR}" -type f -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${WALLPAPERS_DIR}"/"$A\n" ; done | rofi_cmd)

  if [[ $selected_wallpaper == "" ]]; then
     exit 1
  fi
  selected "$WALLPAPERS_DIR/$selected_wallpaper"
# -----------------------------------------------------
# Auto switch wallpapers
elif [ "$1" == "auto" ]; then
  while true
  do
      wallpaper_random
      sleep 2m
  done
fi