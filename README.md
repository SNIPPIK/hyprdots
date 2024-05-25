# Hyprland configs
Packages for use
  - rofi
  - waybar
  - swaybg
  - hypridle
  - swaync
  - polkit-gnome

## NVIDIA (nvidia-beta-dkms)
Run servises nvidia-suspend.service, nvidia-hibernate.service, and nvidia-resume.service
```
sudo systemctl enable service
```

Write in `/etc/modprobe.d/nvidia.conf`
```
options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02 NVreg_EnableGpuFireware=0
options nvidia_drm modeset=1 fbdev=1
```

https://github.com/SNIPPIK/hypr/assets/55327334/1f3268a7-37ca-4b22-b58c-a18f27b9fd61
