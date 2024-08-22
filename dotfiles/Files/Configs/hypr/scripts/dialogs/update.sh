  echo "Update system"
  sudo pacman -Syu
  sleep 0.2

  clear
  echo "Update flatpak"
  flatpak update

  echo " "
  read -p "Press enter to close"