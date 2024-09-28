# Install arch packages
echo Installing need packages...

# Install all packages
for name in .installer/packages/arch/*; do
  sudo pacman -S $(cat $name)
done