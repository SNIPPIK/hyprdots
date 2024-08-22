#!/bin/sh
# -----------------------------------------------------
if [ "$1" = "float" ]; then
  alacritty --class hyprdots-float -e bash ~/.config/hypr/scripts/dialogs/"$2".sh

elif [ "$1" = "float-small" ]; then
    alacritty --class hyprdots-float-small -e bash ~/.config/hypr/scripts/dialogs/"$2".sh
else
  bash ~/.config/hypr/scripts/dialogs/"$1".sh
fi