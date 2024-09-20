[<img align="right" alt="Avatar" width="150px" src="assets/hyprland.svg" />]()

# DotFiles
- [`Hyprland WIKI`](https://wiki.hyprland.org/)
- [`My wallpaper pack`](https://github.com/SNIPPIK/wallpapers)
- [`decaycs/wallpapers`](https://github.com/decaycs/wallpapers)

## Installation
The installation script is designed for a minimal [Arch Linux](https://wiki.archlinux.org/title/Arch_Linux) install, but **may** work on some [Arch-based distros](https://wiki.archlinux.org/title/Arch-based_distributions).
While installing alongside another [DE](https://wiki.archlinux.org/title/Desktop_environment)/[WM](https://wiki.archlinux.org/title/Window_manager) should work, due to it being a heavily customized setup, it **will** conflict with your [GTK](https://wiki.archlinux.org/title/GTK)/[Qt](https://wiki.archlinux.org/title/Qt) theming, [Shell](https://wiki.archlinux.org/title/Command-line_shell), [SDDM](https://wiki.archlinux.org/title/SDDM), [GRUB](https://wiki.archlinux.org/title/GRUB), etc. and is at your own risk.

> [!CAUTION]
> See all button bindings in terminal `hyprland-binds`\
> All files are linked, deleting the directory hyprdots can lead to serious consequences\
> The install script will auto install GPU drivers for AMD, NVIDIA, Intel is not supported in script\
> The script will install dark theme gtk, sddm, grub. If you have a bootloader other grub installed, then it is better not to use hyprdots


> [!IMPORTANT]
> The install script will auto-detect an NVIDIA card and install nvidia-dkms drivers for your kernel.
> Please ensure that your NVIDIA card supports dkms drivers in the list provided [here](https://wiki.archlinux.org/title/NVIDIA).

> [!TIP]
> This config tested on notebook and desktop\
> Auto configuration of monitors, left to right\
> Hyprland animations can be changed in hyprland.conf

To install, execute the following commands:
```shell
sudo pacman -S git
git clone https://github.com/SNIPPIK/hyprdots.git
cd hyprdots/dotfiles
bash ./install.sh
```

To update, execute the following command:
```shell
dotsync
```

## Dependencies
Used for nice work dotfiles
- `hyprland`, `hyprpaper`, `hypridle`, `hyprlock`, `waybar`, `rofi-wayland`, `hyprcursor`
- `polkit-gnome`, `dunst`, `grim`, `sddm`, `starship`, `gnome-keyring`, `wl-clipboard`
- `otf-font-awesome`, `noto-fonts-emoji`, `ttf-nerd-fonts-symbols-mono`, `ttf-dejavu`
- `pipewire-pulse`, `wireplumber`, `bluez`, `blueberry`, `pavucontrol`, `flatpak`
- `gnome-software`, `nautilus`

## Images
- Version 0.6.3
<img align="" alt="image" width="1920" src="/assets/images/1.png" />
<img align="" alt="image" width="1920" src="/assets/images/2.png" />
<img align="" alt="image" width="1920" src="/assets/images/3.png" />
<img align="" alt="image" width="1920" src="/assets/images/4.png" />
<img align="" alt="image" width="1920" src="/assets/images/5.png" />
<img align="" alt="image" width="1920" src="/assets/images/6.png" />
<img align="" alt="image" width="1920" src="/assets/images/7.png" />
<img align="" alt="image" width="1920" src="/assets/images/8.png" />


### Demonstration videos (archive)
<details close>
  <summary>Click to open</summary>

# Old videos are stored here, new demos are in releases

### v0.5.0 
https://github.com/user-attachments/assets/f972c4fb-51c6-47e2-bd4a-0405a0e2ad43

### v0.4.2
https://github.com/user-attachments/assets/5ed135e8-7f4b-4bb9-8d18-47155d76ef8a

### v0.4.1
https://github.com/SNIPPIK/hyprdots/assets/55327334/6c2cb8af-4925-4a5f-8c30-fa2e0ff5645b

### v0.4.0
https://github.com/SNIPPIK/hyprdots/assets/55327334/b422217b-093d-4c3b-a794-107f338bf57f

### v0.3.7
https://github.com/SNIPPIK/hyprdots/assets/55327334/d5334aea-10f4-4cae-ba45-64601710b47e

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
