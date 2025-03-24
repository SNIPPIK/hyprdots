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


# -----------------------------------------------------
# Displays a volume notification
function showOutputNotification {
    volume=$(getOutputVolume)
    getOutputIcon

    if [[ $show_music_in_volume_indicator == "true" ]]; then
        current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)

        if [[ $show_album_art == "true" ]]; then
            getTrackImage
        fi

        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" -i "$album_art" "$volume_icon $volume%" "$current_song"
    else
        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" "$volume_icon $volume%"
    fi
}

function getOutputVolume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}
function getOutputMute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}
function getOutputIcon {
    volume=$(getOutputVolume)
    mute=$(getOutputMute)
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
# -----------------------------------------------------
# Displays a volume notification
function showInputNotification {
    volume=$(getInputMute)
    getInputIcon

    if [[ $show_music_in_volume_indicator == "true" ]]; then
        current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)

        if [[ $show_album_art == "true" ]]; then
           getTrackImage
        fi

        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" -i "$album_art" "$volume_icon $volume%" "$current_song"
    else
        notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -h int:value:"$volume" "$volume_icon $volume%"
    fi
}

function getInputVolume {
    pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}
function getInputMute {
    pactl get-source-mute @DEFAULT_SOURCE@ | grep -Po '(?<=Mute: )(yes|no)'
}
function getInputIcon {
    volume=$(getInputVolume)
    mute=$(getInputMute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon=""
    else
        volume_icon=""
    fi
}
# -----------------------------------------------------


# -----------------------------------------------------
# Function to get metadata using playerctl
function playerMeta {
	playerctl metadata --format "{{ $1 }}" 2>/dev/null
}

function getPlayerStatus {
  status=$(playerctl status 2>/dev/null)
  	if [[ $status == "Playing" ]]; then
  		echo "󰎆"
  	elif [[ $status == "Paused" ]]; then
  		echo "󱑽"
  	else
  		echo ""
  	fi
}
function getAlbumName {
  album=$(playerctl metadata --format "{{ xesam:album }}" 2>/dev/null)
  	if [[ -n $album ]]; then
  		echo "$album"
  	else
  		status=$(playerctl status 2>/dev/null)
  		if [[ -n $status ]]; then
  			echo "Not album"
  		else
  			echo ""
  		fi
  	fi
}

# Displays a music notification
function getTrackImage {
    url=$(playerMeta "mpris:artUrl")
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

    # If music info is not founded
    if [ ! "$song_title" ]; then
      sleep 5s
      song_title=$(playerctl -f "{{title}}" metadata)

      # Last check
      if [ ! "$song_title" ]; then
        exit 0
      fi
    fi

    song_artist=$(playerctl -f "{{artist}}" metadata)
    song_duration=$(playerctl metadata --format "{{ duration(mpris:length) }}")
    song_current=$(playerctl position --format "{{ duration(position) }}")
    song_album=$(getAlbumName)
    player_status=$(getPlayerStatus)


    if [[ $show_album_art == "true" ]]; then
        getTrackImage
    fi

    notify-send -t $notification_timeout -h string:category:volume -h string:x-dunst-stack-tag:music_notif -i "$album_art" "$player_status $song_title" "$song_artist\n$song_current - $song_duration"
}
# -----------------------------------------------------

# Main function - Takes user input, "volume_up", "volume_down"
case $1 in
    # Toggles mute and displays the notification
    volume_mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    showOutputNotification
    ;;

    # Unmutes and increases volume, then displays the notification
    volume_up)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    volume=$(getOutputVolume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
    fi
    showOutputNotification
    ;;

    # Raises volume and displays the notification
    volume_down)
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    showOutputNotification
    ;;

    # Toggles mute and displays the notification
    micro_mute)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    showInputNotification
    ;;

    # Unmutes and increases volume, then displays the notification
    micro_volume_up)
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    volume=$(getInputVolume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-source-volume @DEFAULT_SOURCE@ $max_volume%
    else
        pactl set-source-volume @DEFAULT_SOURCE@ +$volume_step%
    fi
    showInputNotification
    ;;

    # Raises volume and displays the notification
    micro_volume_down)
    pactl set-source-volume @DEFAULT_SOURCE@ -$volume_step%
    showInputNotification
    ;;

     # Skips to the next song and displays the notification
    next_track)
    playerctl next
    sleep 1s && show_music_notification
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