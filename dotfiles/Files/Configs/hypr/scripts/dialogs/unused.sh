# Arch packages
echo "     _             _     "
echo "    / \   _ __ ___| |__  "
echo "   / _ \ | '__/ __| '_ \ "
echo "  / ___ \| | | (__| | | |"
echo " /_/   \_\_|  \___|_| |_|"
if [ -z "$(sudo pacman -Qdtq)" ]; then
    echo "Not find packages for remove"
else
    echo "Removing unused packages"
    sudo pacman -Qdtq | sudo pacman -Rsc -
fi
sudo pacman -Scc
sleep 0.2s

# Aur cache removing
clear
echo "     _               "
echo "    / \  _   _ _ __  "
echo "   / _ \| | | | '__| "
echo "  / ___ \ |_| | |    "
echo " /_/   \_\__,_|_|    "
echo "Removing aur cache in package manager"
yay -Scc
sleep 0.2s

# Flatpak packages
clear
echo "  _____ _       _               _     "
echo " |  ___| | __ _| |_ _ __   __ _| | __ "
echo " | |_  | |/ _' | __| '_ \ / _' | |/ / "
echo " |  _| | | (_| | |_| |_) | (_| |   <  "
echo " |_|   |_|\__,_|\__| .__/ \__,_|_|\_\ "
echo "                   |_|                "
echo "Removing unused flatpak application"
flatpak uninstall --unused

# Press enter
echo " "
read -p "Press enter to close"