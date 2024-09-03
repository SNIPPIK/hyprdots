# Arch packages
if [ -z "$(sudo pacman -Qdtq)" ]; then
    echo "Not find packages for remove"
else
    echo "Remove unused packages"
    sudo pacman -Qdtq | sudo pacman -Rsc -
fi

sleep 0.2s
clear

# Flatpak packages
echo "Remove unused flatpak"
flatpak uninstall --unused

# Press enter
echo " "
read -p "Press enter to close"