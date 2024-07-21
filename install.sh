#!/bin/sh
# -----------------------------------------------------
# Create link to directory
linkConfig() {
  if [ -h ~/.config/"$1" ] || [ -d ~/.config/"$1" ]; then
      rm -rd ~/.config/"$1"
      ln -s ~/hyprdots/Files/Configs/"$1" ~/.config
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s ~/hyprdots/Files/Configs/"$1" ~/.config
  fi
}

# Create link to directory
link() {
  if [ -h ~/"$1" ] || [ -f ~/"$1" ]; then
      rm -r ~/"$1"
      ln -s ~/hyprdots/Files/Additions/"$1" ~/
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s ~/hyprdots/Files/Additions/"$1" ~/
  fi
}

# Need to update hyprdots
cp ~/hyprdots/sync.sh ~/.cache

# The user's response is required
choice() {
  read -p "Continue (y/n)? " choice
  case "$choice" in
    y|Y|н|Н ) echo "Continue...";;
    n|N|т|Т ) exit 0;;
    * ) echo "Continue...";;
  esac
}
# -----------------------------------------------------
# Check root user
if [ "$USER" = "root" ]; then
    echo "Do not use root in this script, log in with another account"
    sleep 2
    exit 1
fi

# If not directory Configs
if [ ! -d ~/.config ]; then
  mkdir ~/.config
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
for path in $(ls ~/hyprdots/Files/Configs)
do
  if [ "$path" ]; then
    linkConfig "$path"
  fi
done

# Linking files
# shellcheck disable=SC2045
for file in ".bashrc" ".gtkrc-2.0"
do
   if [ "$file" ]; then
      link "$file"
   fi
done

# Create link to Pictures
ln -s ~/hyprdots/Pictures/Wallpapers ~/Pictures

echo Install fonts for waybar
choice

# Create dir fonts
if [ ! -h ~/.fonts ]; then
  mkdir ~/.fonts
fi

# Create link to wifi font
# shellcheck disable=SC2045
for path in $(ls ~/hyprdots/Files/Fonts)
do
  if [ "$path" ]; then
    cp ~/hyprdots/Files/Fonts/"$path" ~/.fonts
  fi
done

fc-cache -f -v

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
7z x "${HOME}"/hyprdots/Files/Theme/Fluent.zip -o"${HOME}"/.themes
# -----------------------------------------------------