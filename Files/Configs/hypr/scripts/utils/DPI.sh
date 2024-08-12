#!/bin/sh
# -----------------------------------------------------
# Running DPI Server
running() {
  echo Running DPI Server
  echo Pls added proxy IP:127.0.0.1 Port:1080 Protocol:SOCKS5
  ciadpi -s 2 -d 2
}

# Check package
if ciadpi
then
  running
else
  yay -S byedpi-bin
  running
fi