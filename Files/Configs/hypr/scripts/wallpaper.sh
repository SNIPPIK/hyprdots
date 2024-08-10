#!/bin/bash
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
    hyprctl hyprpaper unload "$1"
}
# -----------------------------------------------------
# Load last wallpaper
# shellcheck disable=SC2120
last() {
     if [ -f "$cache_file" ]; then
         file=$(cat "$cache_file")

         if [ -n "$1" ]; then
            notify "$1" "$file"
         fi

         sleep 1
         selected "$file"
     fi
}
# -----------------------------------------------------
# Notification a change wallpaper
notify() {
  notify-send "Hyprpaper" "$1" --icon="$2" --expire-time=1500 --transient
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


# -----------------------------------------------------
# Load last wallpaper
if [ "$1" == "last" ]; then
  last "Load last wallpaper"
fi

# -----------------------------------------------------
# Restart hyprpaper
if [ "$1" == "restart" ]; then
  ~/.config/hypr/scripts/utils/reload.sh hyprpaper

  last "Restart wallpaper engine"
  exit 1
fi

# -----------------------------------------------------
# Change random wallpaper
if [ "$1" == "random" ]; then
  random_background=""

  #Find image wallpaper
  if [ -d "$WALLPAPERS_DIR" ]; then
    random_background="$(find -L "$WALLPAPERS_DIR" -type f | shuf -n 1)"
  else
    notify "Fail select wallpaper. Not found $WALLPAPERS_DIR"
    exit 1
  fi

  selected "$random_background"
  exit 1
fi

# -----------------------------------------------------
# Selected image
if [ "$1" == "select" ]; then
  selected_wallpaper=$(find "${WALLPAPERS_DIR}" -type f -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${WALLPAPERS_DIR}"/"$A\n" ; done | rofi_cmd)

  if [[ $selected_wallpaper == "" ]]; then
     exit 1
  fi
  selected "$WALLPAPERS_DIR/$selected_wallpaper"
fi