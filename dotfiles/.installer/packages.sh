# Install arch packages
echo Installing need packages...
sudo pacman -S hyprland hyprpaper hypridle hyprlock waybar otf-font-awesome noto-fonts-emoji rofi-wayland nm-connection-editor pipewire-pulse wireplumber bluez blueberry pavucontrol nemo nemo-fileroller nemo-preview polkit-gnome swaync grim slurp pacman-contrib sddm fastfetch starship gnome-keyring ttf-nerd-fonts-symbols-mono ttf-dejavu wl-clipboard

sleep 1

# Run systemctl services
echo Run sddm service and bluetooth service
sudo systemctl enable sddm && sudo systemctl enable bluetooth

sleep 1

echo Select aur repository installer
PS3='Please enter your choice: '
options=("yay" "paru" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "yay")
            if yay
            then
              echo Find yay
            else
              git clone https://aur.archlinux.org/yay.git
              cd yay
              makepkg -si
            fi
            break
            ;;
        "paru")
            if paru
            then
              echo Find paru
            else
              git clone https://aur.archlinux.org/paru.git
              cd paru
              makepkg -si
            fi
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done