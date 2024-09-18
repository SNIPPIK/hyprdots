# DPI Server
if ! ciadpi --help; then
   bash ~/.config/dunst/client/notifications.sh "no-icon" "temp" "System" "Not found package ciadpi. Need to install so work!" 4000
   exit 0
else
  clear
  echo Running DPI Server
  echo Your local proxy IP:127.0.0.1 Port:1080 Protocol:SOCKS5
  ciadpi -s 2 -d 2 --buf-size 9999999 --tfo --auto-mode 1 --auto=torst --tlsrec 1+s
fi

# Press enter
echo " "
read -p "Press enter to close"