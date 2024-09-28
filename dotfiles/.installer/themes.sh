echo
echo Install cursor theme
# Remove old directory
if [ -d $HOME/.icons/FutureCyan ]; then
  rm -rd $HOME/.icons/FutureCyan
fi

# Unpack cursor theme
7z x "${HOME}"/hyprdots/dotfiles/Files/Theme/FutureCyan.zip -o"${HOME}"/.icons/

sleep 0.2s

#Unpack theme
echo Unpack Fluent
7z x "${HOME}"/hyprdots/dotfiles/Files/Theme/Fluent.zip -o"${HOME}"/.themes