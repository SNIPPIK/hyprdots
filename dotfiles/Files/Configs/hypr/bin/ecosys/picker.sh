#  ____  _      _
# |  _ \(_) ___| | _____ _ __
# | |_) | |/ __| |/ / _ \ '__|
# |  __/| | (__|   <  __/ |
# |_|   |_|\___|_|\_\___|_|
# -----------------------------------------------------
if [ "$1" == "picker" ]; then
  COLOR="$(hyprpicker -r | cut -c2-)"

  # Send notification
  if [ "$2" == "show" ]; then
     hyprctl notify 1 2000 "rgb($COLOR)" "Picker | Pasted in buffer | #$COLOR"
  fi

  # Added to buffer
  wl-copy "#$COLOR"
fi