gpu="$(lspci  -v -s  "$(lspci | grep ' VGA ' | cut -d" " -f 1)")"
gpu_type="Not support, sorry i used AMD"
gpu_name=""


#Getting name vendor
if [[ "$gpu" == "*NVIDIA Corporation*" ]]; then
  gpu_name="NVIDIA"
elif [[ "$gpu" =~ "Advanced Micro Devices" ]]; then
  gpu_name="AMD"
  gpu_type="$(lspci | grep ' VGA ' | cut -d" " -f 10-30)"
elif [[ "$gpu" =~ "Intel Arc" ]]; then
  gpu_name="Intel Arc"
else
  gpu_name="???"
fi

#Get info
cat <<EOF
{ "text":"$gpu_name", "tooltip":"$gpu_type" }
EOF