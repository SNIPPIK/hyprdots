shutdown=''
suspend=''
reboot=''
logout=''
lock=''
yes=''
no=''
# -----------------------------------------------------
# Open power menu
function menu_select() {
	rofi -dmenu \
		-mesg " User: ${USER} |  Uptime: $(uptime -p | sed -e 's/up //g')" \
		-theme windows/power.rasi
}
# -----------------------------------------------------
# Confirmation CMD
function confirm() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg "Are you Sure? $1?" \
		-theme windows/confirm.rasi
}
# -----------------------------------------------------
# Actions
chosen="$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | menu_select)"
selected="$(echo -e "$yes\n$no" | confirm "$chosen")"

# If not selected yes
if [ ! "$selected" == "$yes" ]; then
  exit 0
fi

case ${chosen} in
    # Shutdown system
    "$shutdown")
        systemctl poweroff
    ;;

    # Reboot system
    "$reboot")
        systemctl reboot
    ;;

    # Lock system
    "$lock")
    	  playerctl pause
        hyprlock
    ;;

    # Pause system
    "$suspend")
        playerctl --all-players stop
        sleep 0.1s
        systemctl suspend
    ;;

    # Logout system
    "$logout")
        hyprctl dispatch exit
    ;;
esac