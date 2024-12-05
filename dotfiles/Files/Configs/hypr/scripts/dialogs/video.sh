gpu="$(lspci  -v -s  "$(lspci | grep ' VGA ' | cut -d" " -f 1)")"
tooltip=""

echo $gpu

# Print vendor name
if [ "$1" == "info" ]; then
  if [[ "$gpu" == "*NVIDIA Corporation*" ]]; then

    # Check driver
    if [ "$(pacman -Qs "nvidia")" ]; then
      tooltip+="[Proprietary] NVIDIA\nDriver: nvidia"
    elif [ "$(pacman -Qs "nvidia-open")" ]; then
      tooltip+="[OPEN] NVIDIA\nDriver: nvidia-open"
    else
      tooltip+="Not found"
    fi

cat <<EOF
{ "text":"AMD", "tooltip":"$tooltip"}
EOF

  elif [[ "$gpu" =~ "Advanced Micro Devices" ]]; then

    # Check driver
    if [ "$(pacman -Qs "amdvlk")" ]; then
      tooltip+="[Proprietary] AMD\nDriver: amdvlk"
    elif [ "$(pacman -Qs "vulkan-radeon")" ]; then
        tooltip+="[Open] AMD\nDriver: RADV"
    else
        tooltip+="Not found"
    fi

cat <<EOF
{ "text":"AMD", "tooltip":"$tooltip"}
EOF

  else
    printf "Intel ARC?"
  fi
fi