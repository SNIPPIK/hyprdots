# Create link to directory
function linkConfig() {
  if [ -h $HOME/.config/"$1" ] || [ -d $HOME/.config/"$1" ]; then
        rm -rd $HOME/.config/"$1"
        ln -s $HOME/hyprdots/dotfiles/Files/Configs/"$1" $HOME/.config
        echo Created link to "$1", file exists, remove and create
    else
        echo Created link to "$1"
        ln -s $HOME/hyprdots/dotfiles/Files/Configs/"$1" $HOME/.config
    fi
}

# Create link to file
function link() {
  if [ -h $HOME/"$1" ] || [ -f $HOME/"$1" ]; then
      rm -r $HOME/"$1"
      ln -s $HOME/hyprdots/dotfiles/Files/Additions/"$1" $HOME/
      echo Created link to "$1", file exists, remove and create
  else
      echo Created link to "$1"
      ln -s $HOME/hyprdots/dotfiles/Files/Additions/"$1" $HOME/
  fi
}

# Linking directories
# shellcheck disable=SC2045
for path in $(ls $HOME/hyprdots/dotfiles/Files/Configs)
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
if [ -d $HOME/Pictures ] || [ -h $HOME/Pictures ]; then
   # Create wallpaper dir
   if [ -d $HOME/Pictures/Wallpapers ] || [ -h $HOME/Pictures/Wallpapers ]; then
       cp -r $HOME/hyprdots/dotfiles/Pictures/Wallpapers/hyprland.png $HOME/Pictures/Wallpapers/hyprland.png
       cp -r $HOME/hyprdots/dotfiles/Pictures/Wallpapers/hyprlock.png $HOME/Pictures/Wallpapers/hyprlock.png
   else
     cp -r $HOME/hyprdots/dotfiles/Pictures/Wallpapers $HOME/Pictures/Wallpapers
   fi
else
  cp -r $HOME/hyprdots/dotfiles/Pictures $HOME/Pictures
fi

echo Install fonts for waybar
choice

# Create dir fonts
if [ ! -h $HOME/.fonts ]; then
  mkdir $HOME/.fonts
fi

# Create link to wifi font
# shellcheck disable=SC2045
for path in $(ls $HOME/hyprdots/dotfiles/Files/Fonts)
do
  if [ "$path" ]; then
    cp $HOME/hyprdots/dotfiles/Files/Fonts/"$path" $HOME/.fonts
  fi
done

fc-cache -f -v