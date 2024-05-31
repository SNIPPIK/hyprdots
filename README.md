# Hyprland configs
Packages for use
  - rofi
  - waybar
  - hypridle & hyprpaper
  - swaync
  - polkit-gnome

## NVIDIA (nvidia-beta or dkms)
Run servises nvidia-suspend.service, nvidia-hibernate.service, and nvidia-resume.service
```
sudo systemctl enable service
```

Write in `/etc/modprobe.d/nvidia.conf`
```
options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02 NVreg_EnableGpuFireware=0
options nvidia_drm modeset=1 fbdev=1
```

https://github.com/SNIPPIK/hypr/assets/55327334/8974acd6-3414-4e40-8881-17074f717693

