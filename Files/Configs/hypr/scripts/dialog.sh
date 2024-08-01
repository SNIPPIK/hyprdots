#!/bin/sh
# -----------------------------------------------------
if [ "$1" = "float" ]; then
  alacritty --class hyprdots-floating -e bash ~/.config/hypr/scripts/dialogs/"$2".sh
else
  ~/.config/hypr/scripts/dialogs/"$1".sh
fi