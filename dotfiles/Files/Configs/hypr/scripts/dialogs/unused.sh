# Flatpak packages
echo "Remove unused flatpak"
flatpak uninstall --unused

sleep 0.2s

# Arch packages
clear
if [ -z "$(sudo pacman -Qdtq)" ]; then
    echo "Not find packages for remove"
else
    echo "Remove unused packages"
    sudo pacman -Qdtq | sudo pacman -Rsc -
fi

# Press enter
echo " "
read -p "Press enter to close"