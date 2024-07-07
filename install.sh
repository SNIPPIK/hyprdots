#!/bin/sh

# Check root user
if [ $USER = "root" ]; then
    echo "Do not use root in this script, log in with another account"
    sleep 2
    exit -1
fi

# Install arch packages
echo Install need packages...
sudo pacman -S hyprland hyprpaper hypridle waybar otf-font-awesome noto-fonts-emoji rofi-wayland nm-connection-editor pipewire-pulse wireplumber bluez blueberry pavucontrol nautilus polkit-gnome swaync grim slurp pacman-contrib sddm fastfetch starship

sleep 1

# Install from yay
if [ yay ]; then
  echo Install from aur
  yay -S wlogout waypaper
else
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si

  yay -S wlogout waypaper
fi

sleep 1

# Create link to source
echo WARNING backap your .config
read -p "Press enter to continue"

# Link hyprdots
if [ -f ~/hyprdots ]; then
    rm -rd ~/hyprdots
    ln -s ${PWD} ~/.cache
else
    ln -s ${PWD} ~/.cache
fi

echo Create a links
# Link to alacritty
if [ -f ~/.config/alacritty ]; then
    rm -rd ~/.config/alacritty
    ln -s ${PWD}/.config/alacritty ~/.config
else
    ln -s ${PWD}/.config/alacritty ~/.config
fi

# Link to fastfetch
if [ -f ~/.config/fastfetch ]; then
    rm -rd ~/.config/fastfetch
    ln -s ${PWD}/.config/fastfetch ~/.config
else
    ln -s ${PWD}/.config/fastfetch ~/.config
fi

# Link to gtk 3
if [ -f ~/.config/gtk-3.0 ]; then
    rm -rd ~/.config/gtk-3.0
    ln -s ${PWD}/.config/gtk-3.0 ~/.config
else
    ln -s ${PWD}/.config/gtk-3.0 ~/.config
fi

# Link to gtk 4
if [ -f ~/.config/gtk-4.0 ]; then
    rm -rd ~/.config/gtk-4.0
    ln -s ${PWD}/.config/gtk-4.0 ~/.config
else
    ln -s ${PWD}/.config/gtk-4.0 ~/.config
fi

# Link to hypr
if [ -f ~/.config/hypr ]; then
    rm -rd ~/.config/hypr
    ln -s ${PWD}/.config/hypr ~/.config
else
    ln -s ${PWD}/.config/hypr ~/.config
fi

# Link to qt5ct
if [ -f ~/.config/qt5ct ]; then
    rm -rd ~/.config/qt5ct
    ln -s ${PWD}/.config/qt5ct ~/.config
else
    ln -s ${PWD}/.config/qt5ct ~/.config
fi

# Link to qt6ct
if [ -f ~/.config/qt6ct ]; then
    rm -rd ~/.config/qt6ct
    ln -s ${PWD}/.config/qt6ct ~/.config
else
    ln -s ${PWD}/.config/qt6ct ~/.config
fi

# Link to rofi
if [ -f ~/.config/rofi ]; then
    rm -rd ~/.config/rofi
    ln -s ${PWD}/.config/rofi ~/.config
else
    ln -s ${PWD}/.config/rofi ~/.config
fi

# Link to sddm
if [ -f ~/.config/sddm ]; then
    rm -rd ~/.config/sddm
    ln -s ${PWD}/.config/sddm ~/.config
else
    ln -s ${PWD}/.config/sddm ~/.config
fi

# Link to swaync
if [ -f ~/.config/swaync ]; then
    rm -rd ~/.config/swaync
    ln -s ${PWD}/.config/swaync ~/.config
else
    ln -s ${PWD}/.config/swaync ~/.config
fi

# Link to waybar
if [ -f ~/.config/waybar ]; then
    rm -rd ~/.config/waybar
    ln -s ${PWD}/.config/waybar ~/.config
else
    ln -s ${PWD}/.config/waybar ~/.config
fi

# Link to wlogout
if [ -f ~/.config/wlogout ]; then
    rm -rd ~/.config/wlogout
    ln -s ${PWD}/.config/wlogout ~/.config
else
    ln -s ${PWD}/.config/wlogout ~/.config
fi

# Link to waypaper
if [ -f ~/.config/waypaper ]; then
    rm -rd ~/.config/waypaper
    ln -s ${PWD}/.config/waypaper ~/.config
else
    ln -s ${PWD}/.config/waypaper ~/.config
fi

# Link to starship
if [ -f ~/.config/starship ]; then
    rm -rd ~/.config/starship
    ln -s ${PWD}/.config/starship ~/.config
else
    ln -s ${PWD}/.config/starship ~/.config
fi

# Link to bashrc
if [ -f ~/.bashrc ]; then
    rm -r ~/.bashrc
    ln -s ${PWD}/.bashrc ~/
else
    ln -s ${PWD}/.bashrc ~/
fi

# Create link to Pictures
ln -s ${PWD}/Pictures/Wallpapers ~/Pictures

#Unpack theme
echo Install 7zip
sudo pacman -S p7zip
echo Unpack Fluent
7z x ${PWD}/.themes/Fluent.zip -o${HOME}/.themes