#!/bin/bash

#######################################################################################################
### pico_installer.sh
### @author	: Siewert Lameijer
### @since	: 21-3-2017
### @updated: 23-7-2017
### Script for installing PIco HV3.0A UPS

#add dtoverlay=pi3-disable-bt

#reboot
sudo systemctl stop bluetooth
sleep 2
sudo systemctl disable bluetooth
sleep 2
sudo systemctl disable hciuart
sleep 2
sudo systemctl stop serial-getty@ttyAMA0.service
sleep 2
sudo systemctl disable serial-getty@ttyAMA0.service
sleep 2
sudo i2cset -y 1 0x6b 0x00 0xff
sleep 2
sudo python picofu.py -v -f picofu_38.hex
sleep 10
sudo systemctl enable serial-getty@ttyAMA0.service
sleep 2
sudo systemctl start serial-getty@ttyAMA0.service
sleep 2 
sudo systemctl enable hciuart
sleep 2
sudo systemctl enable bluetooth
sleep 2
sudo systemctl start bluetooth	
#######################################################################################################
### Do not edit anything below this line unless your knowing what to do!
#######################################################################################################

echo "
 ____ ___            _   ___     _______  ___    _      _   _ ____  ____  
|  _ \_ _|___ ___   | | | \ \   / /___ / / _ \  / \    | | | |  _ \/ ___| 
| |_) | |/ __/ _ \  | |_| |\ \ / /  |_ \| | | |/ _ \   | | | | |_) \___ \ 
|  __/| | (_| (_) | |  _  | \ V /  ___) | |_| / ___ \  | |_| |  __/ ___) |
|_|  |___\___\___/  |_| |_|  \_/  |____(_)___/_/   \_\  \___/|_|   |____/ 
                                                                          
		 ___           _        _ _           
		|_ _|_ __  ___| |_ __ _| | | ___ _ __ 
		 | ||  _ \/ __| __/ _  | | |/ _ \  __|
		 | || | | \__ \ || (_| | | |  __/ |   
		|___|_| |_|___/\__\__ _|_|_|\___|_|   
	  
"
user=`whoami`

if [ -f /home/pi/pico_menu_option.conf ]; then
menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
if [ "$menu_option" != "menu_option=0" ] ; then	
sed -i "s,$menu_option,menu_option=0," /home/pi/pico_menu_option.conf
fi
else
echo menu_option=0 >> /home/pi/pico_menu_option.conf
fi

### Checking if script is executed as root
if [[ $EUID -ne 0 ]]; then
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Script must be executed as root"
	echo "--- Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi	
	exit
fi

### Checking if OS version matches preferences
release=`/usr/bin/lsb_release -s -d`
if [ "$release" != "Raspbian GNU/Linux 8.0 (jessie)" ]; then
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Installer is intended for Raspbian GNU/Linux 8.0 (jessie)"
	echo "--- Instal script detected you are using $release"
	echo "--- Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
	exit
fi

### Checking if RPi version matches preferences
rpiversion=`cat /proc/device-tree/model`
if [ "$rpiversion" != "Raspberry Pi 3 Model B Rev 1.2" ]; then
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Installer is intended for Raspberry Pi 3 Model B Rev 1.2"
	echo "--- Install script detected you are using $rpiversion"
	echo "--- Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
	exit	
fi

### Checking if kernel version matches preferences
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
kernel_version=$(uname -r | /usr/bin/cut -c 1-6)

if [ $(version $kernel_version) -ge $(version "4.9") ] || [ $(version $kernel_version) -ge $(version "4.4.50") ]; then
	echo " "
else
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Installer is intended for kernel version 4.4.50 or higher"
	echo "--- Install script detected you are using $kernel_version"
	echo "--- Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
	exit
	
fi

### Checking for a working internet connection
if ping -c 1 google.com >> /dev/null 2>&1; then
	echo ""
else
	echo "-> Didn't detect a working internet connection"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Installer scripts needs a working internet connection"
	echo " please make sure your internet connection is working"
	echo " Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi	
	exit
fi	
sleep 1

#######################################################################################################
### PIco UPS HV3.0A install menu
#######################################################################################################

		echo "::: PIco UPS HV3.0A Install Menu"
		echo "------------------------------------------------------------------------"
		echo " "
		options=("Install - PIco HV3.0A" "remove - PIco HV3.0A" "Status - PIco HV3.0A" "Quit")
		COLUMNS=12
		select opt in "${options[@]}"
		
		do
			case $opt in
				"Install - PIco HV3.0A")
					menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
					if [ "$menu_option" != "menu_option=1" ] ; then	
					sed -i "s,$menu_option,menu_option=1," /home/pi/pico_menu_option.conf
					fi		
					break			
					;;
				"remove - PIco HV3.0A")
					menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
					if [ "$menu_option" != "menu_option=2" ] ; then	
					sed -i "s,$menu_option,menu_option=2," /home/pi/pico_menu_option.conf
					fi	
					break			
					;;
				"Status - PIco HV3.0A")
					menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
					if [ "$menu_option" != "menu_option=3" ] ; then	
					sed -i "s,$menu_option,menu_option=3," /home/pi/pico_menu_option.conf
					fi	
					break			
					;;						
				"Quit")
					menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
					if [ "$menu_option" != "menu_option=4" ] ; then	
					sed -i "s,$menu_option,menu_option=4," /home/pi/pico_menu_option.conf
					fi
					break
					;;
				*) echo invalid option;;
			esac			
		done	
		
if [ -f /home/pi/pico_menu_option.conf ]; then
menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
fi	
#######################################################################################################
### MENU OPTION 1: PIco UPS HV3.0A precautions check
#######################################################################################################

if [ "$menu_option" == "menu_option=1" ]; then
echo " "
echo "::: PIco UPS HV3.0A Installer"
echo "------------------------------------------------------------------------"
echo "Welcome $user,"
echo "You are about to install all necessities for your PIco HV3.0A UPS series"
echo "There are some precautions and necessities to install"
echo "Most of them are done by the install script"
echo "Below a list with precautions you've to take care of"
echo " "
echo "Precautions:"
echo "1. Install your PIco UPS board before continuing"
echo "2. This script is only intended for Raspberry Pi 3 Model B Rev 1.2"
echo "3. Use a clean Rasbian Jessie 8.0 installation"
echo "   Or a installation which hasn't seen a previously installed PIco daemon "
echo "4. Latest 4.4.50 or 4.9 kernel"
echo "5. Preflashed PIco firmware 0x30 or higher"	
echo "6. Set correct timezone in raspi-config"
echo "7. It's advised to make a backup of your sdcard first before continuing"
echo " "
echo "Disclaimer:"
echo "I don't take any responsibility if your OS, Rpi or PIco board gets broken"
echo "You are using this script on your own responsibility!!!"
echo " "
	read -p "==> Continue? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		echo " "
	else
echo " "	
echo "::: PIco UPS HV3.0A Installer Terminated"
echo "---------------------------------------------------"
echo " Thx $user for using PIco HV3.0A Installer"
echo " Installer terminated!"
echo " "	
			if [ -f /home/pi/pico_menu_option.conf ]; then
			sudo rm -rf /home/pi/pico_menu_option.conf
			fi		
		exit
	fi

echo " "
echo "::: PIco UPS HV3.0A precautions check"
echo "------------------------------------------------------------------------"
sleep 1

### Checking if there's a previous PIco service running
picoserviceactive=`sudo service picofssd status | grep Active | awk {'print $2'}`

if [ "$picoserviceactive" == "active" ] ; then
	echo "- Script detected a previous running PIco service"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " As there is a daemon active"		
	echo " As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
	echo " Installer terminated!"
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
	exit
else
	echo "-> no PIco service running, step skipped"
	
fi
sleep 1

### Checking if there's a previous PIco daemon running
picodaemon="/usr/local/bin/picofssd"
if [ -f $picodaemon ] ; then
	echo "- Script detected a previous PIco daemon"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " As the script found some leftovers"
	echo " As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
	echo " Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
	exit	
else
	echo "-> no PIco daemon detected, step skipped"	
fi	
sleep 1

### Checking if there's a previous PIco init file loaded
picoinit="/etc/init.d/picofssd"	
if [ -f $picoinit ] ; then
	echo "7. Script detected a previous PIco init file"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " As the script found some leftovers"
	echo " As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
	echo " Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
	exit	
else
	echo "-> no PIco init file detected, step skipped"	
fi	
sleep 1

### Checking if i2c is enabled
raspii2c=`sudo cat /boot/config.txt | grep dtparam=i2c_arm=on`
if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	echo "-> dtparam=i2c_arm already enabled, step skipped"
elif [ "$raspii2c" == "#dtparam=i2c_arm=on" ]; then	
	echo "-> dtparam=i2c_arm enabled"
	sed -i "s,$raspii2c,dtparam=i2c_arm=on," /boot/config.txt	
else
	echo "-> dtparam=i2c_arm enabled"
	sudo sh -c "echo 'dtparam=i2c_arm=on' >> /boot/config.txt"
fi
sleep 1

### Checking if serial uart is enabled
raspiuart=`sudo cat /boot/config.txt | grep enable_uart`
if [ "$raspiuart" == "enable_uart=1" ]; then
	echo "-> serial uart already enabled, step skipped"
elif [ "$raspiuart" == "#enable_uart=1" ]; then	
	echo "-> serial uart enabled"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
elif [ "$raspiuart" == "#enable_uart=0" ]; then	
	echo "-> serial uart enabled"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
elif [ "$raspiuart" == "enable_uart=0" ]; then	
	echo "-> serial uart enabled"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt	
else
	echo "-> serial uart enabled"
	sudo sh -c "echo 'enable_uart=1' >> /boot/config.txt"
fi
sleep 1

### Checking for old rtc module load statement
rtcmoduleold=`sudo cat /etc/modules | grep rtc-ds1307`
if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
	echo "-> Wheezy rtc module detected, module disabled"
	sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules	
else
	echo "-> no Wheezy rtc module statement detected, step skipped"
fi
sleep 1

### Checking for Wheezy rtc statement in rc.local
rtcmoduleold2=`sudo cat /etc/rc.local | grep echo`
if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
	echo "-> Wheezy rtc rc.local statement detected, statement disabled"
	sed -i "s,$rtcmoduleold2,#echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &," /etc/rc.local	
else
	echo "-> no Wheezy rtc rc.local statement, step skipped"
fi
sleep 1

### Checking if rtc dtoverlay module is loaded
rtcmodule=`sudo cat /boot/config.txt | grep dtoverlay=i2c-rtc,ds1307`
if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
	echo "-> dtoverlay=i2c-rtc already enabled, step skipped"
elif [ "$rtcmodule" == "#dtoverlay=i2c-rtc,ds1307" ]; then	
	echo "-> dtoverlay=i2c-rtc enabled"
	sed -i -e 's/#dtoverlay=i2c-rtc,ds1307/dtoverlay=i2c-rtc,ds1307/g' /boot/config.txt	
else
	echo "-> dtoverlay=i2c-rtc enabled"
	sudo sh -c "echo 'dtoverlay=i2c-rtc,ds1307' >> /boot/config.txt"
fi
sleep 1

### Checking if i2c-bcm2708 module is loaded
bcmmodule=`sudo cat /etc/modules | grep i2c-bcm2708`
if [ "$bcmmodule" == "i2c-bcm2708" ]; then
	echo "-> i2c-bcm2708 module already enabled, step skipped"
elif [ "$bcmmodule" == "#i2c-bcm2708" ]; then	
	echo "-> i2c-bcm2708 module enabled"
	sed -i "s,$bcmmodule,i2c-bcm2708," /etc/modules	
else
	echo "-> i2c-bcm2708 module enabled"
	sudo sh -c "echo 'i2c-bcm2708' >> /etc/modules"
fi
sleep 1

### Checking if i2c-dev module is loaded
i2cmodule=`sudo cat /etc/modules | grep i2c-dev`
if [ "$i2cmodule" == "i2c-dev" ]; then
	echo "-> i2c-dev module already enabled, step skipped"
elif [ "$i2cmodule" == "#i2c-dev" ]; then	
	echo "-> i2c-dev module enabled"
	sed -i "s,$i2cmodule,i2c-dev," /etc/modules	
else
	echo "-> i2c-dev module enabled"
	sudo sh -c "echo 'i2c-dev' >> /etc/modules"
fi
sleep 1

### Checking if hciuart service is loaded
uartstatus=`sudo service hciuart status | grep Active | awk {'print $2'}`
if [ "$uartstatus" == "active" ]; then
	echo "-> hciuart service already active, step skipped"
else
	echo "-> enabled hciuart service"
	sudo systemctl enable hciuart
fi
sleep 1	

#######################################################################################################
### PIco UPS HV3.0A necessities check
#######################################################################################################
echo " "
echo "::: $release sourcelist update"
echo "------------------------------------------------------------------------"
	echo "-> This could take a awhile"	
	echo "-> Please Standby!"
	sleep 1
	sudo apt-get update > /dev/null 2>&1
	echo " "	
	echo "-> sourcelist updated!"	
sleep 1

### Checking necessities
pythonrpigpio=`dpkg-query -W -f='${Status}' python-rpi.gpio 2>/dev/null | grep -c "ok installed"`
git=`dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed"`
pythondev=`dpkg-query -W -f='${Status}' python-dev 2>/dev/null | grep -c "ok installed"`
pythonserial=`dpkg-query -W -f='${Status}' python-serial 2>/dev/null | grep -c "ok installed"`
pythonsmbus=`dpkg-query -W -f='${Status}' python-smbus 2>/dev/null | grep -c "ok installed"`
pythonjinja2=`dpkg-query -W -f='${Status}' python-jinja2 2>/dev/null | grep -c "ok installed"`
pythonxmltodict=`dpkg-query -W -f='${Status}' python-xmltodict 2>/dev/null | grep -c "ok installed"`
pythonpsutil=`dpkg-query -W -f='${Status}' python-psutil 2>/dev/null | grep -c "ok installed"`
pythonpip=`dpkg-query -W -f='${Status}' python-pip 2>/dev/null | grep -c "ok installed"`
i2ctools=`dpkg-query -W -f='${Status}' i2c-tools 2>/dev/null | grep -c "ok installed"`

echo " "
echo "::: $release and PIco UPS HV3.0A necessities check"
echo "------------------------------------------------------------------------"
echo "-> This could take a awhile"	
echo "-> Please Standby!"
echo " "	
sleep 1

if [ $pythonrpigpio -eq 1 ]; then
echo "-> python-rpi.gpio package already installed, step skipped"
sleep 1   
else
echo "-> installing python-rpi.gpio package"
	sudo apt-get install -y python-rpi.gpio > /dev/null 2>&1
fi

if [ $git -eq 1 ]; then
echo "-> git package already installed, step skipped"
sleep 1   
else
echo "-> installing git package"
	sudo apt-get install -y git > /dev/null 2>&1
fi

if [ $pythondev -eq 1 ]; then
echo "-> python-dev package already installed, step skipped"
sleep 1   
else
echo "-> installing python-dev package"
	sudo apt-get install -y python-dev > /dev/null 2>&1
fi

if [ $pythonserial -eq 1 ]; then
echo "-> python-serial package already installed, step skipped"
sleep 1   
else
echo "-> installing python-serial package"
	sudo apt-get install -y python-serial > /dev/null 2>&1
fi

if [ $pythonsmbus -eq 1 ]; then
echo "-> python-smbus package already installed, step skipped"
sleep 1   
else
echo "-> installing python-smbus package"
	sudo apt-get install -y python-smbus > /dev/null 2>&1
fi

if [ $pythonjinja2 -eq 1 ]; then
echo "-> python-jinja2 package already installed, step skipped"
sleep 1   
else
echo "-> installing python-jinja2 package"
	sudo apt-get install -y python-jinja2 > /dev/null 2>&1
fi

if [ $pythonxmltodict -eq 1 ]; then
echo "-> python-xmltodict package already installed, step skipped"
sleep 1   
else
echo "-> installing python-xmltodict package"
	sudo apt-get install -y python-xmltodict > /dev/null 2>&1
fi

if [ $pythonpsutil -eq 1 ]; then
echo "-> python-psutil package already installed, step skipped"
sleep 1   
else
echo "-> installing python-psutil package"
	sudo apt-get install -y python-psutil > /dev/null 2>&1
fi

if [ $pythonpip -eq 1 ]; then
echo "-> python-pip package already installed, step skipped"
sleep 1   
else
echo "-> installing python-pip package"
	sudo apt-get install -y python-pip > /dev/null 2>&1
fi

if [ $i2ctools -eq 1 ]; then
echo "-> i2c-tools package already installed, step skipped"
sleep 1   
else
echo "-> installing i2c-tools package"
	sudo apt-get install -y i2c-tools > /dev/null 2>&1
fi
sleep 1

#######################################################################################################
### PIco UPS HV3.0A daemon installation
#######################################################################################################
picogitclone="/home/pi/PiModules/README.md"
echo " "
echo "::: Installing PIco UPS HV3.0A daemons"
echo "------------------------------------------------------------------------"
	echo "-> This could take a awhile"	
	echo "-> Please Standby!"
	echo " "	
	sleep 1
if [ -f $picogitclone ] ; then
echo "-> cloning PiModules"	
sudo rm -rf /home/pi/PiModules
git clone https://github.com/Siewert308SW/PiModules.git	> /dev/null 2>&1
else
echo "-> cloning PiModules"	
git clone https://github.com/Siewert308SW/PiModules.git	> /dev/null 2>&1
	
fi

echo "-> installing PIco mail daemon"	
cd /home/pi/PiModules/code/python/package
	sudo python setup.py install > /dev/null 2>&1
sleep 1
echo "-> installing PIco fssd daemon"
cd ../upspico/picofssd
	sudo python setup.py install > /dev/null 2>&1
sleep 1
echo "-> set picofssd defaults to update-rc.d"	
	sudo update-rc.d picofssd defaults > /dev/null 2>&1
sleep 1
echo "-> enabling picofssd daemon"
	sudo update-rc.d picofssd enable > /dev/null 2>&1
sleep 1
echo "-> starting picofssd daemon"
	sudo /etc/init.d/picofssd start > /dev/null 2>&1
cd ~
	sudo rm -rf /home/pi/PiModules
sleep 1

#######################################################################################################
### PIco UPS HV3.0A installation finished
#######################################################################################################
echo " "
echo "::: PIco UPS HV3.0A installation finished"
echo "------------------------------------------------------------------------"
echo " "
echo " Thx $user for using PIco HV3.0A Installer"
echo " "	
echo " PIco UPS HV3.0a installation finished"
echo " If no errors occured then everything should be up and running"
echo " "
echo " System will be rebooted in 15 seconds to let every changed be activated and loaded"
echo " "
sleep 15
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi
sudo reboot
fi ### end menu option 1

#######################################################################################################
### MENU OPTION 2: PIco UPS HV3.0A removal
#######################################################################################################
	
if [ "$menu_option" == "menu_option=2" ]; then
pythonrpigpio=`dpkg-query -W -f='${Status}' python-rpi.gpio 2>/dev/null | grep -c "ok installed"`
git=`dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed"`
pythondev=`dpkg-query -W -f='${Status}' python-dev 2>/dev/null | grep -c "ok installed"`
pythonserial=`dpkg-query -W -f='${Status}' python-serial 2>/dev/null | grep -c "ok installed"`
pythonsmbus=`dpkg-query -W -f='${Status}' python-smbus 2>/dev/null | grep -c "ok installed"`
pythonjinja2=`dpkg-query -W -f='${Status}' python-jinja2 2>/dev/null | grep -c "ok installed"`
pythonxmltodict=`dpkg-query -W -f='${Status}' python-xmltodict 2>/dev/null | grep -c "ok installed"`
pythonpsutil=`dpkg-query -W -f='${Status}' python-psutil 2>/dev/null | grep -c "ok installed"`
pythonpip=`dpkg-query -W -f='${Status}' python-pip 2>/dev/null | grep -c "ok installed"`
i2ctools=`dpkg-query -W -f='${Status}' i2c-tools 2>/dev/null | grep -c "ok installed"`

raspii2c=`sudo cat /boot/config.txt | grep dtparam=i2c_arm=on`
raspiuart=`sudo cat /boot/config.txt | grep enable_uart`
rtcmodule=`sudo cat /boot/config.txt | grep dtoverlay=i2c-rtc,ds1307`
bcmmodule=`sudo cat /etc/modules | grep i2c-bcm2708`
rtcmoduleold=`sudo cat /etc/modules | grep rtc-ds1307`
rtcmoduleold2=`sudo cat /etc/rc.local | grep echo`
i2cmodule=`sudo cat /etc/modules | grep i2c-dev`

if [ "$raspii2c" == "dtparam=i2c_arm=on" ] || [ "$raspiuart" == "enable_uart=1" ] || [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ] || [ "$bcmmodule" == "i2c-bcm2708" ] || [ "$rtcmoduleold" == "rtc-ds1307" ] || [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ] || [ "$i2cmodule" == "i2c-dev" ] || [ $pythonrpigpio -eq 1 ] || [ $git -eq 1 ] || [ $pythondev -eq 1 ] || [ $pythonserial -eq 1 ] || [ $pythonsmbus -eq 1 ] || [ $pythonjinja2 -eq 1 ] || [ $pythonxmltodict -eq 1 ] || [ $pythonpsutil -eq 1 ] || [ $pythonpip -eq 1 ] || [ $i2ctools -eq 1 ]; then

echo " "
echo " "
echo "::: PIco UPS HV3.0A Removal"
echo "------------------------------------------------------------------------"
echo "Dear $user,"
echo "You chose to remove all necessities which are PIco related"
echo "But some necessities aren't PIco related and used by other resources"
echo "There for you will be asked if you want to remove them..."
echo " "

read -p "Press enter to continue..."
echo " "
sleep 1

### Checking if script is executed as root
if [[ $EUID -ne 0 ]]; then
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Script must be executed as root"
	echo "--- Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi	
	exit	
fi
sleep 1

### Checking if RPi version matches preferences
rpiversion=`cat /proc/device-tree/model`
if [ "$rpiversion" != "Raspberry Pi 3 Model B Rev 1.2" ]; then
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Installer is intended for Raspberry Pi 3 Model B Rev 1.2"
	echo "--- Install script detected you are using $rpiversion"
	echo "--- Installer terminated!"
	echo " "
	if [ -f /home/pi/pico_menu_option.conf ]; then
	sudo rm -rf /home/pi/pico_menu_option.conf
	fi	
	exit	
fi
sleep 1

### Checking if there's a PIco service running
picoserviceactive=`sudo service picofssd status | grep Active | awk {'print $2'}`


if [ "$picoserviceactive" == "active" ] ; then
	echo "-> PIco service stopped"
	sudo service picofssd stop > /dev/null 2>&1
else
	echo "-> no PIco service detected, step skipped"
	
fi
sleep 1


### Checking if there's a PIco daemon running
picodaemon="/usr/local/bin/picofssd"
if [ -f $picodaemon ] ; then
	echo "-> PIco daemon removed"
	sudo rm -rf /usr/local/bin/picofssd > /dev/null 2>&1
else
	echo "-> no PIco daemon detected, step skipped"	
fi	
sleep 1


### Checking if there's a PIco init file loaded
picoinit="/etc/init.d/picofssd"	
if [ -f $picoinit ] ; then
	echo "-> PIco init file removed"
	sudo rm -rf /etc/init.d/picofssd > /dev/null 2>&1
else
	echo "-> no PIco init file detected, step skipped"	
fi	
sleep 1

### Checking if i2c is enabled
if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	
	read -p "-> disable dtparam=i2c_arm? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sed -i "s,$raspii2c,#dtparam=i2c_arm=on," /boot/config.txt
	fi
else
	echo "-> dtparam=i2c_arm already disabled, step skipped"
sleep 1
fi


### Checking if serial uart is enabled
if [ "$raspiuart" == "enable_uart=1" ]; then
	
	read -p "-> disable serial uart? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sed -i "s,$raspiuart,#enable_uart=1," /boot/config.txt	
	fi	

else
	echo "-> serial uart already disabled, step skipped"
sleep 1	
fi


### Checking if rtc dtoverlay module is loaded
if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
	
	read -p "-> disable dtoverlay=i2c-rtc? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sed -i -e 's/dtoverlay=i2c-rtc/#dtoverlay=i2c-rtc/g' /boot/config.txt	
	fi
	
else
	echo "-> dtoverlay=i2c-rtc already disabled, step skipped"
sleep 1	
fi


### Checking if i2c-bcm2708 module is loaded
if [ "$bcmmodule" == "i2c-bcm2708" ]; then
	
	read -p "-> disable i2c-bcm2707 module? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sed -i "s,$bcmmodule,#i2c-bcm2708," /etc/modules	
	fi
	
else
	echo "-> i2c-bcm2708 module already disabled, step skipped"
sleep 1	
fi


### Checking for old rtc module load statement
if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
	
	read -p "-> disable Wheezy rtc module? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules
	fi
		
else
	echo "-> Wheezy rtc module already disabled, step skipped"
sleep 1	
fi


### Checking for old rtc load statement in rc.local
if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
	
	read -p "-> disable Wheezy rtc statement? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sudo sed -i -e 's/echo ds1307 0x68/#echo ds1307 0x68/g' /etc/rc.local
	fi
		
else
	echo "-> Wheezy rtc statement in rc.local already disabled, step skipped"
sleep 1	
fi


### Checking if i2c-dev module is loaded
if [ "$i2cmodule" == "i2c-dev" ]; then
	
	read -p "-> disable i2c-dev module? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	sed -i "s,$i2cmodule,#i2c-dev," /etc/modules	
	fi	
		
else
	echo "-> i2c-dev module already disabled, step skipped"
sleep 1	
fi


if [ $pythonrpigpio -eq 1 ]; then
	
	read -p "-> remove python-rpi.gpio package ? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-rpi.gpio -y > /dev/null 2>&1	
	fi
else
	echo "-> python-rpi package already removed, step skipped"
sleep 1		
fi


if [ $git -eq 1 ]; then
	
	read -p "-> remove git package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove git -y > /dev/null 2>&1
	fi
else
	echo "-> git package already removed, step skipped"
sleep 1	
fi


if [ $pythondev -eq 1 ]; then
	
	read -p "-> remove python-dev package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-dev -y > /dev/null 2>&1
	fi
else
	echo "-> python-dev package already removed, step skipped"
sleep 1	
fi


if [ $pythonserial -eq 1 ]; then
	
	read -p "-> remove python-serial package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-serial -y > /dev/null 2>&1	
	fi
else
	echo "-> python-serial package already removed, step skipped"	
sleep 1	
fi


if [ $pythonsmbus -eq 1 ]; then
	
	read -p "-> remove python-smbus package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-smbus -y > /dev/null 2>&1	
	fi
else
	echo "-> python-smbus package already removed, step skipped"
sleep 1	
fi


if [ $pythonjinja2 -eq 1 ]; then
	
	read -p "-> remove python-jinja2 package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-jinja2 -y > /dev/null 2>&1
	fi
else
	echo "-> python-jinja2 package already removed, step skipped"
sleep 1	
fi


if [ $pythonxmltodict -eq 1 ]; then
	
	read -p "-> remove python-xmltodict package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-xmltodict -y > /dev/null 2>&1	
	fi
else
	echo "-> python-xmltodict package already removed, step skipped"
sleep 1	
fi


if [ $pythonpsutil -eq 1 ]; then
	
	read -p "-> remove python-psutil package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-psutil -y > /dev/null 2>&1	
	fi
else
	echo "-> python-psutil package already removed, step skipped"	
sleep 1	
fi


if [ $pythonpip -eq 1 ]; then
	
	read -p "-> remove python-pip package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-pip -y > /dev/null 2>&1	
	fi
else
	echo "-> python-pip package already removed, step skipped"
sleep 1	
fi


if [ $i2ctools -eq 1 ]; then
	
	read -p "-> remove i2c-tools package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove i2c-tools -y > /dev/null 2>&1	
	fi
else
	echo "-> i2c-tools package already removed, step skipped"
sleep 1	
fi

### Cleaning up
	echo " "
	echo "::: Cleaning up!"
	echo "------------------------------------------------------------------------"
	echo "-> This could take a awhile"	
	echo "-> Please Standby!"
	echo " "
	sudo rm -rf /etc/pimodules/picofssd
	sudo rm -rf /etc/default/picofssd
	sudo rm -rf /etc/pimodules
	sudo rm -rf /usr/local/lib/python2.7/dist-packages/pimodules
	echo "-> sudo apt-get autoremove"	
	sudo apt-get autoremove -y > /dev/null 2>&1
sleep 1

#######################################################################################################
### PIco UPS HV3.0A removal finished
#######################################################################################################
		echo " "
		echo "::: PIco UPS HV3.0A removal finished"
		echo "------------------------------------------------------------------------"
		echo " "
		echo " Thx $user for using PIco HV3.0A Removal tool"
		echo " "	
		echo " PIco UPS HV3.0a removal finished"
		echo " If no errors occured then everything removed"
		echo " After the system has been reboot then your able to shutdown the system and remove the PIco board"
		echo " "
		echo " System will be rebooted in 15 seconds..."
		echo " "		
		sleep 15
		if [ -f /home/pi/pico_menu_option.conf ]; then
		sudo rm -rf /home/pi/pico_menu_option.conf
		fi	
		sudo reboot		
	else
		echo " "
		echo "::: PIco UPS HV3.0A removal terminated"
		echo "------------------------------------------------------------------------"
		echo " "
		echo " Thx $user for using PIco HV3.0A Removal tool"
		echo " "	
		echo " PIco UPS HV3.0a removal terminated"
		echo " The removal tools didn't remove or delete anything"
		echo " As it seems you already used this tool or running it on a clean Jessie installation"
		echo " "
		echo " Removal tool finished and terminated..."		
		echo " "
		sleep 1
		if [ -f /home/pi/pico_menu_option.conf ]; then
		sudo rm -rf /home/pi/pico_menu_option.conf
		fi	
		exit
	fi	

fi

#######################################################################################################
### MENU OPTION 3: PIco UPS HV3.0A Status
#######################################################################################################
	
if [ "$menu_option" == "menu_option=3" ]; then
picoserviceactive=`sudo service picofssd status | grep Active | awk {'print $2'}`

	if [ "$picoserviceactive" != "active" ] ; then

			echo " "
			echo "::: UPS PIco HV3.0A Status"
			echo "---------------------------------------------------"
			echo " "			
			echo "- PIco Firmware..........: n/a"
			echo "- PIco Bootloader........: n/a"
			echo "- PIco PCB Version.......: n/a"
			echo "- PIco BAT Version.......: n/a"
			echo "- HWclock................: n/a"
			echo " "
			echo "- UPS HV3.0A Status......: n/a"	
			echo " "			
			echo "---------------------------------------------------"
			echo " "
			
		if [ -f /home/pi/pico_menu_option.conf ]; then
		sudo rm -rf /home/pi/pico_menu_option.conf
		fi
		exit
	else

			firmware=`sudo i2cget -y 1 0x69 0x26 | grep 0x | awk {'print substr($1,3); '}`
			bootloader=`sudo i2cget -y 1 0x69 0x25 | grep 0x | awk {'print substr($1,3); '}`
			pcb=`sudo i2cget -y 1 0x69 0x24 | grep 0x | awk {'print substr($1,3); '}`
			batterytype=`sudo i2cget -y 1 0x6b 0x07 | grep 0x | awk {'print substr($1,3); '}`			
			hwclockget=`sudo hwclock -r --test | grep seconds | awk {'print $1, $2, $3, $4, $5'}`
			picoservice=`sudo systemctl status picofssd -l | grep Active | awk {'print $2'}`
			picoservicerun=`sudo systemctl status picofssd -l | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`
			
			if [ "$batterytype" == "50" ] ; then
			battery="LiPO (ASCII: P) version Plus"
			fi
			
			if [ "$batterytype" == "53" ] ; then
			battery="LiPO (ASCII: S) version Stack/TopEnd"
			fi

			if [ "$batterytype" == "51" ] ; then
			battery="LiFePO4 (ASCII: Q) version Plus"
			fi

			if [ "$batterytype" == "46" ] ; then
			battery="LiFePO4 (ASCII : F) version Stack/TopEnd"
			fi
			
			echo " "
			echo "::: UPS PIco HV3.0A Status"
			echo "---------------------------------------------------"
			echo " "			
			echo "- PIco Firmware.............: "$firmware
			echo "- PIco Bootloader...........: "$bootloader
			echo "- PIco PCB Version..........: "$pcb
			echo "- PIco BAT Version..........: "$battery
			echo "- HWclock...................: "$hwclockget
			echo " "
			echo "- UPS HV3.0A Status.........: ${picoservice} and ${picoservicerun}"
			echo " "			
			echo "---------------------------------------------------"
			echo " "	
		
	fi

fi

#######################################################################################################
### MENU OPTION 4: PIco UPS HV3.0A quit
#######################################################################################################
	
if [ "$menu_option" == "menu_option=4" ]; then
echo " "
echo " "	
echo "::: PIco UPS HV3.0A Installer Terminated"
echo "---------------------------------------------------"
echo " Thx $user for using PIco HV3.0A Installer"
echo " Installer terminated!"
echo " "	
if [ -f /home/pi/pico_menu_option.conf ]; then
sudo rm -rf /home/pi/pico_menu_option.conf
fi	
fi
