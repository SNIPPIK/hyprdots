# The user's response is required
function choice() {
  # shellcheck disable=SC3045
  # shellcheck disable=SC2162
  read -p "Continue (y/n)? " choice
  case "$choice" in
    y|Y|н|Н ) echo "Continue...";;
    n|N|т|Т ) exit 0;;
    * ) echo "Continue...";;
  esac
}
# -----------------------------------------------------
# Check root user
if [ "$USER" = "root" ]; then
    echo "Do not use root in this script, login in with another account"
    exit 0
fi

# If not directory Configs
if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

# Need to update hyprdots
if [ -f ~/.cache/sync.sh ]; then
  rm -rd ~/.cache/sync.sh
fi
cp ~/hyprdots/dotfiles/sync.sh ~/.cache
# -----------------------------------------------------
echo WARNING backup your .config directory
choice

# Link hyprdots
if [ ! -d ~/hyprdots ]; then
    ln -s "${PWD}" ~/
fi

bash ~/hyprdots/dotfiles/.installer/configs.sh
# -----------------------------------------------------
echo Installing packages
choice
# Install packages
bash ~/hyprdots/dotfiles/.installer/packages.sh
# Install packages
sudo bash ~/hyprdots/dotfiles/.installer/aur.sh
# -----------------------------------------------------
echo Unpack themes
choice
sudo bash ~/hyprdots/dotfiles/.installer/themes.sh
# -----------------------------------------------------
echo Install GPU Drivers
bash ~/hyprdots/dotfiles/.installer/drivers.sh
# -----------------------------------------------------
echo "Installing the ended!"