#!/bin/bash
HOME=~/

# Define options
options=(
    " Power menu"
    " Update System"
    "󰏖 Delete unused packages"
    " [Select] Wallpaper"
    " [Random] Wallpaper"
    " [Restart] Wallpaper"
    " [Mode] Select monitor size"
)

# Define corresponding commands
commands=(
    "$HOME/.config/hypr/bin/powermenu.sh"
    "$HOME/.config/waybar/scripts/dialog.sh float update"
    "$HOME/.config/waybar/scripts/dialog.sh float unused"
    "$HOME/.config/hypr/bin/ecosys/wallpaper.sh select"
    "$HOME/.config/hypr/bin/ecosys/wallpaper.sh random"
    "$HOME/.config/hypr/bin/ecosys/wallpaper.sh engine",
    "$HOME/.config/niri/sh/output.sh"
)

# Show Rofi menu
selection=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Scripts" -columns 2 -theme windows/simple.rasi)

# Execute the corresponding command
for i in "${!options[@]}"; do
    if [[ "${options[i]}" == "$selection" ]]; then
        bash ${commands[i]}
        exit 0
    fi
done