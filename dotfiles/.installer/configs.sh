# Create link to directory
linkConfig() {
  if [ -h ~/.config/"$1" ] || [ -d ~/.config/"$1" ]; then
      rm -rd ~/.config/"$1"
      ln -s ~/hyprdots/dotfiles/Files/Configs/"$1" ~/.config
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s ~/hyprdots/dotfiles/Files/Configs/"$1" ~/.config
  fi
}

# Create link to file
link() {
  if [ -h ~/"$1" ] || [ -f ~/"$1" ]; then
      rm -r ~/"$1"
      ln -s ~/hyprdots/dotfiles/Files/Additions/"$1" ~/
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s ~/hyprdots/dotfiles/Files/Additions/"$1" ~/
  fi
}


# Linking directories
# shellcheck disable=SC2045
for path in $(ls ~/hyprdots/dotfiles/Files/Configs)
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
ln -s ~/hyprdots/dotfiles/Pictures/Wallpapers ~/Pictures

echo Install fonts for waybar
choice

# Create dir fonts
if [ ! -h ~/.fonts ]; then
  mkdir ~/.fonts
fi

# Create link to wifi font
# shellcheck disable=SC2045
for path in $(ls ~/hyprdots/dotfiles/Files/Fonts)
do
  if [ "$path" ]; then
    cp ~/hyprdots/dotfiles/Files/Fonts/"$path" ~/.fonts
  fi
done

fc-cache -f -v