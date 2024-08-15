echo Install sddm theme neon
sudo 7z x "${HOME}"/hyprdots/Files/Theme/neon.zip -o/usr/share/sddm/themes/

echo
echo Installing needed packages
sleep 5
sudo pacman -S qt6-5compact qt6-declarative qt6-svg

echo
echo Needed added sddm and create config
sudo mkdir /etc/sddm.conf.d/
sudo echo "[Theme]
Current=neon" > "/etc/sddm.conf.d/theme.conf.user"