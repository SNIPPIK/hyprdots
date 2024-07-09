#!/bin/bash
# -----------------------------------------------------
cache_file="$HOME/.cache/current_wallpaper"
# -----------------------------------------------------
# Apply image in hyprctl
selected() {
    monitor=$(hyprctl monitors | grep Monitor | awk '{print $2}')

    #Change wallpaper image
    hyprctl hyprpaper preload "$1"
    hyprctl hyprpaper wallpaper "$monitor, $1"

    # Create cache file
    save "$1"

    #Unload wallpaper image
    sleep 2
    hyprctl hyprpaper unload "$1"
}
# -----------------------------------------------------
# Create cache file
save() {
   if [ ! -f "$cache_file" ]; then
      touch "$cache_file"
      echo "$1" > "$cache_file"
   else
      echo "$1" > "$cache_file"
   fi
}
# -----------------------------------------------------
# Load last wallpaper
last() {
     if [ -f "$cache_file" ]; then
         file=$(cat "$cache_file")

         sleep 5
         notify "Load last wallpaper" "$file"
         selected "$file"
     fi
}
# -----------------------------------------------------
# Notification a change wallpaper
notify() {
  notify-send "Hyprpaper" "$1" --icon="$2" --expire-time=700
}


# -----------------------------------------------------
# Load last wallpaper
if [ "$1" == "last" ]; then
      if [ -f "$cache_file" ]; then
         sleep 5

         file=$(cat "$cache_file")
         notify "Load last wallpaper" "$file"
         selected "$file"
     fi
fi

# -----------------------------------------------------
# Restart hyprpaper
if [ "$1" == "restart" ]; then
  # Terminate already running bar instances
  killall -q hyprpaper

  # Wait until the processes have been shut down
  while pgrep -x hyprpaper >/dev/null; do sleep 1; done

  hyprpaper
  last "$1"
  exit 1
fi

# -----------------------------------------------------
# Save wallpaper in waypaper
if [ "$1" == "save" ]; then
  save "$2"
  exit 1
fi

# -----------------------------------------------------
# Change random wallpaper
if [ "$1" == "random" ]; then
  directory=~/Pictures/Wallpapers/
  random_background=""

  #Find image wallpaper
  if [ -d "$directory" ]; then
    random_background="$(find -L $directory -type f | shuf -n 1)"
  else
    notify "Fail select wallpaper. Not found $directory" ~/.config/wlogout/icons/lock.png
    exit 1
  fi

  notify "Select wallpaper" "$random_background"
  selected "$random_background"
  exit 1
fi