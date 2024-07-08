#!/bin/sh

# Check root user
if [ "$USER" = "root" ]; then
    echo "Do not use root in this script, log in with another account"
    sleep 2
    exit 1
fi

echo WARNING backup your .config directory
read -p "Continue (y/n)?" choice
case "$choice" in
  y|Y ) echo "Continue to installing";;
  n|N ) exit 1;;
  * ) echo "Continue to installing";;
esac

# Link hyprdots
if [ ! -d ~/hyprdots ]; then
    ln -s ${PWD} ~/
fi

echo Create a links
# Link to alacritty
if [ -d ~/.config/alacritty ]; then
    rm -rd ~/.config/alacritty
    ln -s ~/hyprdots/.config/alacritty ~/.config
else
    ln -s ~/hyprdots/.config/alacritty ~/.config
fi

# Link to fastfetch
if [ -d ~/.config/fastfetch ]; then
    rm -rd ~/.config/fastfetch
    ln -s ~/hyprdots/.config/fastfetch ~/.config
else
    ln -s ~/hyprdots/.config/fastfetch ~/.config
fi

# Link to gtk 3
if [ -d ~/.config/gtk-3.0 ]; then
    rm -rd ~/.config/gtk-3.0
    ln -s ~/hyprdots/.config/gtk-3.0 ~/.config
else
    ln -s ~/hyprdots/.config/gtk-3.0 ~/.config
fi

# Link to gtk 4
if [ -d ~/.config/gtk-4.0 ]; then
    rm -rd ~/.config/gtk-4.0
    ln -s ~/hyprdots/.config/gtk-4.0 ~/.config
else
    ln -s ~/hyprdots/.config/gtk-4.0 ~/.config
fi

# Link to hypr
if [ -d ~/.config/hypr ]; then
    rm -rd ~/.config/hypr
    ln -s ~/hyprdots/.config/hypr ~/.config
else
    ln -s ~/hyprdots/.config/hypr ~/.config
fi

# Link to qt5ct
if [ -d ~/.config/qt5ct ]; then
    rm -rd ~/.config/qt5ct
    ln -s ~/hyprdots/.config/qt5ct ~/.config
else
    ln -s ~/hyprdots/.config/qt5ct ~/.config
fi

# Link to qt6ct
if [ -d ~/.config/qt6ct ]; then
    rm -rd ~/.config/qt6ct
    ln -s ~/hyprdots/.config/qt6ct ~/.config
else
    ln -s ~/hyprdots/.config/qt6ct ~/.config
fi

# Link to rofi
if [ -d ~/.config/rofi ]; then
    rm -rd ~/.config/rofi
    ln -s ~/hyprdots/.config/rofi ~/.config
else
    ln -s ~/hyprdots/.config/rofi ~/.config
fi

# Link to sddm
if [ -d ~/.config/sddm ]; then
    rm -rd ~/.config/sddm
    ln -s ~/hyprdots/.config/sddm ~/.config
else
    ln -s ~/hyprdots/.config/sddm ~/.config
fi

# Link to swaync
if [ -d ~/.config/swaync ]; then
    rm -rd ~/.config/swaync
    ln -s ~/hyprdots/.config/swaync ~/.config
else
    ln -s ~/hyprdots/.config/swaync ~/.config
fi

# Link to waybar
if [ -d ~/.config/waybar ]; then
    rm -rd ~/.config/waybar
    ln -s ~/hyprdots/.config/waybar ~/.config
else
    ln -s ~/hyprdots/.config/waybar ~/.config
fi

# Link to wlogout
if [ -d ~/.config/wlogout ]; then
    rm -rd ~/.config/wlogout
    ln -s ~/hyprdots/.config/wlogout ~/.config
else
    ln -s ~/hyprdots/.config/wlogout ~/.config
fi

# Link to waypaper
if [ -d ~/.config/waypaper ]; then
    rm -rd ~/.config/waypaper
    ln -s ~/hyprdots/.config/waypaper ~/.config
else
    ln -s ~/hyprdots/.config/waypaper ~/.config
fi

# Link to starship
if [ -d ~/.config/starship ]; then
    rm -rd ~/.config/starship
    ln -s ~/hyprdots/.config/starship ~/.config
else
    ln -s ~/hyprdots/.config/starship ~/.config
fi

# Link to bashrc
if [ -d ~/.bashrc ]; then
    rm -r ~/.bashrc
    ln -s ~/hyprdots/.bashrc ~/
else
    ln -s ~/hyprdots/.bashrc ~/
fi

# Create link to Pictures
ln -s ~/hyprdots/Pictures/Wallpapers ~/Pictures

# Install packages and yay
bash ~/hyprdots/.installer/packages.sh

#Unpack theme
echo Install 7zip
sudo pacman -S p7zip
echo Unpack Fluent
7z x ${HOME}/hyprdots/.themes/Fluent.zip -o${HOME}/.themes