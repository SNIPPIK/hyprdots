#!/bin/sh
# -----------------------------------------------------
alacritty --class hyprdots-floating -e bash ~/.config/hypr/scripts/dialogs/"$1".sh
echo " "
read -p "Press to close"