#!/bin/bash

###############################################################################################################################################################

### pico_installer.sh
### @author		: Siewert Lameijer
### @since		: 21-3-2017
### @updated	: 1-8-2017
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
"

		echo "
		 ___           _        _ _           
		|_ _|_ __  ___| |_ __ _| | | ___ _ __ 
		 | ||  _ \/ __| __/ _  | | |/ _ \  __|
		 | || | | \__ \ || (_| | | |  __/ |   
		|___|_| |_|___/\__\__ _|_|_|\___|_|   
											 
		"
	user=`whoami`
	dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

### PIco UPS HV3.0A installer script necessities check
	echo "::: PIco UPS HV3.0A Installer Script Necessities Check"
	echo "------------------------------------------------------------------------"
	echo " "

### Checking if script is executed as root
if [[ $EUID -ne 0 ]]; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Script must be executed as root"
	echo " Install script terminated!"
	echo " "
	exit 0
else
	echo " -> Script executed as root"
	sleep 1	
fi

### Checking free space available
	freespacecheck=`df -k | grep "root" | awk '{print $4}'`
	freespacefriendly=`df -h | grep "root" | awk '{print $4}'`
if [ $freespacecheck -lt 299040 ] ; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Necessities Free Space"
	echo "------------------------------------------------------------------------"
	echo " Dear $user,"
	echo " Looks like your sd-card doesn't have enough free space"
	echo " You need at least 300Mb of free space in order to install all necessities"
	echo " At the moment you have $freespacefriendly left"
	echo " Please extend your filesystem or get a bigger sd-card"
	echo " "
	echo " Install script terminated!"
	echo " "
	exit 0
else
	echo " -> Enough freespace: you have at least $freespacefriendly left"
	sleep 1	
fi

### PIco UPS HV3.0A installer script installing necessities
	grep=`dpkg-query -W -f='${Status}' grep 2>/dev/null | grep -c "ok installed"`
	lsbrelease=`dpkg-query -W -f='${Status}' lsb-release 2>/dev/null | grep -c "ok installed"`
	unzipper=`dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed"`

if [ $grep -ne 1 ] || [ $lsbrelease -ne 1 ] || [ $unzipper -ne 1 ] ; then
	echo " "
	echo "::: PIco UPS HV3.0A Installer Script Necessities Missing"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Dear $user,"
	echo " Some packages are missing which are needed by the installer script"
	echo " Would you like to install them and continue the installer script?"
	echo " "
	echo " Missing Packages:"
	if [ $grep -ne 1 ] ; then
	echo " -> grep is missing"
	fi
	if [ $lsbrelease -ne 1 ] ; then
	echo " -> lsb-release is missing"
	fi
	if [ $unzipper -ne 1 ] ; then
	echo " -> unzip is missing"
	fi

	read -p " Continue? (y/n)" CONT
	if [ "$CONT" = "y" ]; then

	if [ $grep -ne 1 ] || [ $lsbrelease -ne 1 ] || [ $unzipper -ne 1 ] ; then
	echo " "
	echo "::: sourcelist update"
	echo "------------------------------------------------------------------------"
	echo " -> Executing apt-get update"
	echo " -> This could take a awhile"
	echo " -> Please Standby!"
	apt-get update > /dev/null 2>&1
	echo " "
	echo " -> Sourcelist updated!"
	fi

	echo " "
	if [ $grep -ne 1 ]; then
	echo " -> installing grep package"
	apt-get install -y grep > /dev/null 2>&1
	fi

	if [ $lsbrelease -ne 1 ]; then
	echo " -> installing lsb-release package"
	apt-get install -y lsb-release > /dev/null 2>&1
	fi

	if [ $unzipper -ne 1 ]; then
	echo " -> installing unzip package"
	apt-get install -y unzip > /dev/null 2>&1
	fi

else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A Installer"
	echo " Install script terminated!"
	echo " "
	exit 0
	fi
fi

### Checking if OS version matches preferences
	release=`/usr/bin/lsb_release -s -d`
if [ "$release" != "Raspbian GNU/Linux 8.0 (jessie)" ]; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Installer is intended for Raspbian GNU/Linux 8.0 (jessie)"
	echo " Instal script detected you are using $release"
	echo " "
	echo " Install script terminated!"
	echo " "
	exit 0
else
	echo " -> Detected a compatible version of $release"
	sleep 1	
fi

### Checking if RPi version matches preferences
	rpiversion=`cat /proc/device-tree/model`
if [ "$rpiversion" != "Raspberry Pi 3 Model B Rev 1.2" ]; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Installer is intended for Raspberry Pi 3 Model B Rev 1.2"
	echo " Install script detected you are using $rpiversion"
	echo " Install script terminated!"
	echo " "
	exit 0
else
	echo " -> Detected a compatible $rpiversion"
	sleep 1	
fi

### Checking if kernel version matches preferences
	function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
	kernel_version=$(uname -r | /usr/bin/cut -c 1-6)

if [ $(version $kernel_version) -ge $(version "4.1") ] ; then
	echo " -> Detected a compatible kernel version $kernel_version"
	sleep 1	
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Installer is intended for kernel version 4.1 or higher"
	echo " Install script detected you are using $kernel_version"
	echo " If you want to use this script then make sure you update your kernel"
	echo " By conducting apt-get update && apt-get dist-upgrade..."
	echo " "
	echo " Install script terminated!"
	echo " "
	exit 0
fi

### Checking for a working internet connection
if ping -c 1 google.com >> /dev/null 2>&1; then
	echo " -> Detected a working internet connection"
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Installer scripts needs a working internet connection"
	echo " please make sure your internet connection is working"
	echo " "
	echo " Install script terminated!"
	echo " "
	exit 0
fi

#######################################################################################################
### PIco UPS HV3.0A install menu beginning
#######################################################################################################
	echo " "
	echo "::: PIco UPS HV3.0A Install Script MainMenu"
	echo "------------------------------------------------------------------------"
	echo " "
while true
do
options=("Install - PIco HV3.0A" "Remove  - PIco HV3.0A" "Status  - PIco HV3.0A" "Upgrade - PIco HV3.0A" "Config - PIco HV3.0A" "Quit")
COLUMNS=12

select opt in "${options[@]}"

do
case $opt in
"Install - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 1: PIco UPS HV3.0A Installation START
#######################################################################################################
	clear
	echo "::: PIco UPS HV3.0A Installer"
	echo "------------------------------------------------------------------------"
	echo " Welcome $user,"
	echo " You are about to install all necessities for your PIco HV3.0A UPS series"
	echo " There are some precautions and necessities to install"
	echo " Most of them are done by the install script"
	echo " Below a list with precautions you've to take care of"
	echo " "
	echo " Precautions:"
	echo " 1. Install your PIco UPS board before continuing"
	echo " 2. This script is only intended for Raspberry Pi 3 Model B Rev 1.2"
	echo " 3. Use a clean Rasbian Jessie 8.0 installation"
	echo "    Or a installation which hasn't seen a previously installed PIco daemon "
	echo " 4. Compatible 4.1 kernel or higher"
	echo " 5. Preflashed PIco firmware 0x30 or higher"
	echo " 6. Set correct timezone in raspi-config"
	echo " 7. It's advised to make a backup of your sdcard first before continuing"
	echo " "
	echo " Disclaimer:"
	echo " I don't take any responsibility if your OS, Rpi or PIco board gets broken"
	echo " You are using this script on your own responsibility!!!"
	echo " "
	read -p " Continue? (y/n)" CONT
if [ "$CONT" = "y" ]; then

	clear
		
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A Installer"
	echo " "
	echo " Install script terminated!"
	echo " "
	break
fi

	echo " "
	echo "::: PIco UPS HV3.0A Precautions Check"
	echo "------------------------------------------------------------------------"

### Checking if there's a PIco service active
	picoserviceactive=`service picofssd status | grep Active | awk {'print $2'}`

if [ "$picoserviceactive" == "active" ] ; then
	echo " -> Script detected a active PIco service"
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " As there is a daemon active"
	echo " As advised you should use this installer on a clean Rasbian 8.0 jessie clean/fresh install"
	echo " You could use the removal menu option to remove all necessities"
	echo " Or use a fresh Rasbian 8.0 jessie installation"
	echo " "
	echo " Install script terminated!"
	break
else
	echo " -> no PIco service active, step skipped"
	sleep 1
fi

### Checking if there's a PIco daemon active
	picodaemon="/usr/local/bin/picofssd"
if [ -f $picodaemon ] ; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " Script found some previous PIco UPS leftovers"
	echo " You could use the removal menu option to remove all necessities"
	echo " Or use a fresh Rasbian 8.0 jessie installation"
	echo " "
	echo " Install script terminated!"
	echo " "
	break
else
	echo " -> no PIco daemon detected, step skipped"
	sleep 1
fi

### Checking if there's a PIco init file loaded
	picoinit="/etc/init.d/picofssd"
if [ -f $picoinit ] ; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " Script found some previous PIco UPS leftovers"
	echo " You could use the Removal menu option to remove all necessities"
	echo " Or use a fresh Rasbian 8.0 jessie installation"
	echo " "
	echo " Install script terminated!"
	echo " "
	break
else
	echo " -> no PIco init file detected, step skipped"
	sleep 1
fi

### Checking if there are other previous PIco leftovers
	picofile1="/etc/pimodules/picofssd"
	picofile2="/usr/local/bin/picofssdxmlconfig"
	picofile3="/usr/local/lib/python2.7/dist-packages/pimodules-0.1dev.egg-info"
	picofile4="/usr/local/lib/python2.7/dist-packages/pimodules/picofssd-0.1dev-py2.7.egg-info"
	picofile5="/etc/default/picofssd"
if [ -f $picofile1 ] || [ -f $picofile2 ] || [ -f $picofile3 ] || [ -f $picofile4 ] || [ -f $picofile5 ]; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you already installed a PIco daemon"
	echo " Script found some previous PIco UPS leftovers"
	echo " You could use the Removal menu option to remove all necessities"
	echo " Or use a fresh Rasbian 8.0 jessie installation"
	echo " "
	echo " Install script terminated!"
	echo " "
	break
else
	echo " -> no PIco leftovers found, step skipped"
	sleep 1
fi

### Checking if i2c is enabled
	raspii2c=`cat /boot/config.txt | grep dtparam=i2c_arm=on`
if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	echo " -> dtparam=i2c_arm already enabled, step skipped"
elif [ "$raspii2c" == "#dtparam=i2c_arm=on" ]; then
	echo " -> dtparam=i2c_arm enabled"
	sed -i "s,$raspii2c,dtparam=i2c_arm=on," /boot/config.txt
else
	echo " -> dtparam=i2c_arm enabled"
	sh -c "echo 'dtparam=i2c_arm=on' >> /boot/config.txt"
fi
	sleep 1

### Checking if serial uart is enabled
	raspiuart=`cat /boot/config.txt | grep enable_uart`
if [ "$raspiuart" == "enable_uart=1" ]; then
	echo " -> serial uart already enabled, step skipped"
elif [ "$raspiuart" == "#enable_uart=1" ]; then
	echo " -> serial uart enabled"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
elif [ "$raspiuart" == "#enable_uart=0" ]; then
	echo " -> serial uart enabled"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
elif [ "$raspiuart" == "enable_uart=0" ]; then
	echo " -> serial uart enabled"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
else
	echo " -> serial uart enabled"
	sh -c "echo 'enable_uart=1' >> /boot/config.txt"
fi
sleep 1

### Checking for old rtc module load statement
	rtcmoduleold=`cat /etc/modules | grep rtc-ds1307`
	rtcmoduleold2=`cat /etc/rc.local | grep echo`
if [ $(version $kernel_version) -lt $(version "4.3") ] ; then
	if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
		echo " -> old kernel rtc module already enabled, step skipped"
	elif [ "$rtcmoduleold" == "#rtc-ds1307" ]; then
		echo " -> old kernel rtc module enabled"
		sed -i "s,$rtcmoduleold,rtc-ds1307," /etc/modules
	else
		echo " -> old kernel rtc module enabled"
		sh -c "echo 'rtc-ds1307' >> /etc/modules"
	fi
		sleep 1

### Checking for old kernel rtc statement in rc.local
	if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
		echo " -> old kernel rtc rc.local statement already enabled, step skipped"
	elif [ "$rtcmoduleold2" == "#echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then 
		echo " -> old kernel rtc rc.local statement enabled"
		sed -i "s,$rtcmoduleold2,echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &," /etc/rc.local
	else
		echo " -> old kernel rtc rc.local statement enabled"
		sed -i 's/\exit 0//g' /etc/rc.local
		echo "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &"  >> /etc/rc.local
		sh -c "echo 'exit 0' >> /etc/rc.local"
	fi
else
	if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
		echo " -> old kernel rtc module detected, module disabled"
		sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules
	else
		echo " -> no old kernel rtc module statement detected, step skipped"
	fi
		sleep 1

### Checking for old kernel rtc statement in rc.local
	if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
		echo " -> old kernel rtc rc.local statement detected, statement disabled"
		sed -i "s,$rtcmoduleold2,#echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &," /etc/rc.local
	else
		echo " -> no old kernel rtc rc.local statement, step skipped"
	fi
		sleep 1

### Checking if rtc dtoverlay module is loaded
	rtcmodule=`cat /boot/config.txt | grep dtoverlay=i2c-rtc,ds1307`
	if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
		echo " -> dtoverlay=i2c-rtc already enabled, step skipped"
	elif [ "$rtcmodule" == "#dtoverlay=i2c-rtc,ds1307" ]; then
		echo " -> dtoverlay=i2c-rtc enabled"
		sed -i -e 's/#dtoverlay=i2c-rtc,ds1307/dtoverlay=i2c-rtc,ds1307/g' /boot/config.txt
	else
		echo " -> dtoverlay=i2c-rtc enabled"
		sh -c "echo 'dtoverlay=i2c-rtc,ds1307' >> /boot/config.txt"
	fi
		sleep 1

fi

### Checking if i2c-bcm2708 module is loaded
	bcmmodule=`cat /etc/modules | grep i2c-bcm2708`
if [ "$bcmmodule" == "i2c-bcm2708" ]; then
	echo " -> i2c-bcm2708 module already enabled, step skipped"
elif [ "$bcmmodule" == "#i2c-bcm2708" ]; then
	echo " -> i2c-bcm2708 module enabled"
	sed -i "s,$bcmmodule,i2c-bcm2708," /etc/modules
else
	echo " -> i2c-bcm2708 module enabled"
	sh -c "echo 'i2c-bcm2708' >> /etc/modules"
fi
	sleep 1

### Checking if i2c-dev module is loaded
	i2cmodule=`cat /etc/modules | grep i2c-dev`
if [ "$i2cmodule" == "i2c-dev" ]; then
	echo " -> i2c-dev module already enabled, step skipped"
elif [ "$i2cmodule" == "#i2c-dev" ]; then
	echo " -> i2c-dev module enabled"
	sed -i "s,$i2cmodule,i2c-dev," /etc/modules
else
	echo " -> i2c-dev module enabled"
	sh -c "echo 'i2c-dev' >> /etc/modules"
fi
	sleep 1

### Checking if hciuart service is loaded
	uartstatus=`service hciuart status | grep Active | awk {'print $2'}`
if [ "$uartstatus" == "active" ]; then
	echo " -> hciuart service already active, step skipped"
	sleep 1
else
	echo " -> enabled hciuart service"
	systemctl enable hciuart > /dev/null 2>&1
fi


### PIco UPS HV3.0A necessities check and installation
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

if [ $pythonrpigpio -eq 0 ] || [ $git -eq 0 ] || [ $pythondev -eq 0 ] || [ $pythonserial -eq 0 ] || [ $pythonsmbus -eq 0 ] || [ $pythonjinja2 -eq 0 ] || [ $pythonxmltodict -eq 0 ] || [ $pythonpsutil -eq 0 ] || [ $pythonpip -eq 0 ] || [ $i2ctools -eq 0 ]; then
	echo " "
	echo "::: $release sourcelist update"
	echo "------------------------------------------------------------------------"
	echo " -> Executing apt-get update"
	echo " -> This could take a awhile"
	echo " -> Please Standby!"
	sleep 1
	apt-get update > /dev/null 2>&1
	echo " "
	echo " -> Sourcelist updated!"
	sleep 1
fi

	echo " "
	echo "::: $release and PIco UPS HV3.0A necessities check"
	echo "------------------------------------------------------------------------"

	if [ $pythonrpigpio -eq 1 ]; then
		echo " -> python-rpi.gpio package already installed, step skipped"
	sleep 1   
	else
		echo " -> installing python-rpi.gpio package"
		apt-get install -y python-rpi.gpio > /dev/null 2>&1
	fi

	if [ $git -eq 1 ]; then
		echo " -> git package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing git package"
		apt-get install -y git > /dev/null 2>&1
	fi

	if [ $pythondev -eq 1 ]; then
		echo " -> python-dev package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-dev package"
		apt-get install -y python-dev > /dev/null 2>&1
	fi

	if [ $pythonserial -eq 1 ]; then
		echo " -> python-serial package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-serial package"
		apt-get install -y python-serial > /dev/null 2>&1
	fi

	if [ $pythonsmbus -eq 1 ]; then
		echo " -> python-smbus package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-smbus package"
		apt-get install -y python-smbus > /dev/null 2>&1
	fi

	if [ $pythonjinja2 -eq 1 ]; then
		echo " -> python-jinja2 package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-jinja2 package"
		apt-get install -y python-jinja2 > /dev/null 2>&1
	fi

	if [ $pythonxmltodict -eq 1 ]; then
		echo " -> python-xmltodict package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-xmltodict package"
		apt-get install -y python-xmltodict > /dev/null 2>&1
	fi

	if [ $pythonpsutil -eq 1 ]; then
		echo " -> python-psutil package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-psutil package"
		apt-get install -y python-psutil > /dev/null 2>&1
	fi

	if [ $pythonpip -eq 1 ]; then
		echo " -> python-pip package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing python-pip package"
		apt-get install -y python-pip > /dev/null 2>&1
	fi

	if [ $i2ctools -eq 1 ]; then
		echo " -> i2c-tools package already installed, step skipped"
		sleep 1   
	else
		echo " -> installing i2c-tools package"
		apt-get install -y i2c-tools > /dev/null 2>&1
	fi

### PIco UPS HV3.0A daemon installation
	picogitclone="PiModules/README.md"
	echo " "
	echo "::: Installing PIco UPS HV3.0A daemons"
	echo "------------------------------------------------------------------------"

	if [ -f $picogitclone ] ; then
		echo " -> cloning PiModules from git"
		rm -rf PiModules
		git clone https://github.com/Siewert308SW/PiModules.git> /dev/null 2>&1
	else
		echo " -> cloning PiModules from git"
		git clone https://github.com/Siewert308SW/PiModules.git> /dev/null 2>&1
	fi

		echo " -> installing PIco mail daemon"
		cd ./PiModules/code/python/package
		python setup.py install > /dev/null 2>&1
		echo " -> installing PIco fssd daemon"
		cd ../upspico/picofssd
		python setup.py install > /dev/null 2>&1
		echo " -> set picofssd defaults to update-rc.d"
		update-rc.d picofssd defaults > /dev/null 2>&1
		echo " -> enabling picofssd daemon"
		update-rc.d picofssd enable > /dev/null 2>&1
		echo " -> starting picofssd daemon"
		/etc/init.d/picofssd start > /dev/null 2>&1
		cd $dir
		rm -rf PiModules
		sleep 1

### PIco UPS HV3.0A installation finished
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Install Script Finished"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A Installer"
	echo " "
	echo " PIco UPS HV3.0a installation finished"
	echo " If no errors occured then everything should be up and active"
	echo " "
	echo " System will be rebooted in 15 seconds to let every changed be activated and loaded"
	echo " "
	sleep 15
	reboot
	;;

"Remove  - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 2: PIco UPS HV3.0A removal START
#######################################################################################################
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
	picofile1="/etc/pimodules/picofssd"
	picofile2="/usr/local/bin/picofssdxmlconfig"
	picofile3="/usr/local/lib/python2.7/dist-packages/pimodules-0.1dev.egg-info"
	picofile4="/usr/local/lib/python2.7/dist-packages/pimodules/picofssd-0.1dev-py2.7.egg-info"
	picofile5="/etc/default/picofssd"
	raspii2c=`cat /boot/config.txt | grep dtparam=i2c_arm=on`
	raspiuart=`cat /boot/config.txt | grep enable_uart`
	rtcmodule=`cat /boot/config.txt | grep dtoverlay=i2c-rtc,ds1307`
	bcmmodule=`cat /etc/modules | grep i2c-bcm2708`
	rtcmoduleold=`cat /etc/modules | grep rtc-ds1307`
	rtcmoduleold2=`cat /etc/rc.local | grep echo`
	i2cmodule=`cat /etc/modules | grep i2c-dev`

	clear	
if [ "$raspii2c" == "dtparam=i2c_arm=on" ] || [ "$raspiuart" == "enable_uart=1" ] || [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ] || [ "$bcmmodule" == "i2c-bcm2708" ] || [ "$rtcmoduleold" == "rtc-ds1307" ] || [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ] || [ "$i2cmodule" == "i2c-dev" ] || [ $pythonrpigpio -eq 1 ] || [ $git -eq 1 ] || [ $pythondev -eq 1 ] || [ $pythonserial -eq 1 ] || [ $pythonsmbus -eq 1 ] || [ $pythonjinja2 -eq 1 ] || [ $pythonxmltodict -eq 1 ] || [ $pythonpsutil -eq 1 ] || [ $pythonpip -eq 1 ] || [ $i2ctools -eq 1 ] || [ -f $picofile1 ] || [ -f $picofile2 ] || [ -f $picofile3 ] || [ -f $picofile4 ] || [ -f $picofile5 ]; then

	echo " "
	echo "::: PIco UPS HV3.0A Removal"
	echo "------------------------------------------------------------------------"
	echo " Dear $user,"
	echo " You chose to remove your PIco HV3.0a UPS together with its necessities"
	echo " Some necessities aren't PIco related and could in use by other resources"
	echo " There for you will be asked if you want to remove them..."
	echo " "

	read -p " Continue? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	echo " "
	else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Removal Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A removal script"
	echo " "
	echo " removal script terminated!"
	echo " "
	break
	fi

### PIco UPS HV3.0A Daemons and Modules Removal	
	echo "::: PIco UPS HV3.0A Uninstalling Packages, daemons and modules"
	echo "------------------------------------------------------------------------"
	
### Checking if there's a PIco service active
	picoserviceactive=`service picofssd status | grep Active | awk {'print $2'}`

if [ "$picoserviceactive" == "active" ] ; then
	echo " -> PIco service stopped"
	service picofssd stop > /dev/null 2>&1
else
	echo " -> no PIco service detected, step skipped"
	sleep 1
fi


### Checking if there's a PIco daemon active
	picodaemon="/usr/local/bin/picofssd"
if [ -f $picodaemon ] ; then
	echo " -> PIco daemon removed"
	rm -rf /usr/local/bin/picofssd > /dev/null 2>&1
else
	echo " -> no PIco daemon detected, step skipped"
fi
sleep 1


### Checking if there's a PIco init file loaded
picoinit="/etc/init.d/picofssd"
if [ -f $picoinit ] ; then
	echo " -> PIco init file removed"
	rm -rf /etc/init.d/picofssd > /dev/null 2>&1
else
	echo " -> no PIco init file detected, step skipped"
	fi
sleep 1

### Checking if i2c is enabled
if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	read -p " -> disable dtparam=i2c_arm? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i "s,$raspii2c,#dtparam=i2c_arm=on," /boot/config.txt
	fi
else
	echo " -> dtparam=i2c_arm already disabled, step skipped"
	sleep 1
fi

### Checking if serial uart is enabled
if [ "$raspiuart" == "enable_uart=1" ]; then
	read -p " -> disable serial uart? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i "s,$raspiuart,#enable_uart=1," /boot/config.txt
	fi
else
	echo " -> serial uart already disabled, step skipped"
	sleep 1
fi

### Checking if rtc dtoverlay module is loaded
if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
	read -p " -> disable dtoverlay=i2c-rtc? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i -e 's/dtoverlay=i2c-rtc/#dtoverlay=i2c-rtc/g' /boot/config.txt
	fi
else
	echo " -> dtoverlay=i2c-rtc already disabled, step skipped"
	sleep 1
fi


### Checking if i2c-bcm2708 module is loaded
if [ "$bcmmodule" == "i2c-bcm2708" ]; then
	read -p " -> disable i2c-bcm2708 module? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i "s,$bcmmodule,#i2c-bcm2708," /etc/modules
	fi
else
	echo " -> i2c-bcm2708 module already disabled, step skipped"
	sleep 1
fi

### Checking for old rtc module load statement
if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
	read -p " -> disable old kernel rtc module? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules
	fi
else
	echo " -> old kernel rtc module already disabled, step skipped"
	sleep 1
fi

### Checking for old rtc load statement in rc.local
if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
	read -p " -> disable old kernel rtc statement? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i -e 's/echo ds1307 0x68/#echo ds1307 0x68/g' /etc/rc.local
	fi
else
	echo " -> old kernel rtc statement in rc.local already disabled, step skipped"
	sleep 1
fi

### Checking if i2c-dev module is loaded
if [ "$i2cmodule" == "i2c-dev" ]; then
	read -p " -> disable i2c-dev module? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		sed -i "s,$i2cmodule,#i2c-dev," /etc/modules
	fi
else
	echo " -> i2c-dev module already disabled, step skipped"
	sleep 1
fi

### PIco UPS HV3.0A Package Removal
	echo " "
	echo "::: PIco UPS HV3.0A Package Removal"
	echo "------------------------------------------------------------------------"
if [ $pythonrpigpio -eq 1 ]; then
	read -p " -> remove python-rpi.gpio package ? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		apt-get remove python-rpi.gpio -y > /dev/null 2>&1
	fi
else
	echo " -> python-rpi package already removed, step skipped"
	sleep 1
fi

###
if [ $git -eq 1 ]; then
	read -p " -> remove git package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		apt-get remove git -y > /dev/null 2>&1
	fi
else
	echo " -> git package already removed, step skipped"
	sleep 1
fi

###
if [ $pythondev -eq 1 ]; then
	read -p " -> remove python-dev package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		apt-get remove python-dev -y > /dev/null 2>&1
	fi
else
	echo " -> python-dev package already removed, step skipped"
	sleep 1
fi

###
if [ $pythonserial -eq 1 ]; then
	read -p " -> remove python-serial package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	apt-get remove python-serial -y > /dev/null 2>&1
	fi
else
	echo " -> python-serial package already removed, step skipped"
	sleep 1
fi

###
if [ $pythonsmbus -eq 1 ]; then
	read -p " -> remove python-smbus package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	apt-get remove python-smbus -y > /dev/null 2>&1
	fi
else
	echo " -> python-smbus package already removed, step skipped"
	sleep 1
fi

###
if [ $pythonjinja2 -eq 1 ]; then
	read -p " -> remove python-jinja2 package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	apt-get remove python-jinja2 -y > /dev/null 2>&1
	fi
else
	echo " -> python-jinja2 package already removed, step skipped"
	sleep 1
fi

###
if [ $pythonxmltodict -eq 1 ]; then
	read -p " -> remove python-xmltodict package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		apt-get remove python-xmltodict -y > /dev/null 2>&1
	fi
else
	echo " -> python-xmltodict package already removed, step skipped"
	sleep 1
fi

###
if [ $pythonpsutil -eq 1 ]; then
	read -p " -> remove python-psutil package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		apt-get remove python-psutil -y > /dev/null 2>&1
	fi
else
	echo " -> python-psutil package already removed, step skipped"
	sleep 1
fi

###
if [ $pythonpip -eq 1 ]; then
	read -p " -> remove python-pip package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	apt-get remove python-pip -y > /dev/null 2>&1
	fi
else
	echo " -> python-pip package already removed, step skipped"
	sleep 1
fi


if [ $i2ctools -eq 1 ]; then
	read -p " -> remove i2c-tools package? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		apt-get remove i2c-tools -y > /dev/null 2>&1
	fi
else
	echo " -> i2c-tools package already removed, step skipped"
	sleep 1
fi

### PIco UPS HV3.0A Removal Cleaning up
	echo " "
	echo "::: PIco UPS HV3.0A Removal Cleanup"
	echo "------------------------------------------------------------------------"
	echo " -> This could take a awhile"
	echo " -> Please Standby!"
	echo " "
	rm -rf /etc/pimodules
	rm -rf /usr/local/bin/picofssdxmlconfig
	rm -rf /usr/local/lib/python2.7/dist-packages/pimodules-0.1dev.egg-info
	rm -rf /usr/local/lib/python2.7/dist-packages/pimodules
	rm -rf /etc/default/picofssd
	apt-get autoremove -y > /dev/null 2>&1
	echo " Done..."
	sleep 1


### PIco UPS HV3.0A removal finished
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Removal Script Finished"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A removal script"
	echo " "
	echo " PIco UPS HV3.0a removal finished"
	echo " If no errors occured then everything has been removed or disabled"
	echo " After the system has been rebooteded then your able to shutdown the system and remove the PIco board"
	echo " "
	echo " System will be rebooted in 15 seconds..."
	echo " "
	sleep 15
	reboot
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Removal Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A removal script"
	echo " "
	echo " PIco UPS HV3.0a removal terminated"
	echo " The removal tools didn't remove or delete anything"
	echo " As it seems you already used this tool or running it on a clean Jessie installation"
	echo " "
	echo " Removal script finished and terminated..."
	echo " "
	break
fi
	;;
	
"Status  - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 3: PIco UPS HV3.0A Status Script START
#######################################################################################################
clear

	picoserviceactive=`service picofssd status | grep Active | awk {'print $2'}`
if [ "$picoserviceactive" != "active" ] ; then
	clear
	echo " "
	echo "::: UPS PIco HV3.0A Status Script"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " -> PIco Firmware..........: n/a"
	echo " -> PIco Bootloader........: n/a"
	echo " -> PIco PCB Version.......: n/a"
	echo " -> PIco BAT Version.......: n/a"
	echo " "
	echo " -> No PIco service or daemon active, please install first..."
	echo "------------------------------------------------------------------------"
	echo " "
else

	picostatus="pico_status/pico_status.py"
	if [ -f $picostatus ] ; then
	chmod +x pico_status/pico_status.py
	python pico_status/pico_status.py
	else
	git clone https://github.com/Siewert308SW/pico_status > /dev/null 2>&1
	chmod +x pico_status/pico_status.py
	python pico_status/pico_status.py
	fi
	if [ -f $picostatus ] ; then
	rm -rf pico_status/
	fi
fi
break
;;

"Upgrade - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 4: PIco UPS HV3.0A Firmware Upgrade START
#######################################################################################################
	clear
	picobtreboot="pico_bt_reboot.conf"
	picouartreboot="pico_uart_reboot.conf"
	picoreboot="pico_reboot.conf"
	picogettystatus="pico_getty_status.conf"
	picofufolder="pico_firmware_master/picofu.py"
	
	echo "::: PIco UPS HV3.0A Firmware update check"
	echo "------------------------------------------------------------------------"
	echo " "
	
### Checking if there's a PIco service active
	picoserviceactive=`service picofssd status | grep Active | awk {'print $2'}`
if [ "$picoserviceactive" == "active" ] ; then
	echo " -> PIco UPS service active"
else
	systemctl start picofssd 2>/dev/null
fi
	sleep 1

if [ "$picoserviceactive" != "active" ] ; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you didn't install your PIco unit"
	echo " Or some how the PIco service can't be activated"
	echo " Please execute a full installation before trying to upgrade"
	echo " "
	echo " Upgrade script terminated!"
	break
else
	echo " -> PIco UPS service activated"
	sleep 1
fi

### Checking if PIco is online
picoonline=`i2cget -y 1 0x6b 0x00 | grep -c "0x00"`

if [ $picoonline -eq 1 ]; then
	echo " -> PIco UPS detected"
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like you didn't install your PIco unit"
	echo " Or some how your PIco board can't be detected true i2c"
	echo " Please execute a full installation before trying to upgrade"
	echo " "
	echo " Upgrade script terminated!"
	break
fi

### Checking if there's a PIco update available
if [ -f $picofufolder ] ; then
	echo " -> Downloading PIco firmware collection"
	sleep 1
	rm -rf pico_firmware_master 
	wget http://www.siewert-lameijer.nl/pico_firmware/pico_firmware.zip 2>/dev/null
	echo " -> Unzipping PIco firmware collection"
	unzip -q pico_firmware.zip
	rm -rf pico_firmware.zip
else
	echo " -> Downloading PIco firmware collection"
	wget http://www.siewert-lameijer.nl/pico_firmware/pico_firmware.zip 2>/dev/null
	echo " -> Unzipping PIco firmware collection"	
	unzip -q pico_firmware.zip
	rm -rf pico_firmware.zip
fi

### Checking if there is firmware update
	picoversion=`i2cget -y 1 0x69 0x26 | /usr/bin/cut -d "x" -f 2`
	picoupdatecheck=`ls pico_firmware_master | grep UPS | tail -1 | /usr/bin/cut -d "_" -f 1 | /usr/bin/cut -d "x" -f 2`
	piconewfirmware=`ls pico_firmware_master | grep UPS | tail -1`
if [ $picoupdatecheck -gt $picoversion ]; then
	echo " -> PIco UPS firmware update available"
	echo " "
	echo "::: PIco UPS HV3.0A Firmware Update Available"
	echo "------------------------------------------------------------------------"
	echo " Current version: 0x"$picoversion
	echo " Update version : 0x"$picoupdatecheck

	read -p " Continue upgrading firmware? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	echo " "
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A Upgrade script"
	echo " "
	echo " Upgrade script terminated!"
	echo " "
	if [ -f $picofufolder ] ; then
	rm -rf pico_firmware_master
	rm -rf pico_firmware.zip
fi
	break
fi
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Finished"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Looks like there isn't a update available"
	echo " Could be your PICo board is laready up to date or PiModules didn't release a update yet"
	echo " Or the PIco upgrade script database hasn't been updated yet"
	echo " I would advise you to checkin again later"
	echo " "
	echo " Upgrade script terminated!"
	if [ -f $picofufolder ] ; then
	rm -rf pico_firmware_master
	rm -rf pico_firmware.zip
	fi
	break
fi
sleep 1

### Checking bluetooth (dtoverlay=pi3-disable-bt) is disabled
	btoverlay=`cat /boot/config.txt | grep dtoverlay=pi3-disable-bt`
if [ "$btoverlay" == "dtoverlay=pi3-disable-bt" ]; then
	echo " -> dtoverlay=pi3-disable-bt already set to /boot/config.txt, step skipped"
elif [ "$btoverlay" == "#dtoverlay=pi3-disable-bt" ]; then
	echo " -> dtoverlay=pi3-disable-bt set to /boot/config.txt"
	sed -i "s,$btoverlay,dtoverlay=pi3-disable-bt," /boot/config.txt
	touch $picobtreboot
	touch $picoreboot
else
	echo " -> dtoverlay=pi3-disable-bt set to /boot/config.txt"
	sh -c "echo 'dtoverlay=pi3-disable-bt' >> /boot/config.txt"
	touch $picobtreboot
	touch $picoreboot
fi
	sleep 1

### Checking serial uart (enable_uart=1) is enabled
	raspiuart=`cat /boot/config.txt | grep enable_uart`
if [ "$raspiuart" == "enable_uart=1" ]; then
	echo " -> enable_uart already set to /boot/config.txt, step skipped"
elif [ "$raspiuart" == "#enable_uart=1" ]; then
	echo " -> enable_uart set to /boot/config.txt"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
	touch $picouartreboot
	touch $picoreboot
elif [ "$raspiuart" == "#enable_uart=0" ]; then
	echo " -> enable_uart set to /boot/config.txt"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
	touch $picouartreboot
	touch $picoreboot
elif [ "$raspiuart" == "enable_uart=0" ]; then
	echo " -> enable_uart set to /boot/config.txt"
	sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
	touch $picouartreboot
	touch $picoreboot
else
	echo " -> enable_uart set to /boot/config.txt"
	sh -c "echo 'enable_uart=1' >> /boot/config.txt"
	touch $picouartreboot
	touch $picoreboot
fi
	sleep 1

### Reboot system if uart is enabled or BT is disabled
if [ -f $picoreboot ]; then

	if [ -f $picobtreboot ] ; then
	rebootbttxt="Bluetooth"
	rebootbttxt2="Bluetooth has been temporally disabled"
	fi
	if [ -f $picouartreboot ] ; then
	rebootuarttxt="and Serial Console"
	rebootuarttxt2="And Serial Console has been temporally enabled"
	fi
	echo " "
	echo "::: PIco UPS HV3.0A $rebootbttxt $rebootuarttxt set"
	echo "------------------------------------------------------------------------"
	echo " $rebootbttxt2"
	echo " $rebootuarttxt2"
	echo " It's mandatory otherwise you can't upgrade firmware"
	echo " Your system has to be rebooted so it really gets propperly set"
	echo " After your system has been rebooted then please checkin again to continue upgrading your firmware"
	echo " "
	read -p " Continue rebooting your system? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
	echo " "
	echo "::: PIco UPS HV3.0A System reboot"
	echo "------------------------------------------------------------------------"
	echo " After reboot then please continue the upgrade process"
	echo " System reboot in 10 seconds!"
	echo " "
	rm -rf $picoreboot
	sleep 10
	reboot
	exit 0
else
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A upgrade script"
	echo " Please reboot your system in order to set $rebootbttxt2 $rebootuarttxt2"
	echo " It's mandatory otherwise you can't upgrade firmware"
	echo " After your system has been rebooted then please continue the upgrade process"
	echo " "
	echo " Upgrade script terminated!"
	echo " "

	if [ -f $picofufolder ] ; then
	rm -rf pico_firmware_master
	rm -rf pico_firmware.zip
	fi
	exit 0
	fi
fi

### Checking BT is active
	picobtactive=`systemctl status bluetooth 2>/dev/null`
if [ "$picobtactive" == "active" ] ; then
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A upgrade script"
	echo " Please disable Bluetooth (dtoverlay=pi3-disable-bt)"
	echo " It's mandatory otherwise you can't upgrade firmware"
	echo " If you amended your /boot/config.txt manually then please reboot your system"
	echo " After your system has been rebooted then please continue the upgrade process"
	echo " "
	echo " Upgrade script terminated!"
	echo " "
	exit 0
	if [ -f $picofufolder ] ; then
	rm -rf pico_firmware_master
	rm -rf pico_firmware.zip
	fi
fi

### Checking if getty is active then stop and disable
	gettyserviceactive=`service serial-getty@ttyAMA0.service status | grep Active | awk {'print $2'}`
if [ "$picoserviceactive" == "active" ] ; then
	echo " -> serial-getty@ttyAMA0 active, getty stopped and disabled"
	systemctl stop serial-getty@ttyAMA0.service 2>/dev/null
	systemctl disable serial-getty@ttyAMA0.service 2>/dev/null
	touch $picogettystatus
else
	echo " -> serial-getty@ttyAMA0 not active, step skipped"
	sleep 1	
fi

### Invoking bootloader so it can recieve new firmware
	echo " -> Invoking PIco bootloader"
	i2cset -y 1 0x6b 0x00 0xff
	sleep 5
	echo " -> Starting PIco firmware upgrade"
	cd pico_firmware_master
	python picofu.py -v -f $piconewfirmware
	cd $dir
	rm -rf pico_firmware_master
	rm -rf pico_firmware.zip
	sleep 10

### Checking if getty was active earlier then enable and restart it
if [ -f $picogettystatus ] ; then
	echo " -> serial-getty@ttyAMA0 enabled and restarted"
	systemctl enable serial-getty@ttyAMA0.service 2>/dev/null
	systemctl start serial-getty@ttyAMA0.service 2>/dev/null
	sleep 1 
	rm -rf $picogettystatus
else
	echo " -> serial-getty@ttyAMA0 wasn't active, step skipped"
	sleep 1
fi


### Checking if bluetooth and uart where active earlier then enable and restart it
if [ -f $picobtreboot ] ; then
	if [ "$btoverlay" == "dtoverlay=pi3-disable-bt" ]; then
		echo " -> dtoverlay=pi3-disable-bt disabled in /boot/config.txt"
		sed -i "s,$btoverlay,#dtoverlay=pi3-disable-bt," /boot/config.txt
		rm -rf $picobtreboot
	fi 
fi

if [ -f $picouartreboot ] ; then
	if [ "$raspiuart" == "enable_uart=1" ]; then
		echo " -> enable_uart enabled in /boot/config.txt"
		sed -i "s,$raspiuart,#enable_uart=1," /boot/config.txt
		rm -rf $picouartreboot
	fi 
fi

	if [ -f $picofufolder ] ; then
	rm -rf pico_firmware_master
	rm -rf pico_firmware.zip
	fi

### PIco UPS HV3.0A firmware upgrade finished
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Upgrade Script Finished"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A upgrade script"
	echo " "
	echo " PIco UPS HV3.0a firmware has been upgrade to version 0x"$picoversion
	echo " If no errors occured then everything should be up and running"
	echo " "
	echo " CAUTION: PIco board has been factory reset"
	echo " So if your using a battery other then 450mah then please set your desired battery type after reboot"
	echo " "
	echo " System will be rebooted in 15 seconds"
	echo " "
	echo " Enjoy and have a nice day..."
	echo " "
	sleep 15
	reboot
;;

"Config - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 5: PIco UPS HV3.0A Configuration Script START
#######################################################################################################
	clear
	echo "::: PIco UPS HV3.0A Configuration Script"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A config script"
	echo " "
	echo " Unfortunally this option isn't available yet"
	echo " I'm working on it, as we speak ;-)"
	echo " "
	echo " Enjoy and have a nice day..."
	echo " "
	break
;;

"Quit")
#######################################################################################################
### MENU OPTION 6: PIco UPS HV3.0A Quit
#######################################################################################################
	clear
	echo " "
	echo "::: PIco UPS HV3.0A Installer Script Terminated"
	echo "------------------------------------------------------------------------"
	echo " "
	echo " Thx $user for using PIco HV3.0A install script"
	echo " "
	echo " Install script terminated!"
	echo " "
	exit 0

	;;
	*) echo invalid option;;
		 esac
	 done
	 done
 