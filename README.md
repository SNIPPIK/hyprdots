[<img align="right" alt="Avatar" width="px" src="/.config/waybar/icons/artics.png" />]()

# hyprdots
- [`WIKI`](https://wiki.hyprland.org/)
- [`Wallpaper pack`](https://drive.google.com/file/d/12c7wgWHIAVtFP9TloSiHun5OWWA5OVtm/view?usp=sharing)

## Installation
The installation script is designed for a minimal [Arch Linux](https://wiki.archlinux.org/title/Arch_Linux) install, but **may** work on some [Arch-based distros](https://wiki.archlinux.org/title/Arch-based_distributions).
While installing alongside another [DE](https://wiki.archlinux.org/title/Desktop_environment)/[WM](https://wiki.archlinux.org/title/Window_manager) should work, due to it being a heavily customized setup, it **will** conflict with your [GTK](https://wiki.archlinux.org/title/GTK)/[Qt](https://wiki.archlinux.org/title/Qt) theming, [Shell](https://wiki.archlinux.org/title/Command-line_shell), [SDDM](https://wiki.archlinux.org/title/SDDM), [GRUB](https://wiki.archlinux.org/title/GRUB), etc. and is at your own risk.

> [!IMPORTANT]
> The install script will no auto-detect an NVIDIA card and install nvidia-dkms drivers for your kernel.
> Please ensure that your NVIDIA card supports dkms drivers in the list provided [here](https://wiki.archlinux.org/title/NVIDIA).

> [!CAUTION]
> See all button bindings in terminal `hyprland-binds`\
> All files are linked, deleting the directory can lead to serious consequences 

> [!TIP]
> There are options for some configs\
> Change a hyprland animation -> in terminal `hyprland`\
> Change a waybar workspace icons -> in terminal `wb`\
> View a current playing track in waybar, need to enable -> in terminal `player`\
> If not icons in terminal install "ttf-inconsolata-nerd" package
>
To install, execute the following commands:

```shell
sudo pacman -S git
git clone https://github.com/SNIPPIK/hyprdots.git
cd hyprdots
bash ./install.sh
```

To update, execute the following command:
```shell
dotsync
```

### Demo
<details close>
  <summary>Click to open</summary>

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
