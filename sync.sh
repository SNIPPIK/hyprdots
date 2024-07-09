#!/bin/sh

# Update hyprdots
if [ -d ~/hyprdots ]; then
  cd ~/hyprdots
  git reset --hard origin/main
else
  echo "Fail update, need to install! Not found ~/hyprdots!"
fi