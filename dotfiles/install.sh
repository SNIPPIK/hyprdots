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
echo " ___      _   ___ _ _        "
echo "|   \ ___| |_| __(_) |___ ___"
echo "| |) / _ \  _| _|| | / -_|_-<"
echo "|___/\___/\__|_| |_|_\___/__/"

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
if [ ! -d ~/.cache ]; then
  mkdir ~/.cache/
fi

# Need to update hyprdots
if [ -f ~/.cache/sync.sh ]; then
  rm -rd ~/.cache/sync.sh
fi
cp ~/hyprdots/dotfiles/sync.sh ~/.cache/sync.sh
# -----------------------------------------------------
echo "   ____             __ _            "
echo "  / ___|___  _ __  / _(_) __ _ ___  "
echo " | |   / _ \| '_ \| |_| |/ _ '/ __| "
echo " | |__| (_) | | | |  _| | (_| \__ \ "
echo "  \____\___/|_| |_|_| |_|\__, |___/ "
echo "                        |___/       "
echo WARNING backup your .config directory
choice

# Link hyprdots
if [ ! -d ~/hyprdots ]; then
    ln -s "${PWD}" ~/
fi

bash ~/hyprdots/dotfiles/.installer/configs.sh
# -----------------------------------------------------
echo "  ___           _        _ _  "
echo " |_ _|_ __  ___| |_ __ _| | | "
echo "  | || '_ \/ __| __/ _ '| | | "
echo "  | || | | \__ \ || (_| | | | "
echo " |___|_| |_|___/\__\__,_|_|_| "
echo Installing packages
choice
# Install packages
bash ~/hyprdots/dotfiles/.installer/packages.sh
# -----------------------------------------------------
echo "  _____ _                               "
echo " |_   _| |__   ___ _ __ ___   ___  ___  "
echo "   | | | '_ \ / _ \ '_  '_ \ / _ \/ __|  "
echo "   | | | | | |  __/ | | | | |  __/\__ \ "
echo "   |_| |_| |_|\___|_| |_| |_|\___||___/ "

echo Unpack themes
choice
sudo bash ~/hyprdots/dotfiles/.installer/themes.sh
# -----------------------------------------------------
echo "   ____ ____  _   _  "
echo "  / ___|  _ \| | | | "
echo " | |  _| |_) | | | | "
echo " | |_| |  __/| |_| | "
echo "  \____|_|    \___/  "

echo Install GPU Drivers
bash ~/hyprdots/dotfiles/.installer/drivers.sh
# -----------------------------------------------------
echo "Installing the ended!"