#!/bin/bash
brightness_step=5
notification_timeout=1000

# -----------------------------------------------------
# Uses regex to get brightness from xbacklight
function get_brightness {
    sudo light | grep -Po '[0-9]{1,3}' | head -n 1
}
# -----------------------------------------------------
# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_brightness_icon {
    brightness_icon=""
}
# -----------------------------------------------------
# Displays a brightness notification using dunstify
function show_brightness_notif {
    brightness=$(get_brightness)
    echo $brightness
    get_brightness_icon
    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:brightness_notif -h int:value:$brightness "$brightness_icon $brightness%" --transient
}


# Main function - Takes user input "brightness_up" or "brightness_down"
case $1 in
    brightness_up)
    # Increases brightness and displays the notification
    sudo light -A $brightness_step
    show_brightness_notif
    ;;

    brightness_down)
    # Decreases brightness and displays the notification
    sudo light -U $brightness_step
    show_brightness_notif
    ;;
esac