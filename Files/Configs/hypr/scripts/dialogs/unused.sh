#!/bin/sh
# -----------------------------------------------------
echo "Remove unused packages"

packages=$(sudo pacman -Qdtq)
if [ -z "$packages" ]; then
    echo "Not find packages for remove"
else
    sudo pacman -Qdtq | sudo pacman -Rsc -
fi
sleep 0.2

clear
echo "Remove unused flatpak"
flatpak uninstall --unused

echo " "
read -p "Press enter to close"