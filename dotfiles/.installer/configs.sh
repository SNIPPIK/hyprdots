# Create link to directory
function linkConfig() {
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
function link() {
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


# Create Pictures dir
if [ -d ~/Pictures ] || [ -h ~/Pictures ]; then
   # Create wallpaper dir
   if [ -d ~/Pictures/Wallpapers ] || [ -h ~/Pictures/Wallpapers ]; then
       cp -r ~/hyprdots/dotfiles/Pictures/Wallpapers/hyprland.png ~/Pictures/Wallpapers/hyprland.png
       cp -r ~/hyprdots/dotfiles/Pictures/Wallpapers/hyprlock.png ~/Pictures/Wallpapers/hyprlock.png
   else
     cp -r ~/hyprdots/dotfiles/Pictures/Wallpapers ~/Pictures/Wallpapers
   fi
else
  cp -r ~/hyprdots/dotfiles/Pictures ~/Pictures
fi

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