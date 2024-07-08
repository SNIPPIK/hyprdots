# Install arch packages
echo Install need packages...
sudo pacman -S hyprland hyprpaper hypridle waybar otf-font-awesome noto-fonts-emoji rofi-wayland nm-connection-editor pipewire-pulse wireplumber bluez blueberry pavucontrol nautilus polkit-gnome swaync grim slurp pacman-contrib sddm fastfetch starship gnome-keyring

sleep 1

# Install from yay
if yay
then
  echo Install from aur
  yay -S wlogout waypaper
else
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  yay -S wlogout waypaper
fi

# Run systemctl services
echo Run sddm service and bluetooth service
sudo systemctl enable sddm && sudo systemctl enable bluetooth