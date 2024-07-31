#!/usr/bin/env bash
# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''
# -----------------------------------------------------
# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-mesg " User: ${USER} |  Uptime: $uptime" \
		-theme windows/power.rasi
}
# -----------------------------------------------------
# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg "Are you Sure? $1?" \
		-theme windows/confirm.rasi
}
# -----------------------------------------------------
# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd $1
}
# -----------------------------------------------------
# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}
# -----------------------------------------------------
# Execute Command
run_cmd() {
	selected="$(confirm_exit "$1")"
	if [[ "$selected" == "$yes" ]]; then
		sleep 0.25s
        if [[ "$1" == 'shutdown' ]]; then
            systemctl poweroff
        elif [[ "$1" == 'reboot' ]]; then
            systemctl reboot
        elif [[ "$1" == 'hibernate' ]]; then
            playerctl --all-players stop
            sleep 0.1s
            systemctl suspend-then-hibernate
        elif [[ "$1" == 'lock' ]]; then
            playerctl pause
            hyprlock
        elif [[ "$1" == 'suspend' ]]; then
            playerctl --all-players stop
            sleep 0.1s
            systemctl suspend
        elif [[ "$1" == 'logout' ]]; then
            hyprctl dispatch exit
        fi
	else
		exit 0
	fi
}
# -----------------------------------------------------
# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd shutdown
        ;;
    $reboot)
		run_cmd reboot
        ;;
    $lock)
		run_cmd lock
        ;;
    $suspend)
		run_cmd suspend
        ;;
    $logout)
		run_cmd logout
        ;;
esac
