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

# Create link to source
echo WARNING backap your .config
read -p "Press enter to continue"

echo Create a links
# Link to alacritty
if [ -f ~/.config/alacritty ]; then
    rm -rd ~/.config/alacritty
    ln ${PWD}/.config/alacritty ~/.config
else
    ln ${PWD}/.config/alacritty ~/.config
fi

# Link to gtk 3
if [ -f ~/.config/gtk-3.0 ]; then
    rm -rd ~/.config/gtk-3.0
    ln ${PWD}/.config/gtk-3.0 ~/.config
else
    ln ${PWD}/.config/gtk-3.0 ~/.config
fi

# Link to gtk 4
if [ -f ~/.config/gtk-4.0 ]; then
    rm -rd ~/.config/gtk-4.0
    ln ${PWD}/.config/gtk-4.0 ~/.config
else
    ln ${PWD}/.config/gtk-4.0 ~/.config
fi

# Link to hypr
if [ -f ~/.config/hypr ]; then
    rm -rd ~/.config/hypr
    ln ${PWD}/.config/hypr ~/.config
else
    ln ${PWD}/.config/hypr ~/.config
fi

# Link to qt5ct
if [ -f ~/.config/qt5ct ]; then
    rm -rd ~/.config/qt5ct
    ln ${PWD}/.config/qt5ct ~/.config
else
    ln ${PWD}/.config/qt5ct ~/.config
fi

# Link to qt6ct
if [ -f ~/.config/qt6ct ]; then
    rm -rd ~/.config/qt6ct
    ln ${PWD}/.config/qt6ct ~/.config
else
    ln ${PWD}/.config/qt6ct ~/.config
fi

# Link to rofi
if [ -f ~/.config/rofi ]; then
    rm -rd ~/.config/rofi
    ln ${PWD}/.config/rofi ~/.config
else
    ln ${PWD}/.config/rofi ~/.config
fi

# Link to sddm
if [ -f ~/.config/sddm ]; then
    rm -rd ~/.config/sddm
    ln ${PWD}/.config/sddm ~/.config
else
    ln ${PWD}/.config/sddm ~/.config
fi

# Link to swaync
if [ -f ~/.config/swaync ]; then
    rm -rd ~/.config/swaync
    ln ${PWD}/.config/swaync ~/.config
else
    ln ${PWD}/.config/swaync ~/.config
fi

# Link to waybar
if [ -f ~/.config/waybar ]; then
    rm -rd ~/.config/waybar
    ln ${PWD}/.config/waybar ~/.config
else
    ln ${PWD}/.config/waybar ~/.config
fi

# Link to wlogout
if [ -f ~/.config/wlogout ]; then
    rm -rd ~/.config/wlogout
    ln ${PWD}/.config/wlogout ~/.config
else
    ln ${PWD}/.config/wlogout ~/.config
fi

# Create link to Pictures
ln ${PWD}/Pictures/Wallpapers ~/Pictures

#Unpack theme
echo Install 7zip
sudo pacman -S p7zip
echo Unpack Fluent
7z x ${PWD}/.themes/Fluent.zip -o${HOME}/.themes