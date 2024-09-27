PS3='Please enter your choice: '
options=("swww" "hyprpaper")
select opt in "${options[@]}"
do
    case $opt in
        "swww")
            echo "Installing swww engine!"
            sudo pacman -S swww
            break
            ;;
        "hyprpaper")
            echo "Installing hyprpaper engine!"
            sudo pacman -S hyprpaper
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done