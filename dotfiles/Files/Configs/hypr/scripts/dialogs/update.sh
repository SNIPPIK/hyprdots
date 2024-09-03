# Update system packages
echo "Update system"
sudo pacman -Syu

sleep 0.2s

# Update aur packages
clear
echo "Update aur repository"
yay -Syu

sleep 0.2s

# Update flatpak packages
clear
echo "Update flatpak"
flatpak update

# Press enter
echo " "
read -p "Press enter to close"