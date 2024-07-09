#!/bin/sh
# -----------------------------------------------------
# Create link to directory
linkConfig() {
  if [ -d ~/.config/"$1" ]; then
      rm -rd ~/.config/"$1"
      ln -s ~/hyprdots/.config/"$1" ~/.config
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s ~/hyprdots/.config/"$1" ~/.config
  fi
}

# Create link to directory
link() {
  if [ -f ~/.files/"$1" ]; then
      rm -rd ~/.files/"$1"
      ln -s ~/hyprdots/.files/"$1" ~/
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s ~/hyprdots/.files/"$1" ~/
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
  linkConfig "$path"
done

# Linking files
# shellcheck disable=SC2045
for file in ".bashrc" ".gtkrc-2.0"
do
  link "$file"
done

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