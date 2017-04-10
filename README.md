# PIco UPS HV3.0A Installer
Bash script that installs all necessities for PIco HV3.0A series<br />
If you want to comment or report bugs then please visit my thread on Pimodules.<br />
http://www.forum.pimodules.com/viewtopic.php?f=27&t=4870 <br />
<br />
It's beta and i want to know if it works for you guys.<br />
<br />
At the moment the script is only available for:<br />
- Raspberry Pi 3 Model B Rev 1.2<br />
- Rasbian Jessie 8.0 - with latest 4.9 kernel<br />
<br />
This script installs all necessities for PIco HV3.0A UPS.<br />
Easier then by hand and saves searching the manual.<br />
<br />
Save the pico_installer to /home/pi/pico_installer.sh<br />
And fire it up via ssh and follow all instructions.<br />
The script will ask for a reboot after that you have to as mentioned in the installer restart the script to finish the installation.<br />
The installer is several fail saves and system checks.<br />
Also it contains 3 menu options.<br />
<br />
1. Install PIco<br />
2. Remove PIco<br />
3. quit<br />
<br />
# PIco UPS HV3.0A Precautions
There are some precautions to take before you continue the installer<br />
<br />
Disclaimer:<br />
I don't take any responsibility if your OS, Rpi or PIco board gets broken<br />
You are using this script on your own responsibility!!!<br />
<br />
Precautions:<br />
1. Install your PIco board before continuing the installer<br />
2. Raspberry Pi 3 Model B Rev 1.2<br />
3. Use a clean Rasbian Jessie 8.0 installation<br />
Or a installation which hasn't seen a previously installed PIco daemon<br />
4. Latest 4.9 kernel (handled by the script)<br />
5. Enable i2c in raspi-config<br />
6. Enable serial in raspi-config<br />
7. Set correct timezone in raspi-config<br />
8. Take in mind which battery type you have installed (installer asks for it later on)<br />
9. It's advised to make a backup of your sdcard first before continuing the installer<br />
<br />
# PIco UPS HV3.0A Chronological install order<br />
1. Check if script is executed as root<br />
2. Check if user uses Rasbian 8.0 (jessie<br />
3. Check if user uses a RPi 3<br />
4. Precaution and disclaimer<br />
5. Check if RPi is running 4.9 kernel, if not then ask to update and reboot<br />
6. Install menu: 1. Install PIco 2. Remove PIco 3. Quit<br />
7. Starting Installation<br />
a. Check is there was a previous daemon installation, if so then terminate<br />
b. Backup /boot/config.txt<br />
c. Enabling dtoverlays in /boot/config.txt<br />
d. Enabling i2c in /boot/config.txt<br />
e. Enabling rtc in /boot/config.txt<br />
f. Install PIco apt-get necessities<br />
g. Clone Pimodules git<br />
h. Install PIco daemons and scripts<br />
i. Ask for a reboot as it is mandatory at this stage<br />
j. Check if all modules are loaded and set rtc clock<br />
k. Ask user which battery type he/she is having<br />
l. Inform user if any errors occured<br />
m. Finish installation and cleanup<br />
