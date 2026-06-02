-- Default variables
-- Copy these to ~/.config/hypr/custom/variables.lua to make changes in a dotfiles-update-friendly manner

-- Apps
-- PULL REQUESTS ADDING MORE WILL NOT BE ACCEPTED, CONFIG FOR YOURSELF
codeEditor = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'windsurf' 'antigravity' 'code' 'codium' 'cursor' 'zed' 'zedit' 'zeditor' 'kate' 'gnome-text-editor' 'emacs' 'command -v nvim && kitty -1 nvim' 'command -v micro && kitty -1 micro'"
textEditor = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'kate' 'gnome-text-editor' 'emacs'"
volumeMixer = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'pavucontrol-qt' 'pavucontrol'"
taskManager = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'gnome-system-monitor' 'plasma-systemmonitor --page-name Processes' 'command -v btop && kitty -1 fish -c btop'"

-- Terminals
terminal = "foot | kitty | alacritty --class hyprdots-float"

-- File managers
fileManager = "dolphin | nautilus | nemo | thunar | kitty | fish"

-- Browsers
browser = "google-chrome-stable | zen-browser | firefox | brave | chromium | microsoft-edge-stable | opera | librewolf"

-- Wallpapers
wall_random = "bash ./config/hypr/bin/ecosys/wallpaper.sh 'random'"
wall_select = "bash ./config/hypr/bin/ecosys/wallpaper.sh 'select'"
wall_engine = "bash ./config/hypr/bin/ecosys/wallpaper.sh 'engine'"

-- Rofi
AppLauncher_small = "bash ~/.config/rofi/run.sh 'compact'"
AppLauncher_small = "bash ~/.config/rofi/run.sh 'compact'"

-- Restart Scripts
panel_toggle = "bash ~/.config/hypr/bin/hyprland/restart.sh 'panel-toggle'"
panel_restart = "bash ~/.config/hypr/bin/hyprland/restart.sh 'panel-restart"

workspaceGroupSize = 10
