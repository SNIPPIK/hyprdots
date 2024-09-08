#  ____  _            _              _   _
# | __ )| |_   _  ___| |_ ___   ___ | |_| |__
# |  _ \| | | | |/ _ \ __/ _ \ / _ \| __| '_ \
# | |_) | | |_| |  __/ || (_) | (_) | |_| | | |
# |____/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|
# Automatically connect saved devices

# List of connected devices
devices=$(bluetoothctl devices | awk '{ print $2 }')

# If not connected devices
if [ ! "$devices" ]; then
    exit 0
fi

# Scan the list of connected devices
for device in $devices
do
  # Connect to device
  bluetoothctl connect "$device"
done