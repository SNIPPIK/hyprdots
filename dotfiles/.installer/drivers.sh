gpu="$(lspci  -v -s  "$(lspci | grep ' VGA ' | cut -d" " -f 1)")"

# For NVIDIA
if [[ "$gpu" == "*NVIDIA Corporation*" ]]; then
  echo Find NVIDIA GPU
  echo "For the Turing (NV160/TUXXX) series or newer, NVIDIA recommends the open source kernel driver. To use it, you can install the nvidia-open package (for use with the linux kernel) or the nvidia-open-dkms package (for all other kernels).
  If these packages do not work, usually due to new hardware releases, nvidia-open-beta|AUR may have a newer driver version that offers support."
  echo Installing NVIDIA drivers packages
  sudo pacman -S $(cat .installer/packages/gpu/nvidia)

  echo Enabling the services nvidia-suspend.service, nvidia-hibernate.service and nvidia-resume.service
  sudo systemctl enable "nvidia-suspend.service"
  sudo systemctl enable "nvidia-hibernate.service"
  sudo systemctl enable "nvidia-resume.service"

# For AMD
elif [[ "$gpu" =~ "Advanced Micro Devices" ]]; then
  echo Find AMD GPU
  echo Installing AMD drivers packages
  sudo pacman -S $(cat .installer/packages/gpu/amd)
fi

echo Ended installing GPU drivers