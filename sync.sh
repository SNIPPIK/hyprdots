#!/bin/sh

# Open hyprdots
cd ~/hyprdots

# Update hyprdots
if [ -d ~/hyprdots ]; then
  git reset --hard origin/main
else
  echo "Fail update, need to install! Not found ~/hyprdots!"
fi

# Reinstall
bash ./install.sh