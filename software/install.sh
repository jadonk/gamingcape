#echo "Compiling dts"
#dtc -O dtb -o BEAGLEBOY-0013.dtbo -b 0 -@ BEAGLEBOY-0013.dts
#echo "Installing dts"
#cp BEAGLEBOY-0013.dtbo /lib/firmware/
#echo "Rebuilding initrd with dts"
#install -m 755 dtbo /usr/share/initramfs-tools/hooks/
#/opt/scripts/tools/developers/update_initrd.sh

echo "Downloading and installing latest kernel and device tree"
wget http://builds.beagleboard.org/linux/3.8.13-bone71-lsm303/81e3a418466a53b3c9649cafc5b555e361a9846d/linux-image-3.8.13-git81e3a418466a53b3c9649cafc5b555e361a9846d_1cross_armhf.deb
wget http://builds.beagleboard.org/linux/3.8.13-bone71-lsm303/81e3a418466a53b3c9649cafc5b555e361a9846d/linux-firmware-image-3.8.13-git81e3a418466a53b3c9649cafc5b555e361a9846d_1cross_armhf.deb
dpkg -i linux-image-3.8.13-git81e3a418466a53b3c9649cafc5b555e361a9846d_1cross_armhf.deb
dpkg -i linux-firmware-image-3.8.13-git81e3a418466a53b3c9649cafc5b555e361a9846d_1cross_armhf.deb

echo "Installing uinput service"
gcc -o /usr/local/bin/adcjs adcjs.c

echo "Installing X11 input driver configuration"
apt-get install xserver-xorg-input-joystick
install -m 644 99-gamingcape.conf /etc/X11/xorg.conf.d/

echo "Installing systemd service"
cp gamingcape.service /etc/systemd/system/
echo "Enabling systemd service"
systemctl enable gamingcape.service
#echo "Disabling some services"
#systemctl disable mpd
#systemctl disable gdm
echo "Enabling autologin"
cp getty@tty1.service /etc/systemd/system/getty.target.wants/
#echo "Disabling git sslVerify"
#git config --global http.sslVerify false
echo "Installing scripts"
mkdir -p /usr/share/gamingcape
install -m 755 init_gamingcape.sh /usr/share/gamingcape/

echo "Symlinking AIN0, AIN2, BUTTON_A and BUTTON_B"
#config-pin overlay BEAGLEBOY
config-pin overlay BB-ADC
mkdir -p /usr/share/gamingcape
cd /usr/share/gamingcape
rm -f AIN0
rm -f AIN2
#rm -f BUTTON_A
#rm -f BUTTON_B
ln -s /sys/bus/iio/devices/iio\:device0/in_voltage0_raw AIN0
ln -s /sys/bus/iio/devices/iio\:device0/in_voltage2_raw AIN2
#ln -s /sys/class/gpio/gpio49/value BUTTON_A
#ln -s /sys/class/gpio/gpio61/value BUTTON_B


#echo "Updating opkg"
#opkg update
#echo "Installing python-distutils"
#opkg install python-distutils
#echo "Installing python-compile"
#opkg install python-compile

# wget http://prdownloads.sourceforge.net/scons/scons-2.3.0.tar.gz
# tar xvf scons-2.3.0.tar.gz
# cd scons-2.3.0
# python setup.py install

echo "Installing scons"
apt-get update
apt-get install -y scons

echo "Cloning/updating fceu"
cd
if [ -d gamingcape_fceu ]; then
  cd gamingcape_fceu
  git pull
else
  git clone "https://github.com/jadonk/gamingcape_fceu.git"
  cd gamingcape_fceu
fi

echo "Building fceu"
scons
echo "Installing fceu"
./install.sh
