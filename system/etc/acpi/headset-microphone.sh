#!/bin/sh
export PULSE_RUNTIME_PATH="/run/user/1000/pulse/"
if [ "$1" = plug ]; then
  sudo -u [USERNAME] -E pacmd set-source-port alsa_input.pci-0000_00_1f.3.analog-stereo analog-input-headset-mic
else
  sudo -u [USERNAME] -E pacmd set-source-port alsa_input.pci-0000_00_1f.3.analog-stereo analog-input-internal-mic 
fi
