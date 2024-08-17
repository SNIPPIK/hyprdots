#!/bin/sh

# Open hyprdots
cd ~/

# Update hyprdots
if [ -d ~/hyprdots ]; then
  echo Remove old hyprdots
  sudo rm -rd ~/hyprdots

  echo Install new hyprdots
  sleep 1
  git clone https://github.com/SNIPPIK/hyprdots.git

  echo Run installer
  sleep 1
  cd ~/hyprdots/dotfiles
  bash ./install.sh

  sleep 1
  echo Pls restart a waybar. WIN + F11

  sleep 5
  exit 0
else
  echo "Fail update, need to install! Not found ~/hyprdots/dotfiles!"
fi