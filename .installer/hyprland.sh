
# Remove current libs and install git libs
if [ "$1" == "git" ]; then
  echo Remove current packages...
  sudo pacman -Rsc hyprland hyprutils hyprcursor hyprlang hyprlock

  sleep 0.5

  if yay
  then
      yay -S hyprland-git hyprlang-git hyprcursor-git hyprutils-git hyprlock-git
  elif paru
  then
      paru -S hyprland-git hyprlang-git hyprcursor-git hyprutils-git hyprlock-git
  else
      echo Not found aur installers, pls install yay or paru!
      exit 1
  fi

  echo Install wallpaper engine and idle manager...
  sudo pacman -S hyprpaper hypridle libdisplay-info xdg-desktop-portal-hyprland xorg-xinput
fi

# Remove git libs and install stable libs
if [ "$1" == "stable" ]; then
  echo Remove git packages...
  sudo pacman -Rsc hyprland-git hyprutils-git hyprcursor-git hyprlang-git hyprlock-git

  sleep 0.5
  sudo pacman -S hyprland hyprutils hyprcursor hyprlang hyprpaper hypridle hyprlock libdisplay-info xdg-desktop-portal-hyprland xorg-xinput
fi