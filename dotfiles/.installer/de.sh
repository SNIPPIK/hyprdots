echo "Installing niri DE!"

# Install all packages
for name in .installer/packages/de/niri/*; do
    sudo pacman -S $(cat $name)
done