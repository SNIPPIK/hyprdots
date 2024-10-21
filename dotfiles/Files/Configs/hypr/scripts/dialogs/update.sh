# Update system packages
echo "     _             _     "
echo "    / \   _ __ ___| |__  "
echo "   / _ \ | '__/ __| '_ \ "
echo "  / ___ \| | | (__| | | |"
echo " /_/   \_\_|  \___|_| |_|"
echo "Updating the system and synchronizing with arch repositories"
sudo pacman -Syyu
sleep 0.2s

# Update aur packages
clear
echo "     _               "
echo "    / \  _   _ _ __  "
echo "   / _ \| | | | '__| "
echo "  / ___ \ |_| | |    "
echo " /_/   \_\__,_|_|    "
echo "Updating aur repository"

# Install yay package
if ! command -v yay &> /dev/null
then
    echo "Install yay"
    cd ~/.cache/
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    sleep 0.2s
    clear
fi
# Update aur packages
yay -Syu
sleep 0.2s

# Update flatpak packages
clear
echo "  _____ _       _               _     "
echo " |  ___| | __ _| |_ _ __   __ _| | __ "
echo " | |_  | |/ _' | __| '_ \ / _' | |/ / "
echo " |  _| | | (_| | |_| |_) | (_| |   <  "
echo " |_|   |_|\__,_|\__| .__/ \__,_|_|\_\ "
echo "                   |_|                "
echo "Updating flatpak"
flatpak update

# Press enter
echo " "
read -p "Press enter to close"