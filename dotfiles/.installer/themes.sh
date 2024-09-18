echo Install sddm theme neon
sudo 7z x "${HOME}"/hyprdots/dotfiles/Files/Theme/neon.zip -o/usr/share/sddm/themes/

echo
echo Installing needed packages
sudo pacman -S qt6-5compact qt6-declarative qt6-svg

sleep 0.2s

echo
echo Install cursor theme
# Remove old directory
if [ -d ~/.icons/FutureCyan ]; then
  rm -rd ~/.icons/FutureCyan
fi

# Unpack cursor theme
7z x "${HOME}"/hyprdots/dotfiles/Files/Theme/FutureCyan.zip -o"${HOME}"/.icons/

sleep 0.2s

echo
echo Needed added to sddm and create config
sudo mkdir /etc/sddm.conf.d/
sudo echo "[Theme]
Current=neon" > "/etc/sddm.conf.d/theme.conf.user"

sleep 0.2s

#Unpack theme
echo Install 7zip
sudo pacman -S p7zip
echo Unpack Fluent
7z x "${HOME}"/hyprdots/dotfiles/Files/Theme/Fluent.zip -o"${HOME}"/.themes