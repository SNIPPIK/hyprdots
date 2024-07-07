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
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias od='~/hyprdots/onedrive.sh'

# -----------------------------------------------------
# HYPRDOTS
# -----------------------------------------------------
alias cd-hypr="cd ~/.config/hypr"
alias hypr="nano ~/.config/hypr/hyprland.conf"
alias hypr-env="nano ~/.config/hypr/configuring/environment.conf"
alias hypr-start="nano ~/.config/hypr/configuring/autostart.conf"

alias hypr-binds="nano ~/.config/hypr/configuring/keyboard/binds.conf"
alias hypr-board="nano ~/.config/hypr/configuring/keyboard/keyboard.conf"

# -----------------------------------------------------
# Waybar
# -----------------------------------------------------
alias cd-waybar="cd ~/.config/waybar"
alias wb="nano ~/.config/waybar/config.jsonc"

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias mkinitcpio='sudo nano /etc/mkinitcpio.conf && mkinitcpio'
alias grub='sudo nano /boot/grub/grub.cfg && sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias shutdown='systemctl poweroff'
alias wifi='nmtui'

# -----------------------------------------------------
# DEVELOPMENT
# -----------------------------------------------------
alias dotsync="~/hyprdots/sync.sh"

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
eval "$(starship init bash)"

# -----------------------------------------------------
# RUN FASTFETCH
# -----------------------------------------------------
fastfetch