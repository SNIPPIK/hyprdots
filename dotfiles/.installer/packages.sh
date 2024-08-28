# Install arch packages
echo Installing need packages...
sudo pacman -S xorg-xwayland wayland wayland-protocols hyprland hyprpaper hypridle hyprlock waybar otf-font-awesome noto-fonts-emoji rofi-wayland nm-connection-editor pipewire-pulse wireplumber bluez blueberry pavucontrol nautilus polkit-gnome dunst grim slurp pacman-contrib sddm fastfetch starship gnome-keyring ttf-nerd-fonts-symbols-mono ttf-dejavu wl-clipboard

sleep 0.2s

# Run systemctl services
echo Run sddm service and bluetooth service

sudo systemctl enable sddm
sudo systemctl enable bluetooth