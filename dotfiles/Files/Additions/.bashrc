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
alias session-logout='hyprctl dispatch exit'
alias session-lock='loginctl lock-session && playerctl --all-players pause'

# Drivers
alias amd-open='sudo pacman -Syu vulkan-radeon lib32-vulkan-radeon && sudo pacman -Rcs amdvlk lib32-amdvlk'
alias amd-close='sudo pacman -Syu amdvlk lib32-amdvlk && sudo pacman -Rcs vulkan-radeon lib32-vulkan-radeon'
alias nvidia-open='sudo pacman -Syu nvidia-open && sudo pacman -Rc nvidia'
alias nvidia-close='sudo pacman -Syu nvidia && sudo pacman -Rc nvidia-open'

# Packet manager
alias pacman='sudo pacman'
alias aur='yay || echo "Need install yay package"'

# -----------------------------------------------------
# DEVELOPMENT
# -----------------------------------------------------
alias dotsync="bash ~/.cache/sync.sh"

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
eval "$(starship init bash)"

# -----------------------------------------------------
# RUN FASTFETCH
# -----------------------------------------------------
ff