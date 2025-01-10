#!/bin/bash
#     _             _ _         ____        _       ____            _
#    / \  _   _  __| (_) ___   / ___| _   _| |__   / ___| _   _ ___| |_ ___ _ __ ___
#   / _ \| | | |/ _` | |/ _ \  \___ \| | | | '_ \  \___ \| | | / __| __/ _ \ '_ ` _ \
#  / ___ \ |_| | (_| | | (_) |  ___) | |_| | |_) |  ___) | |_| \__ \ ||  __/ | | | | |
# /_/   \_\__,_|\__,_|_|\___/  |____/ \__,_|_.__/  |____/ \__, |___/\__\___|_| |_| |_|
#                                                         |___/
# -----------------------------------------------------
volume_step=1
max_volume=120
notification_timeout=2000
download_album_art=true
show_album_art=true
show_music_in_volume_indicator=true
# -----------------------------------------------------
# Uses regex to get volume from pactl
function get_volume_output {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}
function get_mute_output {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}
# -----------------------------------------------------
# Uses regex to get volume from pactl
function get_volume_input {
    pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}
function get_mute_input {
    pactl get-source-mute @DEFAULT_SOURCE@ | grep -Po '(?<=Mute: )(yes|no)'
}
# -----------------------------------------------------
# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_output_icon {
    volume=$(get_volume_output)
    mute=$(get_mute_output)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon=""
    elif [ "$volume" -lt 40 ]; then
        volume_icon=""
    elif [ "$volume" -lt 60 ]; then
        volume_icon=""
    elif [ "$volume" -lt 80 ]; then
          volume_icon="󰕾"
    elif [ "$volume" -lt 100 ]; then
          volume_icon="Warning 󰕾"
    else
        volume_icon=""
    fi
}
function get_input_icon {
    volume=$(get_volume_input)
    mute=$(get_mute_input)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon=""
    else
        volume_icon=""
    fi
}
# -----------------------------------------------------
# Displays a music notification
function get_album_art {
    url=$(playerctl -f "{{mpris:artUrl}}" metadata)
    if [[ $url == "file://"* ]]; then
        album_art="${url/file:\/\//}"
    elif [[ $url == "http://"* ]] && [[ $download_album_art == "true" ]]; then
        # Identify filename from URL
        filename="$(echo "$url" | sed "s/.*\///")"

        # Download file to /tmp if it doesn't exist
        if [ ! -f "/tmp/$filename" ]; then
            wget -O "/tmp/$filename" "$url"
        fi

        album_art="/tmp/$filename"
    elif [[ $url == "https://"* ]] && [[ $download_album_art == "true" ]]; then
        # Identify filename from URL
        filename="$(echo "$url" | sed "s/.*\///")"

        # Download file to /tmp if it doesn't exist
        if [ ! -f "/tmp/$filename" ]; then
            wget -O "/tmp/$filename" "$url"
        fi

        album_art="/tmp/$filename"
    else
        album_art=""
    fi
}
function show_music_notification {
    song_title=$(playerctl -f "{{title}}" metadata)
    song_artist=$(playerctl -f "{{artist}}" metadata)
    song_album=$(playerctl -f "{{album}}" metadata)

    if [[ $show_album_art == "true" ]]; then
        get_album_art
    fi

    notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$song_title" "$song_artist - $song_album"
}
# -----------------------------------------------------
# Displays a volume notification
function show_volume_notification {
    volume=$(get_volume_output)
    get_output_icon

    if [[ $show_music_in_volume_indicator == "true" ]]; then
        current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)

        if [[ $show_album_art == "true" ]]; then
            get_album_art
        fi

        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" -i "$album_art" "$volume_icon $volume%" "$current_song"
    else
        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" "$volume_icon $volume%"
    fi
}
# Displays a volume notification
function show_micro_notification {
    volume=$(get_mute_input)
    get_input_icon

    if [[ $show_music_in_volume_indicator == "true" ]]; then
        current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)

        if [[ $show_album_art == "true" ]]; then
           get_album_art
        fi

        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" -i "$album_art" "$volume_icon $volume%" "$current_song"
    else
        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" "$volume_icon $volume%"
    fi
}
# -----------------------------------------------------

# Main function - Takes user input, "volume_up", "volume_down"
case $1 in
    # Toggles mute and displays the notification
    volume_mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    show_volume_notification
    ;;

    # Unmutes and increases volume, then displays the notification
    volume_up)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    volume=$(get_volume_output)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
    fi
    show_volume_notification
    ;;

    # Raises volume and displays the notification
    volume_down)
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    show_volume_notification
    ;;

    # Toggles mute and displays the notification
    micro_mute)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    show_micro_notification
    ;;

    # Unmutes and increases volume, then displays the notification
    micro_volume_up)
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    volume=$(get_volume_input)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-source-volume @DEFAULT_SOURCE@ $max_volume%
    else
        pactl set-source-volume @DEFAULT_SOURCE@ +$volume_step%
    fi
    show_micro_notification
    ;;

    # Raises volume and displays the notification
    micro_volume_down)
    pactl set-source-volume @DEFAULT_SOURCE@ -$volume_step%
    show_micro_notification
    ;;

     # Skips to the next song and displays the notification
    next_track)
    playerctl next
    sleep 1 && show_music_notification
    ;;

    # Skips to the previous song and displays the notification
    prev_track)
    playerctl previous
    sleep 0.5 && show_music_notification
    ;;

    # Pauses/resumes playback and displays the notification
    play_pause)
    playerctl play-pause
    show_music_notification
    ;;
esac