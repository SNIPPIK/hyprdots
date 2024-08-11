echo Install sddm theme neon
7z x "${HOME}"/hyprdots/Files/Theme/Vimix.zip -o/"${HOME}"/.cache
echo
echo Installing grub theme
sleep 5

"${HOME}"/.cache/Vimix/install.sh
