[<img align="right" alt="Avatar" width="200px" src="/.config/waybar/logo.png" />]()

# Hyprland configs
Packages be use
- General
    - hyprpaper & hypridle
    - waybar & otf-font-awesome & noto-fonts-emoji
    - rofi-wayland
    - nm-connection-editor
    - wlogout (AUR)
- Audio, bluetooth
    - wireplumber & pipewire-pulse
    - blueberry, bluez
    - pavucontrol
- File manager
  - nautilus 
- Polkit
    - polkit-gnome
- Notifications
    - swaync
- Screanshoot tool
    - grim & slurp
- [`Wallpaper pack`](https://drive.google.com/file/d/12c7wgWHIAVtFP9TloSiHun5OWWA5OVtm/view?usp=sharing)

## Binds
- [All](.config/hypr/configuring/keyboard/binds.conf)
- Fullscreen | WIN + F12
- Gaming mode | WIN + G
- Restart hyprland | WIN + Right Control
- Screenshot tool | WIN + PRINT
- Restart waybar | WIN + F11


## Variants
- [`Hyprland animations`](.config/hypr/hyprland.conf) | PATH: ~/.config/hypr/hyprland.conf
- [`Waybar workspace`](.config/waybar/config.jsonc) | PATH: ~/.config/waybar/config.jsonc


## For [NVIDIA (nvidia-beta or dkms)](https://wiki.hyprland.org/Nvidia/)
Run servises nvidia-suspend.service, nvidia-hibernate.service, and nvidia-resume.service
```
sudo systemctl enable service
```

Write in `/etc/modprobe.d/nvidia.conf`
```
options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02 NVreg_EnableGpuFireware=0
options nvidia_drm modeset=1 fbdev=1
```

### v0.3.6
https://github.com/SNIPPIK/hypr/assets/55327334/4f87c371-f9e6-49a0-be76-43043f0bc09d

### v3.5
https://github.com/SNIPPIK/hypr/assets/55327334/ee8311fa-9d7b-44ff-8cad-7f1664d6b64b

### v3.1
https://github.com/SNIPPIK/hypr/assets/55327334/d90cdc7d-e17b-44e9-92fe-cbd23974aeef

### v3
https://github.com/SNIPPIK/hypr/assets/55327334/a507a715-4059-43d5-9527-70f0326013bc

### v2
https://github.com/SNIPPIK/hypr/assets/55327334/82e32e37-a3f0-43ed-8316-4a1910d2dd88

### v1
https://github.com/SNIPPIK/hypr/assets/55327334/8974acd6-3414-4e40-8881-17074f717693

