#!/bin/bash
# __        __    _ _
# \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __
#  \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#   \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#    \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                    |_|         |_|
# -----------------------------------------------------
wallpaper_default_file="$HOME/Pictures/Wallpapers/hyprland.png"
wallpaper_default_dir="$HOME/Pictures/Wallpapers"
wallpaper_cache_file="$HOME/.cache/current_wallpaper"

RANDOM_WALLPAPER_INTERVAL=300
FPS_WALLPAPER=50

# Change wallpaper
# $1 - wallpaper path
function change_wallpaper() {
  wallpaper_path="$1"

  # Selected swww engine
  if [ "$engine" == "swww" ]; then
    swww img "$1" --transition-fps $FPS_WALLPAPER

    # Unload wallpaper image
    sleep 2
    swww clear-cache

  # Selected hyprpaper engine
  elif [ "$engine" == "hyprpaper" ]; then
    for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }'); do
         #Change wallpaper image
         hyprctl hyprpaper preload "$1"
         hyprctl hyprpaper wallpaper "$monitor,$1"
    done

    # Unload wallpaper image
    sleep 2
    hyprctl hyprpaper unload all

  # Not found wallpaper engine
  else
    hyprctl notify 3 10000 "rgb(ff0000)" "Not found engine. Please install hyprpaper or swww!"
  fi

  # Save path in cache
  saveFile "$1"
}

# Restart wallpaper engine
function restart_engine() {
   # Selected swww engine
   if [ "$engine" == "swww" ]; then
     # If find process to has kill
     if [ "$(ps -fC swww)" ]; then
        pkill swww
        hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Restart $1"
     else
        hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Using $1"
     fi

     hyprctl dispatch exec swww init
     hyprctl dispatch exec swww-daemon

   # Selected hyprpaper engine
   elif [ "$engine" == "hyprpaper" ]; then
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

   # If find cache wallpaper
   if [ -f "$wallpaper_cache_file" ]; then
     wallpaper_default_file="$(cat "$wallpaper_cache_file")"
   fi

   sleep 2s
   change_wallpaper "$wallpaper_default_file"
}

# Check engine in packages
function find_engine() {
    # For swww
      if [ "$(pacman -Qs swww)" ]; then
        echo "swww"

      # For hyprpaper
      elif [ "$(pacman -Qs hyprpaper)" ]; then
        echo "hyprpaper"

      # Not found wallpaper engine
      else
          hyprctl notify 3 10000 "rgb(ff0000)" "Not found engine. Please install hyprpaper or swww!"
          echo "install"
      fi
}
engine="$(find_engine)"

# Create or update cache file
# $1 - wallpaper path
function saveFile() {
   # Create cache file
   if [ ! -f "$wallpaper_cache_file" ]; then
      touch "$wallpaper_cache_file"
      echo "$1" > "$wallpaper_cache_file"
   else
      echo "$1" > "$wallpaper_cache_file"
   fi
}

# Notification
# $1 - Title
# $2 - Description
# $3 - Wallpaper path
# optional $4 - type notification
function notify() {
  if [ ! "$4" ]; then
    bash ~/.config/dunst/client/notifications.sh "$1" "$2" "Wallpaper engine" "$3" 2000
  else
    bash ~/.config/dunst/client/notifications.sh "$1" "$2" "Wallpaper engine" "$3" "$4" 2000
  fi
}

# Dialog rofi - select wallpapers
function rofi_dialog_menu() {
  rofi -dmenu \
  -i \
  -p "Select wallpaper to change" \
  -theme windows/wallpaper
}

# Getting support files type
# $1 - Type selected
function support_type() {
    # Check dir
    if [ -d "$wallpaper_default_dir" ]; then
      echo "OK"
    else
       hyprctl notify 3 10000 "rgb(ff0000)" "Fail select wallpaper. Not found $wallpaper_default_dir"
       exit 0
    fi

    # Selected swww engine
    if [ "$engine" == "swww" ]; then
      if [ "$1" == "random" ]; then
        random_background=$(find -L "$wallpaper_default_dir" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' -o -name '*.webp' -o -name '*.tiff' \) | shuf -n 1)

        change_wallpaper "$random_background"
      elif [ "$1" == "select" ]; then
        selected_wallpaper=$(find -L "$wallpaper_default_dir" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' -o -name '*.webp' -o -name '*.tiff' \) -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${wallpaper_default_dir}"/"$A\n" ; done | rofi_dialog_menu)

        if [[ $selected_wallpaper == "" ]]; then
           exit 1
        fi

        change_wallpaper "$wallpaper_default_dir/$selected_wallpaper"
      fi

    # Selected hyprpaper engine
    elif [ "$engine" == "hyprpaper" ]; then
        if [ "$1" == "random" ]; then
            random_background=$(find -L "$wallpaper_default_dir" -type f \( -name '*.png' -o -name '*.jpg' \) | shuf -n 1)

            change_wallpaper "$random_background"
        elif [ "$1" == "select" ]; then
            selected_wallpaper=$(find -L "$wallpaper_default_dir" -type f \( -name '*.png' -o -name '*.jpg' \) -printf "%P\n" | sort | while read -r A ; do echo -en "$A\x00icon\x1f""${wallpaper_default_dir}"/"$A\n" ; done | rofi_dialog_menu)

            if [[ $selected_wallpaper == "" ]]; then
                exit 1
            fi

            change_wallpaper "$wallpaper_default_dir/$selected_wallpaper"
        fi
    fi
}


# Change random wallpaper
if [ "$1" == "random" ]; then
   support_type "random"

# User selected image
elif [ "$1" == "select" ]; then
  support_type "select"

# Auto change wallpaper
elif [ "$1" == "auto" ]; then
  while true; do
      echo "work"
      random_background="$(find -L "$WALLPAPERS_DIR" -type f | shuf -n 1)"
      change_wallpaper "$random_background"
      sleep "$RANDOM_WALLPAPER_INTERVAL"
  done

# Select engine or restart engine, and load last wallpaper
elif [ "$1" == "engine" ]; then
  restart_engine
fi