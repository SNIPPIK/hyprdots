#!/bin/sh

# Open hyprdots
cd ~/

# Update hyprdots
if [ -d ~/hyprdots ]; then
  rm -rd ~/hyprdots

  sleep 1
  git clone https://github.com/SNIPPIK/hyprdots.git

  sleep 1
  cd ~/hyprdots
  bash ./install.sh
else
  echo "Fail update, need to install! Not found ~/hyprdots!"
fi