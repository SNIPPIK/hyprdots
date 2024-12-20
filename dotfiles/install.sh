sddm_path="$HOME/hyprdots/dotfiles/Files/Theme/neon.zip"

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
echo
echo " ___      _   ___ _ _        "
echo "|   \ ___| |_| __(_) |___ ___"
echo "| |) / _ \  _| _|| | / -_|_-<"
echo "|___/\___/\__|_| |_|_\___/__/"

# Check root user
if [ "$USER" = "root" ]; then
    echo "Do not use root in this script, login in with another account"
    exit 0
fi

echo "Wait to start installing dotfiles"

# If not directory Configs
if [ ! -d $HOME/.config ]; then
  mkdir $HOME/.config
fi

# Need to update hyprdots
if [ ! -d $HOME/.cache ]; then
  mkdir $HOME/.cache/
fi

# Need to update hyprdots
if [ -f $HOME/.cache/sync.sh ]; then
  rm -rd $HOME/.cache/sync.sh
fi
cp $HOME/hyprdots/dotfiles/sync.sh $HOME/.cache/sync.sh

sleep 2
# -----------------------------------------------------
echo
echo "  ___           _        _ _  "
echo " |_ _|_ __  ___| |_ __ _| | | "
echo "  | || '_ \/ __| __/ _ '| | | "
echo "  | || | | \__ \ || (_| | | | "
echo " |___|_| |_|___/\__\__,_|_|_| "
echo Installing packages
choice
# Install packages
bash $HOME/hyprdots/dotfiles/.installer/packages.sh
# -----------------------------------------------------
echo
echo " __        __    _ _                                  "
echo " \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __ ___  "
echo "  \ \ /\ / / _' | | | '_ \ / _' | '_ \ / _ \ '__/ __| "
echo "   \ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \__ \ "
echo "    \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|  |___/ "
echo "                    |_|         |_|                   "
echo Your need choice wallpaper engine
bash $HOME/hyprdots/dotfiles/.installer/wallpaper.sh
# -----------------------------------------------------
echo
echo "   ____ ____  _   _  "
echo "  / ___|  _ \| | | | "
echo " | |  _| |_) | | | | "
echo " | |_| |  __/| |_| | "
echo "  \____|_|    \___/  "

echo Install GPU Drivers
bash $HOME/hyprdots/dotfiles/.installer/drivers.sh
# -----------------------------------------------------
echo
echo "   ____             __ _            "
echo "  / ___|___  _ __  / _(_) __ _ ___  "
echo " | |   / _ \| '_ \| |_| |/ _ '/ __| "
echo " | |__| (_) | | | |  _| | (_| \__ \ "
echo "  \____\___/|_| |_|_| |_|\__, |___/ "
echo "                        |___/       "
echo WARNING backup your .config directory
choice

# Link hyprdots
if [ ! -d $HOME/hyprdots ]; then
    ln -s "${PWD}" $HOME/
fi

bash $HOME/hyprdots/dotfiles/.installer/configs.sh
# -----------------------------------------------------
echo
echo "  _____ _                               "
echo " |_   _| |__   ___ _ __ ___   ___  ___  "
echo "   | | | '_ \ / _ \ '_  '_ \ / _ \/ __|  "
echo "   | | | | | |  __/ | | | | |  __/\__ \ "
echo "   |_| |_| |_|\___|_| |_| |_|\___||___/ "
echo Unpack themes
choice
bash $HOME/hyprdots/dotfiles/.installer/themes.sh

# Run sudo commands
echo Install sddm theme neon
sudo 7z x $sddm_path -o/usr/share/sddm/themes/
echo

# Create directory
if [ ! -d  /etc/sddm.conf.d/ ]; then
  sudo mkdir /etc/sddm.conf.d/
fi

# Check theme
if [ ! -f /etc/sddm.conf.d/theme.conf.user ]; then
  sudo echo "[Theme]
  Current=neon" > "/etc/sddm.conf.d/theme.conf.user"
else
  echo "You are using a different theme in SDDM"
  echo "To change the theme, edit the file -> /etc/sddm.conf.d/theme.conf.user"
  echo "[Theme]"
  echo "Current=neon"
fi
# -----------------------------------------------------
echo
echo "  ____            _                      _   _  "
echo " / ___| _   _ ___| |_ ___ _ __ ___   ___| |_| | "
echo " \___ \| | | / __| __/ _ \ '_ ' _ \ / __| __| | "
echo "  ___) | |_| \__ \ ||  __/ | | | | | (__| |_| | "
echo " |____/ \__, |___/\__\___|_| |_| |_|\___|\__|_| "
echo "        |___/                                   "
# Run systemctl services
echo Run systemctl services

# Enable services
for name in "sddm" "bluetooth" "power-profiles-daemon"
do
  sudo systemctl enable "$name"
  sudo systemctl start "$name"
done
# -----------------------------------------------------
echo "Installing the ended!"