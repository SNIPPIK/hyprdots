echo Install sddm theme neon
sudo 7z x "${HOME}"/hyprdots/Files/Theme/neon.zip -o/usr/share/sddm/themes/

echo
echo Install needed packages
sleep 5
sudo pacman -S qt6-5compact qt6-declarative qt6-svg

echo
echo Needed added sddm and create config
su
sudo mkdir /etc/sddm.conf.d/
echo "[Theme]
Current=neon" > "/etc/sddm.conf.d/theme.conf.user"