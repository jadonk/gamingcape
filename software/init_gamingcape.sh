#!/bin/sh
export DISPLAY=:0.0
sudo -u debian xset s off
sudo -u debian xset s noblank
#config-pin overlay BEAGLEBOY
#sleep 2
killall adcjs
killall -9 adcjs
adcjs /sys/bus/iio/devices/iio:device0/in_voltage0_raw /sys/bus/iio/devices/iio:device0/in_voltage2_raw &
#echo 61 > /sys/class/gpio/export
#echo 49 > /sys/class/gpio/export
#echo in > /sys/class/gpio/gpio49/direction
#echo in > /sys/class/gpio/gpio61/direction
amixer set PCM 100%
amixer set HP unmute
amixer set 'HP DAC' 100%
amixer set 'Left HP Mixer DACL1' unmute
amixer set 'Left PGA Mixer Line1L' unmute
amixer set 'Right HP Mixer DACR1' unmute
amixer set 'Right PGA Mixer Line1R' unmute
amixer set 'AGC' mute
amixer set 'Left HP Mixer DACR1' mute
amixer set 'Left PGA Mixer Line1R' mute
amixer set 'Right HP Mixer DACL1' mute
amixer set 'Right PGA Mixer Line1L' mute
amixer set 'PGA' 0%
sudo -u debian fceux --sound 1  --fullscreen 1 --xres 320 --yres 240 /usr/share/gamingcape/ROMS/ROM.nes
