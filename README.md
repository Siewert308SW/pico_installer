![alt text](picotoolkit.png "toolkit")
<br />

# PIco UPS HV3.0A Toolkit
Bash script that installs all necessities for PIco HV3.0A series<br />
If you want to comment or report bugs then please visit my thread on Pimodules.<br />
http://www.forum.pimodules.com/viewtopic.php?f=27&t=4870 <br />
<br />
Here you'll find a install script as part of the original PIco UPS HV3.0A series manual, thx to @Pimaster for that.<br />
When using this script it aint mandatory to follow the install manual or install, amend anything to your Raspberry Pi3.<br />
This script is pretty straight forward.<br />
And takes care everything for you in order to be able to install all PIco UPS HV3.0A necessities.<br />
<br />

# Precautions
1. Install your PIco UPS board before continuing<br />
2. This script is only intended for Raspberry Pi 3 Model B Rev 1.2<br />
3. Its adviced to use a clean Rasbian Jessie, Stretch, Minibian, DietPi, Ubuntu Mate or LibreELE installation<br />
4. Latest 4.4.50 or 4.9 kernel<br />
5. Preflashed PIco firmware 0x30 or higher<br />
6. Correct timezone in raspi-config<br />
7. It's advised to make a backup of your sdcard first before continuing<br />
<br />

# Install guide via ssh
1. SSH into your Raspberry PI<br />
2. Create a bash file called picotoolkit.sh<br />
3. Copy and past the content from the (here) into your new create .sh file<br />
4. chmod +x /<file_location>/picotoolkit.sh<br />
5. sudo bash /<file_location>/picotoolkit.sh<br />
6. Follow instructions...<br />
<br />

# Install guide via ftp and ssh
1. Download a pre zipped .sh file from here<br />
2. Unzip this zipped file and copy the content to your Raspberry Pi with any kind of ftp program<br />
3. SSH into your Raspberry PI<br />
4. chmod +x /<file_location>/picotoolkit.sh<br />
5. sudo bash /<file_location>/picotoolkit.sh<br />
6. Follow instructions...<br />
<br />

# Disclaimer
I don't take any responsibility if your OS, Rpi or PIco board gets broken<br />
You are using this script on your own responsibility!!!<br />
