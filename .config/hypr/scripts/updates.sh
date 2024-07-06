#!/bin/bash
#  _   _           _       _
# | | | |_ __   __| | __ _| |_ ___  ___
# | | | | '_ \ / _` |/ _` | __/ _ \/ __|
# | |_| | |_) | (_| | (_| | ||  __/\__ \
#  \___/| .__/ \__,_|\__,_|\__\___||___/
#       |_|
#
# by SNIPPIK (2024)
# -----------------------------------------------------
# Requires pacman-contrib, aurutils

check() {
  command -v "$1" 1>/dev/null
}

notify() {
  check notify-send && {
    notify-send -a "UpdateCheck Waybar" "$@"
    return
  }
  echo "$@"
}

stringToLen() {
  STRING="$1"
  LEN="$2"
  if [ ${#STRING} -gt "$LEN" ]; then
    echo "${STRING:0:$((LEN - 2))}.."
  else
    printf "%-20s" "$STRING"
  fi
}

cup() {
  checkupdates --nocolor
  pacman -Qm | aur vercmp
}
# -----------------------------------------------------

# Check aur packages
#check aur || {
#  notify "Ensure aurutils is installed"
#  cat <<EOF
#  {"text":"ERR","tooltip":"aurutils is not installed"}
#EOF
#  exit 1
#}

# Check arch packages
check checkupdates || {
  notify "Ensure pacman-contrib is installed"
  cat <<EOF
  {"text":"ERR","tooltip":"pacman-contrib is not installed"}
EOF
  exit 1
}
IFS=$'\n'$'\r'

killall -q checkupdates

# Crete list packages
mapfile -t updates < <(cup)
text=${#updates[@]}
tooltip="<b>$text updates (arch+aur) </b>\n"
tooltip+="\n<b>$(stringToLen "Current" 20) $(stringToLen "New" 20) $(stringToLen "Package" 20)</b>\n"

for i in "${updates[@]}"; do
  curr="$(stringToLen $(echo "$i" | awk '{print $1}') 30)"
  prev="$(stringToLen $(echo "$i" | awk '{print $2}') 20)"
  next="$(stringToLen $(echo "$i" | awk '{print $4}') 20)"

  tooltip+="$prev    $next <b>$curr</b>\n"
done
tooltip=${tooltip::-2}

# Output data
cat <<EOF
{ "text":"$text", "tooltip":"$tooltip"} "$updates" "$updates" "$updates"
EOF