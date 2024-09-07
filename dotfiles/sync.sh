#!/bin/sh

# Check root user
if [ "$USER" = "root" ]; then
    echo "Do not use root in this script, login in with another account"
    exit 0
fi

version="$(curl https://raw.githubusercontent.com/SNIPPIK/hyprdots/main/dotfiles/version)"
current="$(cat ~/hyprdots/dotfiles/version)"

# Check version hyprdots
if [ "$version" = "$current" ]; then
  echo "The latest version is already installed"
  sleep 5s
  exit 0;
fi

# Open home directory
cd ~/

# Check directory
if [ -d ~/hyprdots ]; then
  echo Remove old hyprdots
  sudo rm -rd ~/hyprdots

  sleep 0.5s
fi

# Install new version hyprdots
echo Install hyprdots by SNIPPIK
sleep 0.2s
git clone https://github.com/SNIPPIK/hyprdots
cd ~/hyprdots/dotfiles
bash ./install.sh