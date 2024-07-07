#!/bin/sh

# Update hyprdots
if [ -d ~/hyprdots ]; then
  cd ~/hyprdots
  git pull
else
  echo "Fail update, need to install! Not found ~/hyprdots!"
fi