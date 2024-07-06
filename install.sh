#!/bin/sh

# Install arch packages
echo Install need packages...
sudo pacman -S hyprland hyprpaper hypridle waybar otf-font-awesome noto-fonts-emoji rofi-wayland nm-connection-editor pipewire-pulse wireplumber bluez blueberry pavucontrol nautilus polkit-gnome swaync grim slurp pacman-contrib sddm

sleep 1

# Install from yay
if [ yay ]; then
  echo Install from aur
  yay -S wlogout
else
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  yay -S wlogout
fi

sleep 1

#Unpack theme
echo Install 7zip
sudo pacman -S p7zip
echo Unpack Fluent
7z x ${PWD}/.themes/Fluent.zip -o${HOME}/.themes

sleep 1

#Copy configs
echo Copy configs in your .config dir
cp -rf ${PWD}/.config ~/

sleep 1

#Copy wallpaper
echo Copy default wallpaper
cp -rf ${PWD}/Pictures ~/

sleep 1

#Enable services
echo Enable services - sddm, bluetooth, NetworkManager

sudo systemctl enable bluetooth.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable sddm.service