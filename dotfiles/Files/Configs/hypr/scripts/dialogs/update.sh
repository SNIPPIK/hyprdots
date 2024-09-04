# Update system packages
echo "Updating the system and synchronizing with arch repositories"
sudo pacman -Syy
sudo pacman -Syu

sleep 0.2s

# Update aur packages
clear
echo "Updating aur repository"
yay -Syu

sleep 0.2s

# Update flatpak packages
clear
echo "Updating flatpak"
flatpak update

# Press enter
echo " "
read -p "Press enter to close"