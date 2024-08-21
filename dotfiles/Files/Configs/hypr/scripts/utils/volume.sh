#!/bin/sh
dir=~/.config/hypr/icons/
# -----------------------------------------------------
# Notification a change wallpaper
notify() {
  bash ~/.config/hypr/scripts/utils/notifications.sh "icon" "temp" "Volume" "$1" "$2" 700
}
# Volume output
output_volume() {
  pactl get-sink-volume 0 | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}
input_volume() {
  pactl get-source-volume 0 | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}
# -----------------------------------------------------

# mute volume
if [ "$1" = "output-mute" ]; then
  pactl set-sink-mute 0 toggle

  if [ "$(pactl get-source-mute 0)" = "Mute: no" ]; then
      notify "Output: disable mute" "$dir/vol.png"
    else
      notify "Output: enable mute" "$dir/vol-muted.png"
    fi
fi

# Plus volume
if [ "$1" = "output-set+" ]; then
  if [ "$(output_volume)" -ge 150 ]; then
      notify "Output a max volume" "$dir/vol-up.png"
      exit 0
  fi

  pactl set-sink-volume 0 +2%
  notify "Output set $(output_volume)" "$dir/vol-up.png"
fi

# - volume
if [ "$1" = "output-set-" ]; then
  if [ "$(output_volume)" -le 0 ]; then
      notify "Output a max volume" "$dir/vol-up.png"
      exit 0
  fi

  pactl set-sink-volume 0 -2%
  notify "Output set $(output_volume)" "$dir/vol-down.png"
fi

# -----------------------------------------------------

# Mute input volume
if [ "$1" = "input-mute" ]; then
    pactl set-source-mute 0 toggle

  if [ "$(pactl get-source-mute 0)" = "Mute: no" ]; then
    notify "Microphone: disable mute" "$dir/mic.png"
  else
    notify "Microphone: enable mute" "$dir/mic-muted.png"
  fi
fi

# - input volume
if [ "$1" = "input-set-" ]; then
  if [ "$(input_volume)" -le 0 ]; then
      notify "Microphone a min volume" "$dir/mic-down.png"
      exit 0
  fi

  pactl set-source-volume 0 -2%
  notify "Microphone set $(input_volume)" "$dir/mic-down.png"
fi

# + input volume
if [ "$1" = "input-set+" ]; then
  if [ "$(input_volume)" -ge 150 ]; then
      notify "Microphone a max volume" "$dir/mic-up.png"
      exit 0
  fi

  pactl set-source-volume 0 +2%
  notify "Microphone set $(input_volume)" "$dir/mic-up.png"
fi

# -----------------------------------------------------