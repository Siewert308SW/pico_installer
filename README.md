# PIco UPS HV3.0A Installer
Bash script that installs all necessities for PIco HV3.0A series

It's beta and i want to know if it works for you guys.

At the moment the script is only available for:
- Raspberry Pi 3 Model B Rev 1.2
- Rasbian Jessie 8.0 - with latest 4.9 kernel

This script installs all necessities for PIco HV3.0A UPS.
Easier then by hand and saves searching the manual.

Save the pico_installer to /home/pi/pico_installer.sh
And fire it up via ssh and follow all instructions.
The script will ask for a reboot after that you have to as mentioned in the installer restart the script to finish the installation.
The installer is several fail saves and system checks.
Also it contains 3 menu options.

1. Install PIco
2. Remove PIco
3. quit

# PIco UPS HV3.0A Precautions
There are some precautions to take before you continue the installer

Disclaimer:
I don't take any responsibility if your OS, Rpi or PIco board gets broken
You are using this script on your own responsibility!!!

Precautions:
1. Install your PIco board before continuing the installer
2. Raspberry Pi 3 Model B Rev 1.2
3. Use a clean Rasbian Jessie 8.0 installation
Or a installation which hasn't seen a previously installed PIco daemon
4. Latest 4.9 kernel (handled by the script)
5. Enable i2c in raspi-config
6. Enable serial in raspi-config
7. Set correct timezone in raspi-config
8. Take in mind which battery type you have installed (installer asks for it later on)
9. It's advised to make a backup of your sdcard first before continuing the installer

# PIco UPS HV3.0A Chronological install order
1. Check if script is executed as root
2. Check if user uses Rasbian 8.0 (jessie)
3. Check if user uses a RPi 3
4. Precaution and disclaimer
5. Check if RPi is running 4.9 kernel, if not then ask to update and reboot
6. Install menu: 1. Install PIco 2. Remove PIco 3. Quit
7. Starting Installation
a. Check is there was a previous daemon installation, if so then terminate
b. Backup /boot/config.txt
c. Enabling dtoverlays in /boot/config.txt
d. Enabling i2c in /boot/config.txt
e. Enabling rtc in /boot/config.txt
f. Install PIco apt-get necessities
g. Clone Pimodules git
h. Install PIco daemons and scripts
i. Ask for a reboot as it is mandatory at this stage
j. Check if all modules are loaded and set rtc clock
k. Ask user which battery type he/she is having
l. Inform user if any errors occured
m. Finish installation and cleanup
