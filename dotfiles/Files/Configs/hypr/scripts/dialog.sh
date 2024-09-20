#!/bin/sh
#  ____  _       _               _               _
# |  _ \(_) __ _| | ___   __ _  | |__   __ _ ___| |__
# | | | | |/ _` | |/ _ \ / _` | | '_ \ / _` / __| '_ \
# | |_| | | (_| | | (_) | (_| | | |_) | (_| \__ \ | | |
# |____/|_|\__,_|_|\___/ \__, | |_.__/ \__,_|___/_| |_|
#                        |___/
# -----------------------------------------------------
if [ "$1" = "float" ]; then
  alacritty --class hyprdots-float -e bash ~/.config/hypr/scripts/dialogs/"$2".sh & exit 0
elif [ "$1" = "float-small" ]; then
  alacritty --class hyprdots-float-small -e bash ~/.config/hypr/scripts/dialogs/"$2".sh & exit 0
elif [ "$1" = "float-big" ]; then
  alacritty --class hyprdots-float-big -e bash ~/.config/hypr/scripts/dialogs/"$2".sh & exit 0
else
  bash ~/.config/hypr/scripts/dialogs/"$1".sh & exit 0
fi