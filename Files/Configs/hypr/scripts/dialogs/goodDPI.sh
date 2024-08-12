#!/bin/sh
# -----------------------------------------------------

echo Running DPI Server, need aur package - ciadpi
echo Pls added proxy IP:127.0.0.1 Port:1080 Protocol:SOCKS5
ciadpi -s 2 -d 2

echo " "
read -p "Press enter to close"