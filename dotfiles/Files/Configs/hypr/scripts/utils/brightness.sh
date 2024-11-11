#!/bin/bash
#  ____       _       _     _
# | __ ) _ __(_) __ _| |__ | |_ _ __   ___  ___ ___
# |  _ \| '__| |/ _` | '_ \| __| '_ \ / _ \/ __/ __|
# | |_) | |  | | (_| | | | | |_| | | |  __/\__ \__ \
# |____/|_|  |_|\__, |_| |_|\__|_| |_|\___||___/___/
#               |___/
# -----------------------------------------------------
# Requires brightnessctl

brightness_step=5
notification_timeout=1000

# -----------------------------------------------------
# Uses regex to get brightness from xbacklight
function get_brightness {
    LIGHT=$(printf "%.0f\n" $(brightnessctl g))
    echo "${LIGHT}"
}
# -----------------------------------------------------
# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_brightness_icon {
    brightness_icon=""
}
# -----------------------------------------------------
# Displays a brightness notification using dunstify
function show_brightness_notification {
    brightness=$(get_brightness)
    echo "$brightness"
    get_brightness_icon
    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:brightness_notif -h int:value:"$brightness" "$brightness_icon $brightness%" --transient
}
# -----------------------------------------------------
# Displays a brightness notification using dunstify
function show_brightness_kb_notification {
   	brightness="$(cat /sys/class/leds/*::kbd_backlight/brightness)"
   	echo "${brightness}"
    get_brightness_icon
    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:brightness_notif -h int:value:"$brightness" "$brightness_icon $brightness%" --transient
}


# Main function - Takes user input "brightness_up" or "brightness_down"
case $1 in
    brightness_up)
    # Increases brightness and displays the notification
    brightnessctl s +$brightness_step%
    show_brightness_notification
    ;;

    brightness_down)
    # Decreases brightness and displays the notification
    brightnessctl s $brightness_step%-
    show_brightness_notification
    ;;

    brightness_kb_up)
    # Increases brightness and displays the notification
    brightnessctl -d *::kbd_backlight set 33%+
    show_brightness_kb_notification
    ;;

    brightness_kb_down)
    # Decreases brightness and displays the notification
    brightnessctl -d *::kbd_backlight set 33%-
    show_brightness_kb_notification
    ;;
esac