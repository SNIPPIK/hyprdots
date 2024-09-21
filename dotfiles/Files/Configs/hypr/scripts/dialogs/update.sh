# Update system packages
echo "Updating the system and synchronizing with arch repositories"
sudo pacman -Syyu

sleep 0.2s

# Update aur packages
clear
echo "Updating aur repository"

# Install yay
if ! yay; then
  cd ~/.cache/
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  sleep 0.2s
fi

yay -Syu
sleep 0.2s

# Update flatpak packages
clear
echo "Updating flatpak"
flatpak update

# Press enter
echo " "
read -p "Press enter to close"