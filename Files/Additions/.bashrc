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

# -----------------------------------------------------
# HYPRDOTS
# -----------------------------------------------------
alias cd-hyprdots="cd ~/hyprdots"
alias cd-hyprland="cd ~/.config/hypr"

alias hyprland="nano ~/.config/hypr/hyprland.conf"
alias hyprland-env="nano ~/.config/hypr/configuring/environment.conf"
alias hyprland-start="nano ~/.config/hypr/configuring/autostart.conf"

alias hyprland-binds="nano ~/.config/hypr/configuring/keyboard/binds.conf"
alias hyprland-board="nano ~/.config/hypr/configuring/keyboard/keyboard.conf"

# -----------------------------------------------------
# Waybar
# -----------------------------------------------------
alias cd-waybar="cd ~/.config/waybar"
alias wb="nano ~/.config/waybar/config.jsonc"

alias player="nano ~/.config/hypr/scripts/toolbox/player.sh"

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias mkinitcpio='sudo nano /etc/mkinitcpio.conf && mkinitcpio'
alias grub='sudo nano /boot/grub/grub.cfg && sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias shutdown='systemctl poweroff'
alias wifi='nmtui'

alias update="sudo pacman -Syu"
alias unused="sudo pacman -Qdtq | sudo pacman -Rsc -"

# -----------------------------------------------------
# DEVELOPMENT
# -----------------------------------------------------
alias dotsync="bash ~/.cache/sync.sh"
alias hyprland-git="bash ~/hyprdots/.installer/hyprland.sh git"
alias hyprland-stable="bash ~/hyprdots/.installer/hyprland.sh stable"

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
eval "$(starship init bash)"

# -----------------------------------------------------
# RUN FASTFETCH
# -----------------------------------------------------
fastfetch