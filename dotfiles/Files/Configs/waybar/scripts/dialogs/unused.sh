# Arch packages
echo "     _             _     "
echo "    / \   _ __ ___| |__  "
echo "   / _ \ | '__/ __| '_ \ "
echo "  / ___ \| | | (__| | | |"
echo " /_/   \_\_|  \___|_| |_|"
echo "Removing unused packages"

# Unused packages
if [ -z "$(sudo pacman -Qdtq)" ]; then
    echo "Not found unused packages"
else
    echo "Found packages"
    sudo pacman -Qdtq | sudo pacman -Rsc -
fi

# Clear cache
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

# Arch installed packages
clear
echo "     _             _     "
echo "    / \   _ __ ___| |__  "
echo "   / _ \ | '__/ __| '_ \ "
echo "  / ___ \| | | (__| | | |"
echo " /_/   \_\_|  \___|_| |_|"
echo "ATTENTION REMOVE PACKAGES WITH CARE, THEY CAN CRUSH THE SYSTEMD"
echo "Possibly unnecessary packets"
echo " "
pacman -Qet

# Press enter
echo " "
read -p "Press enter to close"