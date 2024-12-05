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
# HYPRDOTS
# -----------------------------------------------------
alias chyprdots="cd ~/hyprdots"
alias chyprland="cd ~/.config/hypr"

alias hyprland="nano ~/.config/hypr/hyprland.conf"
alias hyprland-env="nano ~/.config/hypr/configuring/environment.conf"
alias hyprland-start="nano ~/.config/hypr/configuring/autostart.conf"

alias hyprland-binds="nano ~/.config/hypr/configuring/keyboard/binds.conf"
alias hyprland-board="nano ~/.config/hypr/configuring/keyboard/keyboard.conf"

# -----------------------------------------------------
# Waybar
# -----------------------------------------------------
alias cwb="cd ~/.config/waybar"
alias wb="nano ~/.config/waybar/config.jsonc"

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias mkinitcpio='sudo nano /etc/mkinitcpio.conf && mkinitcpio'
alias grub='sudo nano /boot/grub/grub.cfg && sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias shutdown='systemctl poweroff'
alias wifi='nmtui'

alias amd-open='sudo pacman -Syu vulkan-radeon lib32-vulkan-radeon && sudo pacman -Rcs amdvlk lib32-amdvlk'
alias amd-close='sudo pacman -Syu amdvlk lib32-amdvlk && sudo pacman -Rcs vulkan-radeon lib32-vulkan-radeon'

alias nvidia-open='sudo pacman -Syu nvidia-open && sudo pacman -Rc nvidia'
alias nvidia-close='sudo pacman -Syu nvidia && sudo pacman -Rc nvidia-open'

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
fastfetch