#!/bin/bash
#  _   _           _       _
# | | | |_ __   __| | __ _| |_ ___  ___
# | | | | '_ \ / _` |/ _` | __/ _ \/ __|
# | |_| | |_) | (_| | (_| | ||  __/\__ \
#  \___/| .__/ \__,_|\__,_|\__\___||___/
#       |_|
# -----------------------------------------------------
# Requires pacman-contrib, aur

# Added a space in text and shorten it
stringToLen() {
  STRING="$1"
  LEN="$2"
  if [ ${#STRING} -gt "$LEN" ]; then
    printf "%-21s" "${STRING:0:$((LEN - 2))}..."
  else
    printf "%-20s" "$STRING"
  fi
}

# Get list packages
packages() {
  checkupdates --nocolor
  pacman -Qm #| aur vercmp
}
# -----------------------------------------------------

# Check updates
if [ "$1" == "check" ]; then
  # Crete list a packages
  mapfile -t updates < <(packages)
  text=${#updates[@]}
  tooltip="<b>$text updates (arch+aur) </b>\n"
  tooltip+="<b>$(stringToLen "Package" 20) # $(stringToLen "Current" 20) # $(stringToLen "Next" 20)</b>\n"

  for i in "${updates[@]}"; do
    update="$(stringToLen "$(echo "$i" | awk '{print $1}')" 20)"
    prev="$(stringToLen "$(echo "$i" | awk '{print $2}')" 20)"
    next="$(stringToLen "$(echo "$i" | awk '{print $4}')" 20)"

    tooltip+="<b>$update</b> # $prev # $next\n"
  done

  tooltip="$(echo "$tooltip" | column -t -s '  #  ')"
  tooltip=${tooltip::-2}

cat <<EOF
{ "text":"$text", "tooltip":"$tooltip"}
EOF
fi