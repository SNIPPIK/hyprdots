PS3='Please enter your choice: '
options=("niri")
select opt in "${options[@]}"
do
    case $opt in
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