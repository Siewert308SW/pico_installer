#!/bin/bash

###############################################################################################################################################################	

### pico_menu_option.sh
### @author	: Siewert Lameijer
### @since	: 21-3-2017
### @updated: 18-7-2017
### Script for installing PIco HV3.0A UPS
	
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
	
#######################################################################################################
### PIco UPS HV3.0A Welcome
#######################################################################################################
if [ -f /home/pi/pico_menu_option.conf ]; then
menu_option=`cat /home/pi/pico_menu_option.conf | grep welcome`	
fi

if [ "$menu_option" != "welcome=1" ] ; then	
echo "::: PIco UPS HV3.0A Installer"
echo "------------------------------------------------------------------------"
echo "Welcome $user,"
echo "You are about to install all necessities for your brand new PIco HV3.0A UPS series"
echo "There are some precautions and necessities to install"
echo "Most of them are done by the script, below a list with precautions you've to take care of"
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
echo " "

	read -p "==> Continue! (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
		echo welcome=1 >> /home/pi/pico_menu_option.conf
		echo menu_option=0 >> /home/pi/pico_menu_option.conf
		echo " "
	else
		echo " "
		echo "--- Installer terminated!"
		echo "--- Good Bye"	
			if [ -f /home/pi/pico_menu_option.conf ]; then
			sudo rm -rf /home/pi/pico_menu_option.conf
			fi		
		echo " "
		echo " "	
		exit
	fi
fi
#######################################################################################################
### PIco UPS HV3.0A install menu
#######################################################################################################

		echo "::: PIco UPS HV3.0A Install Menu"
		echo "------------------------------------------------------------------------"
		echo "--- Please select?"
		echo " "
		options=("Install - PIco HV3.0A" "Remove - PIco HV3.0A" "Quit")
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
				"Remove - PIco HV3.0A")
					menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
					if [ "$menu_option" != "menu_option=2" ] ; then	
					sed -i "s,$menu_option,menu_option=2," /home/pi/pico_menu_option.conf
					fi	
					break			
					;;				
				"Quit")
					menu_option=`cat /home/pi/pico_menu_option.conf | grep menu_option`	
					if [ "$menu_option" != "menu_option=3" ] ; then	
					sed -i "s,$menu_option,menu_option=3," /home/pi/pico_menu_option.conf
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
echo " "
echo "::: PIco UPS HV3.0A precautions check"
echo "------------------------------------------------------------------------"
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
	sudo rm -rf /home/pi/pico_menu_option.conf	
	exit
else
	echo "1. Script has been executed as root"	
fi
sleep 1

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
	sudo rm -rf /home/pi/pico_menu_option.conf
	exit
else
	echo "2. Script detected a compatible $release version"	
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
	sudo rm -rf /home/pi/pico_menu_option.conf
	exit
else
	echo "3. Script detected a compatible $rpiversion"	
fi
sleep 1

### Checking if kernel version matches preferences
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
kernel_version=$(uname -r | /usr/bin/cut -c 1-6)

if [ $(version $kernel_version) -ge $(version "4.9") ] || [ $(version $kernel_version) -ge $(version "4.4.50") ]; then
	echo "4. Script detected a compatible kernel version - $kernel_version"
else
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo "--- Installer is intended for kernel version 4.4.50 or higher"
	echo "--- Install script detected you are using $kernel_version"
	echo "--- Installer terminated!"
	echo " "
	sudo rm -rf /home/pi/pico_menu_option.conf
	exit
	
fi
sleep 1

### Checking if there's a previous PIco service running
picoserviceactive=`sudo service picofssd status | grep Active | awk {'print $2'}`

if [ "$picoserviceactive" == "active" ] ; then
	echo "5. Script detected a previous running PIco service"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " As there is a daemon active"		
	echo " As advised you should use this menu_option on a clean Rasbian 8.0 clean/fresh install"
	echo " Installer terminated!"
	sudo rm -rf /home/pi/pico_menu_option.conf
	exit
else
	echo "5. Script didn't detect a previous running PIco service"
	
fi
sleep 1

### Checking if there's a previous PIco daemon running
picodaemon="/usr/local/bin/picofssd"
if [ -f $picodaemon ] ; then
	echo "6. Script detected a previous PIco daemon"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " As the script found some leftovers"
	echo " As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
	echo " Installer terminated!"
	echo " "
	sudo rm -rf /home/pi/pico_menu_option.conf
	exit	
else
	echo "6. Script didn't detect a previous PIco daemon"	
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
	sudo rm -rf /home/pi/pico_menu_option.conf	
	exit	
else
	echo "7. Script didn't detect a previous PIco init file"	
fi	
sleep 1

### Checking if i2c is enabled
raspii2c=`sudo cat /boot/config.txt | grep dtparam=i2c_arm=on`
if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	echo "8. Script detected dtparam i2c already enabled"
elif [ "$raspii2c" == "#dtparam=i2c_arm=on" ]; then	
	echo "8. Script enabled dtparam i2c"
	sed -i "s,$raspii2c,dtparam=i2c_arm=on," /boot/config.txt	
else
	echo "8. Script enabled dtparam i2c"
	sudo sh -c "echo 'dtparam=i2c_arm=on' >> /boot/config.txt"
fi
sleep 1

### Checking if serial uart is enabled
raspiuart=`sudo cat /boot/config.txt | grep enable_uart`
if [ "$raspiuart" == "enable_uart=1" ]; then
	echo "7. Script detected serial uart already enabled"
elif [ "$raspiuart" == "#enable_uart=1" ]; then	
	echo "7. Script enabled serial uart"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
elif [ "$raspiuart" == "#enable_uart=0" ]; then	
	echo "7. Script enabled serial uart"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
elif [ "$raspiuart" == "enable_uart=0" ]; then	
	echo "7. Script enabled serial uart"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt	
else
	echo "7. Script enabled serial uart"
	sudo sh -c "echo 'enable_uart=1' >> /boot/config.txt"
fi
sleep 1

### Checking for old rtc module load statement
rtcmoduleold=`sudo cat /etc/modules | grep rtc-ds1307`
if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
	echo "9. Script detected old rtc module, module disabled"
	sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules	
else
	echo "9. Script didn't detect a old rtc module statement, step skipped"
fi
sleep 1

### Checking for old rtc load statement in rc.local
rtcmoduleold2=`sudo cat /etc/rc.local | grep echo`
if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
	echo "10.Script detected old rtc rc.local load statement, statement disabled"
	sed -i "s,$rtcmoduleold2,#echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &," /etc/rc.local	
else
	echo "10.Script didn't detect a old rtc load statement, step skipped"
fi
sleep 1

### Checking if rtc dtoverlay module is loaded
rtcmodule=`sudo cat /boot/config.txt | grep dtoverlay=i2c-rtc,ds1307`
if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
	echo "11.Script detected rtc dtoverlay already enabled"
elif [ "$rtcmodule" == "#dtoverlay=i2c-rtc,ds1307" ]; then	
	echo "11.Script enabled rtc dtoverlay"
	sed -i "s,$rtcmodule,dtoverlay=i2c-rtc,ds1307," /boot/config.txt	
else
	echo "11.Script enabled rtc dtoverlay"
	sudo sh -c "echo 'dtoverlay=i2c-rtc,ds1307' >> /boot/config.txt"
fi
sleep 1

### Checking if i2c-bcm2708 module is loaded
bcmmodule=`sudo cat /etc/modules | grep i2c-bcm2708`
if [ "$bcmmodule" == "i2c-bcm2708" ]; then
	echo "12.Script detected bcm2708 module already enabled"
elif [ "$bcmmodule" == "#i2c-bcm2708" ]; then	
	echo "12.Script enabled i2c-bcm2708 module"
	sed -i "s,$bcmmodule,i2c-bcm2708," /etc/modules	
else
	echo "12.Script enabled i2c-bcm2708 module"
	sudo sh -c "echo 'i2c-bcm2708' >> /etc/modules"
fi
sleep 1

### Checking if i2c-dev module is loaded
i2cmodule=`sudo cat /etc/modules | grep i2c-dev`
if [ "$i2cmodule" == "i2c-dev" ]; then
	echo "13.Script detected i2c-dev module already enabled"
elif [ "$i2cmodule" == "#i2c-dev" ]; then	
	echo "13.Script enabled i2c-dev module"
	sed -i "s,$i2cmodule,i2c-dev," /etc/modules	
else
	echo "13.Script enabled i2c-dev module"
	sudo sh -c "echo 'i2c-dev' >> /etc/modules"
fi
sleep 1

### Checking if hciuart service is loaded
uartstatus=`sudo service hciuart status | grep Active | awk {'print $2'}`
if [ "$uartstatus" == "active" ]; then
	echo "14.Script detected hciuart service already active"
else
	echo "14.Script enabled hciuart service"
	sudo systemctl enable hciuart
fi
sleep 1

### Checking for a working internet connection
if ping -c 1 google.com >> /dev/null 2>&1; then
	echo "15.Script detected a working internet connection"
else
	echo "15.Script didn't detect a working internet connection"
	echo " "
	echo "::: Installer terminated!"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Installer scripts needs a working internet connection"
	echo " please make sure your internet connection is working"
	echo " Installer terminated!"
	echo " "
	sudo rm -rf /home/pi/pico_menu_option.conf	
	exit
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
	echo "-> sourcelist updated!"	
sleep 1

### Checking necessities
pythonrpigpio=`sudo dpkg-query -l | grep python-rpi.gpio | wc -l`
git=`sudo dpkg-query -l | grep git | wc -l` 
pythondev=`sudo dpkg-query -l | grep python-dev | wc -l` 
pythonserial=`sudo dpkg-query -l | grep python-serial | wc -l`
pythonsmbus=`sudo dpkg-query -l | grep python-smbus | wc -l`
pythonjinja2=`sudo dpkg-query -l | grep python-jinja2 | wc -l` 
pythonxmltodict=`sudo dpkg-query -l | grep python-xmltodict | wc -l` 
pythonpsutil=`sudo dpkg-query -l | grep python-psutil | wc -l` 
pythonpip=`sudo dpkg-query -l | grep python-pip | wc -l`
i2ctools=`sudo dpkg-query -l | grep i2c-tools | wc -l`
echo " "
echo "::: $release and PIco UPS HV3.0A necessities check"
echo "------------------------------------------------------------------------"
echo "-> This could take a awhile"	
echo "-> Please Standby!"
echo " "	
sleep 1

if [ $pythonrpigpio -eq 1 ]; then
echo "- python-rpi.gpio already installed"
sleep 1   
else
echo "- Installing python-rpi.gpio"
	sudo apt-get install -y python-rpi.gpio > /dev/null 2>&1
fi

if [ $git -eq 3 ]; then
echo "- git already installed"
sleep 1   
else
echo "- Installing git"
	sudo apt-get install -y git > /dev/null 2>&1
fi

if [ $pythondev -eq 2 ]; then
echo "- python-dev already installed"
sleep 1   
else
echo "- Installing python-dev"
	sudo apt-get install -y python-dev > /dev/null 2>&1
fi

if [ $pythonserial -eq 1 ]; then
echo "- python-serial already installed"
sleep 1   
else
echo "- Installing python-serial"
	sudo apt-get install -y python-serial > /dev/null 2>&1
fi

if [ $pythonsmbus -eq 1 ]; then
echo "- python-smbus already installed"
sleep 1   
else
echo "- Installing python-smbus"
	sudo apt-get install -y python-smbus > /dev/null 2>&1
fi

if [ $pythonjinja2 -eq 1 ]; then
echo "- python-jinja2 already installed"
sleep 1   
else
echo "- Installing python-jinja2"
	sudo apt-get install -y python-jinja2 > /dev/null 2>&1
fi

if [ $pythonxmltodict -eq 1 ]; then
echo "- python-xmltodict already installed"
sleep 1   
else
echo "- Installing python-xmltodict"
	sudo apt-get install -y python-xmltodict > /dev/null 2>&1
fi

if [ $pythonpsutil -eq 1 ]; then
echo "8. python-psutil already installed"
sleep 1   
else
echo "- Installing python-psutil"
	sudo apt-get install -y python-psutil > /dev/null 2>&1
fi

if [ $pythonpip -eq 1 ]; then
echo "- python-pip already installed"
sleep 1   
else
echo "- Installing python-pip"
	sudo apt-get install -y python-pip > /dev/null 2>&1
fi

if [ $i2ctools -eq 1 ]; then
echo "- i2c-tools already installed"
sleep 1   
else
echo "- Installing i2c-tools"
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
echo "1. Cloning PiModules git"	
sudo rm -rf /home/pi/PiModules
git clone https://github.com/Siewert308SW/PiModules.git	> /dev/null 2>&1
else
echo "1. Cloning PiModules git"	
git clone https://github.com/Siewert308SW/PiModules.git	> /dev/null 2>&1
	
fi

echo "2. Installing PIco mail daemon"	
cd /home/pi/PiModules/code/python/package
	sudo python setup.py install > /dev/null 2>&1
sleep 1
echo "3. Installing PIco fssd daemon"
cd ../upspico/picofssd
	sudo python setup.py install > /dev/null 2>&1
sleep 1
echo "4. Set picofssd defaults to update-rc.d"	
	sudo update-rc.d picofssd defaults > /dev/null 2>&1
sleep 1
echo "5. Enabling picofssd daemon"
	sudo update-rc.d picofssd enable > /dev/null 2>&1
sleep 1
echo "6. Starting picofssd daemon"
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
echo " System will be rebooted in 15 seconds to let every changed be activated and loaded"
sleep 15
sudo rm -rf /home/pi/pico_menu_option.conf
sudo reboot
fi ### end menu option 1

#######################################################################################################
### MENU OPTION 2: PIco UPS HV3.0A removal
#######################################################################################################
	
if [ "$menu_option" == "menu_option=2" ]; then
pythonrpigpio=`sudo dpkg-query -l | grep python-rpi.gpio | wc -l`
git=`sudo dpkg-query -l | grep git | wc -l` 
pythondev=`sudo dpkg-query -l | grep python-dev | wc -l` 
pythonserial=`sudo dpkg-query -l | grep python-serial | wc -l`
pythonsmbus=`sudo dpkg-query -l | grep python-smbus | wc -l`
pythonjinja2=`sudo dpkg-query -l | grep python-jinja2 | wc -l` 
pythonxmltodict=`sudo dpkg-query -l | grep python-xmltodict | wc -l` 
pythonpsutil=`sudo dpkg-query -l | grep python-psutil | wc -l` 
pythonpip=`sudo dpkg-query -l | grep python-pip | wc -l`
i2ctools=`sudo dpkg-query -l | grep i2c-tools | wc -l`

echo " "
echo " "
echo "::: PIco UPS HV3.0A removal"
echo "------------------------------------------------------------------------"
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
	sudo rm -rf /home/pi/pico_menu_option.conf	
	exit
else
	echo "-> Script has been executed as root"	
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
	sudo rm -rf /home/pi/pico_menu_option.conf
	exit	
fi
sleep 1

### Checking if there's a PIco service running
picoserviceactive=`sudo service picofssd status | grep Active | awk {'print $2'}`

if [ "$picoserviceactive" == "active" ] ; then
	echo "- Script detected a previous running PIco service, service stopped"
	sudo service picofssd stop > /dev/null 2>&1
else
	echo "-> Script didn't detect any running PIco service"
	
fi
sleep 1

### Checking if there's a PIco daemon running
picodaemon="/usr/local/bin/picofssd"
if [ -f $picodaemon ] ; then
	echo "- Script detected a PIco daemon, daemon removed"
	sudo rm -rf /usr/local/bin/picofssd > /dev/null 2>&1
else
	echo "-> Script didn't detect any PIco daemon"	
fi	
sleep 1

### Checking if there's a PIco init file loaded
picoinit="/etc/init.d/picofssd"	
if [ -f $picoinit ] ; then
	echo "- Script detected a previous PIco init file, init file removed"
	sudo rm -rf /etc/init.d/picofssd > /dev/null 2>&1
else
	echo "-> Script didn't detect any PIco init file"	
fi	
sleep 1

echo " "
echo "::: PIco UPS HV3.0A Removal"
echo "------------------------------------------------------------------------"
echo "Dear $user,"
echo "Next necessities pending for removal aren't PIco related"
echo "There for you will be asked if you want to remove them..."
echo " "

read -p "Press enter to continue..."
echo " "

### Checking if i2c is enabled
raspii2c=`sudo cat /boot/config.txt | grep dtparam=i2c_arm=on`
if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	echo "- Script detected dtparam i2c is enabled"
	
	read -p "==> Disable dtparam i2c! (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	echo "-> dtparam i2c disabled"
	sed -i "s,$raspii2c,#dtparam=i2c_arm=on," /boot/config.txt
	else
	echo "-> dtparam i2c untouched"
	fi
fi	

else
	echo "- Script detected dtparam i2c aleady disabled"
fi

### Checking if serial uart is enabled
raspiuart=`sudo cat /boot/config.txt | grep enable_uart`
if [ "$raspiuart" == "enable_uart=1" ]; then
	echo "- Script detected serial uart is enabled"
	
	read -p "==> Disable serial uart! (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	echo "-> serial uart disabled"
	sed -i "s,$raspiuart,#enable_uart=1," /boot/config.txt
	else
	echo "-> serial uart untouched"	
	fi	

else
	echo "- Script detected serial uart already disabled"
fi

### Checking if rtc dtoverlay module is loaded
rtcmodule=`sudo cat /boot/config.txt | grep dtoverlay=i2c-rtc,ds1307`
if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
	echo "- Script detected rtc dtoverlay is enabled"
	
	read -p "==> Disable rtc dtoverlay! (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	echo "-> rtc dtoverlay disabled"
	sed -i "s,$rtcmodule,#dtoverlay=i2c-rtc,ds1307," /boot/config.txt
	else
	echo "-> rtc dt overlay untouched"	
	fi
	
else
	echo "- Script detected rtc dtoverlay already disabled"
fi

### Checking if i2c-bcm2708 module is loaded
bcmmodule=`sudo cat /etc/modules | grep i2c-bcm2708`
if [ "$bcmmodule" == "i2c-bcm2708" ]; then
	echo "- Script detected bcm2708 module enabled"
	
	read -p "==> Disable bcm2707 module! (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	echo "-> bcm2708 module disabled"
	sed -i "s,$bcmmodule,#i2c-bcm2708," /etc/modules
	else
	echo "-> bcm2708 module untouched"	
	fi
	
else
	echo "- Script detected i2c-bcm2708 module already disabled"
fi

### Checking if i2c-dev module is loaded
i2cmodule=`sudo cat /etc/modules | grep i2c-dev`
if [ "$i2cmodule" == "i2c-dev" ]; then
	echo "- Script detected i2c-dev module enabled"
	
	read -p "==> Disable i2c-dev module! (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	echo "-> i2c-dev module disabled"
	sed -i "s,$i2cmodule,#i2c-dev," /etc/modules
	else
	echo "-> i2c-dev module untouched"	
	fi	
		
else
	echo "- Script detected i2c-dev module already disabled"
fi

if [ $pythonrpigpio -eq 1 ]; then
echo "- python-rpi.gpio installed"
	read -p "==> Remove python-rpi.gpio? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-rpi.gpio -y > /dev/null 2>&1
	echo "-> python-rpi.gpio removed"
	else
	echo "-> python-rpi untouched"	
	fi
fi

if [ $git -eq 3 ]; then
echo "- git installed"
	read -p "==> Remove git? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove git -y > /dev/null 2>&1
	echo "-> git removed"
	else
	echo "-> git untouched"	
	fi
fi

if [ $pythondev -eq 2 ]; then
echo "- python-dev installed"
	read -p "==> Remove python-dev? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-dev -y > /dev/null 2>&1
	echo "-> python-dev removed"
	else
	echo "-> python-dev untouched"	
	fi
else
	echo "-> python-dev already removed"		
fi

if [ $pythonserial -eq 1 ]; then
echo "- python-serial installed"
	read -p "==> Remove python-serial? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-serial -y > /dev/null 2>&1
	echo "-> python-serial removed"	
	else
	echo "-> python-serial untouched"	
	fi
else
	echo "-> python-serial already removed"		
fi

if [ $pythonsmbus -eq 1 ]; then
echo "- python-smbus installed"
	read -p "==> Remove python-smbus? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-smbus -y > /dev/null 2>&1
	echo "-> python-smbus removed"
	else
	echo "-> python-smbus untouched"	
	fi
else
	echo "-> python-smbus already removed"		
fi

if [ $pythonjinja2 -eq 1 ]; then
echo "- python-jinja2 installed"
	read -p "==> Remove python-jinja2? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-jinja2 -y > /dev/null 2>&1
	echo "-> python-jinja2 removed"
	else
	echo "-> python-jinja2 untouched"	
	fi
else
	echo "-> python-jinja2 already removed"		
fi

if [ $pythonxmltodict -eq 1 ]; then
echo "- python-xmltodict installed"
	read -p "==> Remove python-xmltodict? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-xmltodict -y > /dev/null 2>&1
	echo "-> python-xmltodict removed"
	else
	echo "-> python-xmltodict untouched"	
	fi
else
	echo "-> python-xmltodict already removed"		
fi

if [ $pythonpsutil -eq 1 ]; then
echo "8. python-psutil installed"
	read -p "==> Remove python-psutil? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-psutil -y > /dev/null 2>&1
	echo "-> python-psutil removed"	
	else
	echo "-> python-psutil untouched"	
	fi
else
	echo "-> python-psutil already removed"		
fi

if [ $pythonpip -eq 1 ]; then
echo "- python-pip installed"
	read -p "==> Remove python-pip? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove python-pip -y > /dev/null 2>&1
	echo "-> python-pip removed"	
	else
	echo "-> python-pip untouched"	
	fi
else
	echo "-> python-pip already removed"		
fi

if [ $i2ctools -eq 1 ]; then
echo "- i2c-tools installed"
	read -p "==> Remove i2c-tools? (y/n)?" CONT
	if [ "$CONT" = "y" ]; then
	sudo apt-get remove i2c-tools -y > /dev/null 2>&1
	else
	echo "-> i2c-tools untouched"	
	fi
else
	echo "-> i2c-tools already removed"		
fi
sleep 1

### Cleaning up
	echo " "
	echo "::: Cleaning up!"
	echo "------------------------------------------------------------------------"
	echo "-> This could take a awhile"	
	echo "-> Please Standby!"
	echo " "	
	echo "- sudo apt-get clean"
	sudo apt-get clean > /dev/null 2>&1
	echo "- sudo apt-get autoremove"	
	sudo apt-get autoremove -y > /dev/null 2>&1
	echo " "
	sudo rm -rf /home/pi/pico_menu_option.conf
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
sleep 15
sudo rm -rf /home/pi/pico_menu_option.conf
sudo reboot
fi ### end menu option 2

#######################################################################################################
### MENU OPTION 3: PIco UPS HV3.0A quit
#######################################################################################################
	
if [ "$menu_option" == "menu_option=3" ]; then
echo " "
echo " "	
echo "::: PIco UPS HV3.0A Installer Terminated"
echo "---------------------------------------------------"
echo " Thx $user for using PIco HV3.0A Installer"
echo " Installer terminated!"
echo " "	
sudo rm -rf /home/pi/pico_menu_option.conf	
fi ### end menu option 3	