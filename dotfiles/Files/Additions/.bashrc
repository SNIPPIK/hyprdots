#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias ff='fastfetch'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
# mkinitcpio
alias mkinitcpio='sudo nano /etc/mkinitcpio.conf && mkinitcpio'

# Grub
alias grub='sudo nano /boot/grub/grub.cfg && sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Power menu
alias shutdown='systemctl poweroff'
alias session-logout='killall -u $USER'
alias session-lock='loginctl lock-session && playerctl --all-players pause'

# Drivers
alias amd-open='sudo pacman -Syu vulkan-radeon lib32-vulkan-radeon && sudo pacman -Rcs amdvlk lib32-amdvlk'
alias amd-close='sudo pacman -Syu amdvlk lib32-amdvlk && sudo pacman -Rcs vulkan-radeon lib32-vulkan-radeon'
alias nvidia-open='sudo pacman -Syu nvidia-open && sudo pacman -Rc nvidia'
alias nvidia-close='sudo pacman -Syu nvidia && sudo pacman -Rc nvidia-open'

# Packet manager
alias pacman='sudo pacman'
alias apt='sudo pacman'
alias aur='yay'

# Setter avatars
alias avatar='sudo bash ~/.config/hypr/bin/tools/avatar.sh'

# -----------------------------------------------------
# DEVELOPMENT
# -----------------------------------------------------
alias dotsync="bash ~/.cache/sync.sh"

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
eval "$(starship init bash)"

# -----------------------------------------------------
# Proton exec
# -----------------------------------------------------
proton-run() {
    local prefix_path="$HOME/.wine"
    local steam_path="$HOME/.local/share/Steam"
    mkdir -p "$prefix_path"

    # Поиск самой свежей версии Proton в официальной папке и в compatibilitytools.d
    local proton_path=$(find "$steam_path/compatibilitytools.d" \
                             "$steam_path/steamapps/common" \
                             "$HOME/Protons" \
                             -maxdepth 3 -type f -name "proton" 2>/dev/null | sort -V | tail -n 1)

    # Проверка на наличие Proton
    if [ -z "$proton_path" ]; then
        echo "Ошибка: Proton не найден ни в common, ни в compatibilitytools.d, ~/Protons!"
        return 1
    fi

    echo "Используется Proton: $proton_path"
    echo "Префикс: $prefix_path"

    # Запуск с передачей обязательных переменных окружения для обхода проверок Steam
    STEAM_COMPAT_CLIENT_INSTALL_PATH="$steam_path" \
    STEAM_COMPAT_DATA_PATH="$prefix_path" \
    "$proton_path" run "$@"
}

# -----------------------------------------------------
# RUN FASTFETCH
# -----------------------------------------------------
ff