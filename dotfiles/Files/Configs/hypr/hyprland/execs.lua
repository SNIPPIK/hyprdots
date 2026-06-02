-- put former exec-once commands inside the func and former exec commands outside
hl.on("hyprland.start", function ()
    -- Bar, wallpaper
    hl.exec_cmd("waybar")
    hl.exec_cmd(wall_engine)

    -- Core components (authentication, lock screen, notification daemon)
    hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- Some fix idk

    -- Clipboard: history
    hl.exec_cmd("wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
    hl.exec_cmd("wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")

    -- Cursor
    hl.exec_cmd("hyprctl setcursor FutureCyan 20")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'FutureCyan'")
    hl.exec_cmd("flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user")

    -- GTK
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)
