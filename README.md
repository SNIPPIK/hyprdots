[<img align="right" alt="Avatar" width="200px" src="/.config/waybar/icons/arch.png" />]()

# Dotfiles 
- [`WIKI`](https://wiki.hyprland.org/)
- [`Wallpaper pack`](https://drive.google.com/file/d/12c7wgWHIAVtFP9TloSiHun5OWWA5OVtm/view?usp=sharing)
- `Install`
    ```
        git clone https://github.com/SNIPPIK/hypr.git
        cd hypr
        bash ./install.sh
    ```

### Binds
- [All](.config/hypr/configuring/keyboard/binds.conf)
- Fullscreen | WIN + F12
- Gaming mode | WIN + G
- Restart hyprland | WIN + Right Control
- Screenshot tool | WIN + PRINT
- Restart waybar | WIN + F11

## Variants
- [`Hyprland animations`](.config/hypr/hyprland.conf) | PATH: ~/.config/hypr/hyprland.conf
- [`Waybar workspace`](.config/waybar/config.jsonc) | PATH: ~/.config/waybar/config.jsonc


## For [`NVIDIA` (nvidia-beta or dkms)](https://wiki.hyprland.org/Nvidia/)
1. DRM kernel mode setting
   ```
   Since NVIDIA does not load kernel mode setting by default, enabling it is required to make Wayland compositors function properly. To enable it, the NVIDIA driver modules need to be added to the initramfs.

   Edit /etc/mkinitcpio.conf. In the MODULES array, add the following module names:

   MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)

   Then, create and edit /etc/modprobe.d/nvidia.conf. Add this line to the file:

   options nvidia_drm modeset=1 fbdev=1

   Lastly, rebuild the initramfs with sudo mkinitcpio -P, and reboot.
   ```

2. Env for nvidia (support wayland)
   - [`nvidia env`](.config/hypr/configuring/environment.conf) | PATH: ~/.config/hypr/configuring/environment.conf
3. Run servises nvidia-suspend.service, nvidia-hibernate.service, and nvidia-resume.service
   ```
   sudo systemctl enable service
   ```
4. Write in `/etc/modprobe.d/nvidia.conf`
   ```
   options nvidia NVreg_UsePageAttributeTable=1 NVreg_InitializeSystemMemoryAllocations=0 NVreg_DynamicPowerManagement=0x02 NVreg_EnableGpuFireware=0
   options nvidia_drm modeset=1 fbdev=1
   ```
### Demo
<details close>
  <summary>Click to open</summary>

### v0.3.6
https://github.com/SNIPPIK/hypr/assets/55327334/4f87c371-f9e6-49a0-be76-43043f0bc09d

### v0.3.5
https://github.com/SNIPPIK/hypr/assets/55327334/ee8311fa-9d7b-44ff-8cad-7f1664d6b64b

### v0.3.1
https://github.com/SNIPPIK/hypr/assets/55327334/d90cdc7d-e17b-44e9-92fe-cbd23974aeef

### v0.3
https://github.com/SNIPPIK/hypr/assets/55327334/a507a715-4059-43d5-9527-70f0326013bc

### v0.2
https://github.com/SNIPPIK/hypr/assets/55327334/82e32e37-a3f0-43ed-8316-4a1910d2dd88

### v0.1
https://github.com/SNIPPIK/hypr/assets/55327334/8974acd6-3414-4e40-8881-17074f717693
</details>