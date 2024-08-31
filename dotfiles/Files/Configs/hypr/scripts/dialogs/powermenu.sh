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
# Execute Command
function run_cmd() {
	selected="$(echo -e "$yes\n$no" | confirm "$1")"

	# If not selected yes
	if [ ! "$selected" == "$yes" ]; then
	  exit 0
	fi

	# Wait 0.25 sec
	sleep 0.25s

	if [ "$1" == 'shutdown' ]; then
	  systemctl poweroff
	elif [ "$1" == 'suspend' ]; then
	  playerctl --all-players stop
    sleep 0.1s
    systemctl suspend
	elif [ "$1" == 'reboot' ]; then
	  systemctl reboot
	elif [ "$1" == 'hibernate' ]; then
	  playerctl --all-players stop
    sleep 0.1s
    systemctl suspend-then-hibernate
	elif [ "$1" == 'lock' ]; then
	  playerctl pause
    hyprlock
	elif [ "$1" == 'logout' ]; then
	  hyprctl dispatch exit
	fi
}
# -----------------------------------------------------
# Actions
chosen="$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | menu_select)"
case ${chosen} in
    "$shutdown")    run_cmd shutdown ;;
    "$reboot")      run_cmd reboot   ;;
    "$lock")        run_cmd lock     ;;
    "$suspend")	    run_cmd suspend  ;;
    "$logout")	    run_cmd logout   ;;
esac