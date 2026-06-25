PS3='Please enter your choice: '
options=("swww")
select opt in "${options[@]}"
do
    case $opt in
        "swww")
            echo "Installing awww engine!"
            sudo pacman -S swww
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
