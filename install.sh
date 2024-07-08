#!/bin/sh
# -----------------------------------------------------
# Create link to directory
link() {
  if [ -d ~/.config/"$1" ]; then
      rm -rd ~/.config/"$1"
      ln -s ~/hyprdots/.config/"$1" ~/.config
      echo Created link to "$1"
  else
      echo Fail a created link to "$1", file exists
      ln -s ~/hyprdots/.config/"$1" ~/.config
  fi
}

# The user's response is required
choice() {
  read -p "Continue (y/n)? " choice
  case "$choice" in
    y|Y|н|Н ) echo "next";;
    n|N|т|Т ) exit 0;;
    * ) echo "next";;
  esac
}
# -----------------------------------------------------
# Check root user
if [ "$USER" = "root" ]; then
    echo "Do not use root in this script, log in with another account"
    sleep 2
    exit 1
fi


# -----------------------------------------------------
echo WARNING backup your .config directory
choice

# Link hyprdots
if [ ! -d ~/hyprdots ]; then
    ln -s "${PWD}" ~/
fi

# Linking directories
# shellcheck disable=SC2045
for path in $(ls ~/hyprdots/.config)
do
  link "$path"
done

# Link to bashrc
if [ -d ~/.bashrc ]; then
    rm -r ~/.bashrc
    ln -s ~/hyprdots/.bashrc ~/
else
    ln -s ~/hyprdots/.bashrc ~/
fi

# Create link to Pictures
ln -s ~/hyprdots/Pictures/Wallpapers ~/Pictures


# -----------------------------------------------------
echo Install packages
choice

# Install packages and yay
bash ~/hyprdots/.installer/packages.sh


# -----------------------------------------------------
echo Unpack dark theme
choice

#Unpack theme
echo Install 7zip
sudo pacman -S p7zip
echo Unpack Fluent
7z x "${HOME}"/hyprdots/.themes/Fluent.zip -o"${HOME}"/.themes
# -----------------------------------------------------