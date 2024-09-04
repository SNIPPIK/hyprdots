# Arch packages
if [ -z "$(sudo pacman -Qdtq)" ]; then
    echo "Not find packages for remove"
else
    echo "Removing unused packages"
    sudo pacman -Qdtq | sudo pacman -Rsc -
fi

sleep 0.2s

# Cache removing
clear
echo "Removing cache in package manager"
sudo pacman -Scc
yay -Scc

sleep 0.2s

# Flatpak packages
clear
echo "Removing unused flatpak application"
flatpak uninstall --unused

# Press enter
echo " "
read -p "Press enter to close"