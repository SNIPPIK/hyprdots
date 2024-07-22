# Install arch packages
echo Install need packages...
sudo pacman -S hyprland hyprpaper hypridle hyprlock waybar otf-font-awesome noto-fonts-emoji rofi-wayland nm-connection-editor pipewire-pulse wireplumber bluez blueberry pavucontrol nautilus polkit-gnome swaync grim slurp pacman-contrib sddm fastfetch starship gnome-keyring ttf-nerd-fonts-symbols-mono ttf-dejavu yad

sleep 1

# Install from paru
if paru
then
  echo Find paru
else
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
fi

# Run systemctl services
echo Run sddm service and bluetooth service
sudo systemctl enable sddm && sudo systemctl enable bluetooth