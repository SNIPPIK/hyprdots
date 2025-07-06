PS3='Please enter your choice: '
options=("hyprland" "niri")
select opt in "${options[@]}"
do
    case $opt in
        "hyprland")
            echo "Installing hyprland DE!"

            # Install all packages
            for name in .installer/packages/de/hyprland/*; do
              sudo pacman -S $(cat $name)
            done

            break
            ;;
        "niri")
            echo "Installing niri DE!"

            # Install all packages
            for name in .installer/packages/de/niri/*; do
              sudo pacman -S $(cat $name)
            done

            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done