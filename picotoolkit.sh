#!/bin/bash
#######################################################################################################

### pico_toolkit.sh
### @author		: Siewert Lameijer
### @since		: 21-3-2017
### @updated	: 1-27-2018
### Script for Installing, removing, configuring your PIco HV3.0a UPS

#### TESTED ON:
# Raspbian Jessie
# Raspbian Stretch
# Minibian
# DietPi
# Ubuntu Mate
# LibreELEC

#######################################################################################################
### Do not edit anything below this line unless your knowing what to do!
#######################################################################################################
	clear

### Set working dir
	cd /tmp

### Get currect user	
	user=`whoami`

### Get working folder
	dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)	
	
### Compatible Raspberry Pi version
	rpicompversion="Raspberry Pi 3 Model B Rev 1.2"

### Free Space minimum
	requiredfreespace="299040"

### Compatible OS Distros
	raspbian="Raspbian"
	ubuntu="Ubuntu"
	libre="LibreELEC"
	
### Variables
	setupvars=/tmp/setupvars.conf

### Set all outputs to lowercase
	lowercase(){
		echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
	}

### Color Codes
	if [ -x /usr/bin/tput ] >/dev/null 2>&1
	  then
		red=$(tput setaf 1)
		green=$(tput setaf 2)
		yellow=$(tput setaf 3)
		blue=$(tput setaf 4)
		purple=$(tput setaf 5)
		cyan=$(tput setaf 6)
		gray=$(tput setaf 7)

		bold=$(tput bold)
		normal=$(tput sgr0)
	  else
		red=
		green=
		yellow=
		blue=
		purple=
		cyan=
		gray=

		bold=
		normal=
	fi

### Check if Raspbian version is DietPi distro	
	releasedistrodietpi=`ls /DietPi 2>/dev/null | grep -c "config.txt"`
	releasedistrolibre=`ls /flash 2>/dev/null | grep -c "config.txt"`	
	if [ $releasedistrodietpi -eq 1 ] ; then
		config="/DietPi/config.txt"
	elif [ $releasedistrolibre -eq 2 ] ; then
		config="/flash/config.txt"		
	else
		config="/boot/config.txt"
	fi

#######################################################################################################
### Function INTRO
#######################################################################################################
function function_intro() {
echo "$green
 ____ ___            _   ___     _______  ___    _      _   _ ____  ____  
|  _ \_ _|___ ___   | | | \ \   / /___ / / _ \  / \    | | | |  _ \/ ___| 
| |_) | |/ __/ _ \  | |_| |\ \ / /  |_ \| | | |/ _ \   | | | | |_) \___ \ 
|  __/| | (_| (_) | |  _  | \ V /  ___) | |_| / ___ \  | |_| |  __/ ___) |
|_|  |___\___\___/  |_| |_|  \_/  |____(_)___/_/   \_\  \___/|_|   |____/ 
$normal"
echo "$green
      .~~.   .~~.
     '. \ ' ' / .'	 $red							  	$red
     : .~.'~'.~. :   $blue _____           _ _  ___ _   $red
     : .~.'~'.~. :   $blue|_   _|__   ___ | | |/ (_) |_ $red
    ~ (   ) (   ) ~  $blue  | |/ _ \ / _ \| |   /| |  _|$red
   ( : '~'.~.'~' : ) $blue  | | (_) | (_) | |   \| | |_ $red
    ~ .~ (   ) ~. ~  $blue  |_|\___/ \___/|_|_|\_\_|\__|$red
     (  : '~' :  )   $green	   							$red
      '~ .~~~. ~'    $green  						    $red
          '~' 											$normal"
}

#######################################################################################################
### Function Credit
#######################################################################################################		  
function function_credit() {
echo ""$yellow"================================================================================="$normal""
echo " "
echo " $cyan[*] $normal PIco HV3.0a UPS Toolkit						     $cyan[*]$normal"
echo " $cyan[*] $normal Version		: 2.0			 			     $cyan[*]$normal"
echo " $cyan[*] $normal Updated		: 27 Jan 2018					     $cyan[*]$normal"
echo " $cyan[*] $normal Created By	: Siewert308SW					     $cyan[*]$normal"
echo " $cyan[*] $normal GitHub		: http://bit.ly/2fkTaGz				     $cyan[*]$normal"
echo " $cyan[*] $normal Dev Thread	: http://bit.ly/2hz7vzT	 			     $cyan[*]$normal"
echo " "
echo ""$yellow"================================================================================="$normal""
}

#######################################################################################################
### Function Exit
#######################################################################################################		  
function function_exit() {
echo " "
echo ""$yellow":::"$normal" PIco HV3.0a Toolkit Terminated"		  
echo ""$yellow"================================================================================="$normal""
echo " "
echo " Thx "$green"$user"$normal" for using PIco HV3.0a toolkit"
echo " "
}

#######################################################################################################
### PIco UPS HV3.0a Installer information
#######################################################################################################

	intro=$(function_intro)
	credit=$(function_credit)
	terminate=$(function_exit)	
	echo "$intro"
	echo "$credit"	

#######################################################################################################
### PIco UPS HV3.0a Checking installer necessities before showing menu
#######################################################################################################

### Checking if script is executed as root
	if [ "$(id -u)" != 0 ] ; then
		echo " [ "$bold"INFO"$normal" ] Script not executed as root 			       		[ "$bold""$red"FALSE"$normal" ]"
	fi

### Checking free space available but only if PIco service isn't active

	picoserviceactive=`systemctl is-active picofssd 2>/dev/null`
	freespacecheck=`df -k | grep "/" | head -1 | awk '{print $4}'`
	freespacefriendly=`df -h | grep "/" | head -1 | awk '{print $4}'`	
	if [ "$picoserviceactive" != "active" ] ; then
	
	if [ $freespacecheck -lt $requiredfreespace ] ; then
		echo " [ "$bold"INFO"$normal" ] Detected $freespacefriendly free space, 300M needed - Please expand your rootfs[ "$bold""$red"FALSE"$normal" ]"	
	fi
	fi
	
### Checking if RPi version matches preferences
	rpiversion=`cat -e /proc/device-tree/model | /usr/bin/cut -f 1 -d '^'`
	if [ "$rpiversion" != "$rpicompversion" ]; then
		echo " [ "$bold"INFO"$normal" ] Detected a non compatible $rpiversion 	[ "$bold""$red"FALSE"$normal" ]"
	fi

### Checking OS matches preferences
	os=`cat /etc/*release 2>/dev/null | grep ^PRETTY_NAME | /usr/bin/cut -f 2 -d '"' | /usr/bin/cut -f 1 -d ' '`
	ospretty=`cat /etc/*release 2>/dev/null | grep ^PRETTY_NAME | /usr/bin/cut -f 2 -d '"'`
	if [ "$os" != "$raspbian" ] && [ "$os" != "$ubuntu" ] && [ "$os" != "$libre" ] ; then
			echo " [ "$bold"INFO"$normal" ] Detected a non compatible $ospretty 	[ "$bold""$red"FALSE"$normal" ]"
	fi

### Checking if kernel version matches preferences
	function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
	kernel_version=$(uname -r | /usr/bin/cut -c 1-6)
	if [ $(version $kernel_version) -lt $(version "4.1") ] ; then
		echo " [ "$bold"INFO"$normal" ] Detected a non compatible $kernel_version kernel 			[ "$bold""$red"FALSE"$normal" ]"
	fi
	sleep 1

### Checking for a working internet connection
	internet=`ping -c 1 google.com 2>/dev/null | grep -c "packets"` 
	if [ $internet -ne 1 ] ; then
		echo " [ "$bold"INFO"$normal" ] Didn't detect a working internet connection 			[ "$bold""$red"FALSE"$normal" ]"
	fi
	
### Terminate Toolkit if FALSE
	if [ "$os" != "$raspbian" ] && [ "$os" != "$ubuntu" ] && [ "$os" != "$libre" ] ; then
		echo " "
		echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
		echo " "
		exit 1
	fi
	
	if [ "$(id -u)" != 0 ] || [ $freespacecheck -lt $requiredfreespace ] || [ "$rpiversion" != "$rpicompversion" ] || [ $(version $kernel_version) -lt $(version "4.1") ] || [ $internet -eq 0 ] ; then
		echo " "
		echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
		echo " "
		exit 1
	else

### Toolkit necessities packages

			if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then

### Check 				
				unziper=`dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed"`
				gitter=`dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed"`
				wgetter=`dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed"`

			if [ $unziper -ne 1 ] || [ $gitter -ne 1 ] || [ $wgetter -ne 1 ] ; then
				echo -n " [ "$bold"EXEC"$normal" ] Updating repo sourcelist " 
				apt-get update > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done				
				echo "				      [ "$bold""$blue"UPDATED"$normal" ]"

				if [ $unziper -ne 1 ] ; then

				echo -n " [ "$bold"EXEC"$normal" ] Installing unzip package   "				
				apt-get install unzip -y > /dev/null 2>&1

     			unziper=`dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed"`
				if [ $unziper -ne 1 ] ; then
				echo "				        [ "$bold""$red"ERROR"$normal" ]"
				else
				echo "				    [ "$bold""$blue"INSTALLED"$normal" ]"
				fi
				
				fi

				if [ $gitter -ne 1 ] ; then	
				echo -n " [ "$bold"EXEC"$normal" ] Installing git package   "
				apt-get install git -y > /dev/null 2>&1	&
				
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done				

				gitter=`dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed"`	
				if [ $gitter -ne 1 ] ; then
				echo "				        [ "$bold""$red"ERROR"$normal" ]"
				else
				echo "				    [ "$bold""$blue"INSTALLED"$normal" ]"
				fi
					
				fi

				if [ $wgetter -ne 1 ] ; then	
				echo -n " [ "$bold"EXEC"$normal" ] Installing wget package"
				apt-get install wget -y > /dev/null 2>&1	

				wgetter=`dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed"`	
				if [ $wgetter -ne 1 ] ; then
				echo "				        [ "$bold""$red"ERROR"$normal" ]"
				else
				echo "				    [ "$bold""$blue"INSTALLED"$normal" ]"
				fi
				
				fi

			if [ $unziper -eq 0 ] || [ $gitter -eq 0 ] || [ $wgetter -eq 0 ] ; then
				echo " "
				echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
				echo " "
				exit 1			
			fi
			
			fi
echo " "				
			elif [ "$os" == "$libre" ] ; then

				libresystemtools="/storage/.kodi/addons/virtual.system-tools/default.py"
				librerpitools="/storage/.kodi/addons/virtual.rpi-tools/default.py"
				if [ -f $libresystemtools ] ; then
					echo " [ "$bold"INFO"$normal" ] LibreELEC system-tools already installed	   	   	   [ "$bold""$green"OK"$normal" ]"
					sleep 1
				else
					echo " [ "$bold"INFO"$normal" ] LibreELEC system-tools aint installed	   	   		[ "$bold""$red"FALSE"$normal" ]"
					sleep 1
				fi
				
				if [ -f $librerpitools ] ; then
					echo " [ "$bold"INFO"$normal" ] LibreELEC rpi-tools already installed	   	   		   [ "$bold""$green"OK"$normal" ]"
					sleep 1
				else
					echo " [ "$bold"INFO"$normal" ] LibreELEC rpi-tools aint installed	   	   		[ "$bold""$red"FALSE"$normal" ]"
					sleep 1
				fi				

				if [ -f $librerpitools ] && [ -f $libresystemtoolstools ] ; then
					echo " [ "$bold"INFO"$normal" ] All toolkit necessity packages are installed 		   	   [ "$bold""$green"OK"$normal" ]"				
				else
					echo " "
					echo " [ "$bold"INFO"$normal" ] Please make sure you installed missing addons as discribe above..."					
					echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
					echo " "
					exit 1			
				fi				
			
			else
			echo " "
			echo " [ "$bold""$red"ERROR"$normal" ] Unknown Operating System..."			
			echo " [ "$bold""$red"ERROR"$normal" ] Toolkit Terminated!"
			echo " "
			exit 1
			fi
	fi

### All check OK then show menu
while true
do
options=("Install - PIco HV3.0A" "Remove  - PIco HV3.0A" "Status  - PIco HV3.0A" "Quit")
COLUMNS=12

select opt in "${options[@]}"

do
case $opt in
"Install - PIco HV3.0A")
#######################################################################################################
### START - MENU OPTION 1: PIco UPS HV3.0A Installation START
#######################################################################################################
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A Installation"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	echo " Dear "$green"$user"$normal","
	echo " You're about to install all PIco HV3.0a UPS necessities"
	echo " Please make sure your PIco board is connected to your Raspberry"
	echo " "
	echo " "$bold"Disclaimer:"$normal""
	echo " I don't take any responsibility if your OS, Rpi or PIco board gets broken"
	echo " You are using this script on your own responsibility!!!"
	echo " "
	read -p " Continue? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
			echo " "
			echo ""$yellow":::"$normal" PIco UPS HV3.0a Precautions Check"
			echo ""$yellow"================================================================================="$normal""
			echo " "
	else
			echo " "
			echo ""$yellow":::"$normal" PIco HV3.0a Toolkit Terminated"		  
			echo ""$yellow"================================================================================="$normal""
			echo " "
			echo " Thx "$green"$user"$normal" for using PIco HV3.0a toolkit"
			echo " "
			exit
	fi
	
#######################################################################################################
### PIco UPS HV3.0a check for any signs of a previous PIco installation
#######################################################################################################

### Checking if there's a PIco service active
	picoserviceactive=`systemctl is-active picofssd 2>/dev/null`
	if [ "$picoserviceactive" == "active" ] ; then
		echo " [ "$bold"INFO"$normal" ] Detected a active PIco service				[ "$bold""$red"FALSE"$normal" ]"	
		sleep 1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected a active PIco service				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi
	
if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ] ; then
### Checking if there's a PIco daemon active
	picodaemon="/usr/local/bin/picofssd"
	if [ -f $picodaemon ] ; then
		echo " [ "$bold"INFO"$normal" ] Detected a active PIco daemon					[ "$bold""$red"FALSE"$normal" ]"
		sleep 1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected a active PIco daemon				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi
	
### Checking if there's a PIco init file loaded
	picoinit="/etc/init.d/picofssd"
	if [ -f $picoinit ] ; then	
		echo " [ "$bold"INFO"$normal" ] Detected a PIco init.d file					[ "$bold""$red"FALSE"$normal" ]"	
		sleep 1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected a PIco init.d file				   [ "$bold""$green"OK"$normal" ]"	
		sleep 1
	fi
	
### Checking if there are other previous PIco leftovers
	picofile1="/etc/pimodules/picofssd"
	picofile2="/usr/local/bin/picofssdxmlconfig"
	picofile3="/usr/local/lib/python2.7/dist-packages/pimodules-0.1dev.egg-info"
	picofile4="/usr/local/lib/python2.7/dist-packages/pimodules/picofssd-0.1dev-py2.7.egg-info"
	picofile5="/etc/default/picofssd"
	if [ -f $picofile1 ] || [ -f $picofile2 ] || [ -f $picofile3 ] || [ -f $picofile4 ] || [ -f $picofile5 ]; then
		echo " [ "$bold"INFO"$normal" ] Detected a some other PIco leftovers				[ "$bold""$red"FALSE"$normal" ]"	
		sleep 1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected any PIco leftovers				   [ "$bold""$green"OK"$normal" ]"	
		sleep 1
	fi
	
### Terminate script if any PIco leftovers are found
	if [ "$picoserviceactive" == "active" ] || [ -f $picodaemon ] || [ -f $picoinit ] || [ -f $picofile1 ] || [ -f $picofile2 ] || [ -f $picofile3 ] || [ -f $picofile4 ] || [ -f $picofile5 ]; then
			echo " "
			echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
			echo " "
			exit 1
	fi

else
### Terminate script if any PIco leftovers are found
	if [ "$picoserviceactive" == "active" ] ; then
			echo " "
			echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
			echo " "
			exit 1
	fi
fi	

#######################################################################################################
### PIco UPS HV3.0a prepare OS
#######################################################################################################
	
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0a Setting up $ospretty"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	
	if [ "$os" == "$libre" ] ; then
	echo " [ "$bold"INFO"$normal" ] Mounted /flash with read/write permission			   [ "$bold""$green"OK"$normal" ]"
	mount -o remount,rw /flash
	sleep 1	
	fi
	
### Checking if i2c is enabled
	raspii2c=`cat $config | grep dtparam=i2c_arm`
	if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm already enabled in /boot/config.txt	   	   [ "$bold""$green"OK"$normal" ]"
	elif [ "$raspii2c" == "#dtparam=i2c_arm=on" ]; then
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspii2c,dtparam=i2c_arm=on," $config
	elif [ "$raspii2c" == "dtparam=i2c_arm=off" ]; then
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspii2c,dtparam=i2c_arm=on," $config
	elif [ "$raspii2c" == "#dtparam=i2c_arm=off" ]; then
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspii2c,dtparam=i2c_arm=on," $config		
	else
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sh -c "echo 'dtparam=i2c_arm=on' >> $config"
	fi
	sleep 1	

### Checking if serial uart is enabled
	raspiuart=`cat $config | grep enable_uart`
	if [ "$raspiuart" == "enable_uart=1" ]; then
		echo " [ "$bold"INFO"$normal" ] enable_uart already enabled in /boot/config.txt	  	   [ "$bold""$green"OK"$normal" ]"
	elif [ "$raspiuart" == "#enable_uart=1" ]; then
		echo " [ "$bold"INFO"$normal" ] enable_uart enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspiuart,enable_uart=1," $config
	elif [ "$raspiuart" == "#enable_uart=0" ]; then
		echo " [ "$bold"INFO"$normal" ] enable_uart enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspiuart,enable_uart=1," $config
	elif [ "$raspiuart" == "enable_uart=0" ]; then
		echo " [ "$bold"INFO"$normal" ] enable_uart enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspiuart,enable_uart=1," $config
	else
		echo " [ "$bold"INFO"$normal" ] enable_uart enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sh -c "echo 'enable_uart=1' >> $config"
	fi
	sleep 1
	
### Setting up modules for kernel prior 4.1 or higher then 4.1
if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ] ; then
	rtcmoduleold=`cat /etc/modules | grep rtc-ds1307`
	rtcmoduleold2=`cat /etc/rc.local | grep echo`
fi
	
if [ $(version $kernel_version) -lt $(version "4.1") ] ; then

if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ] ; then
	if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
		echo " [ "$bold"INFO"$normal" ] rtc module already enabled in /etc/modules		  	   [ "$bold""$green"OK"$normal" ]"
	elif [ "$rtcmoduleold" == "#rtc-ds1307" ]; then
		echo " [ "$bold"INFO"$normal" ] rtc module enabled in /etc/modules		  	  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$rtcmoduleold,rtc-ds1307," /etc/modules
	else
		echo " [ "$bold"INFO"$normal" ] rtc module enabled in /etc/modules		  	  	  [ "$bold""$blue"SET"$normal" ]"
		sh -c "echo 'rtc-ds1307' >> /etc/modules"
	fi
	sleep 1

### Checking for old kernel rtc statement in rc.local
	if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
		echo " [ "$bold"INFO"$normal" ] rtc rc.local statement already enabled in /etc/rc.local	   [ "$bold""$green"OK"$normal" ]"
	elif [ "$rtcmoduleold2" == "#echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then 
		echo " [ "$bold"INFO"$normal" ] rtc rc.local statement enabled in /etc/rc.local		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$rtcmoduleold2,echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &," /etc/rc.local
	else
		echo " [ "$bold"INFO"$normal" ] rtc rc.local statement enabled in /etc/rc.local		  [ "$bold""$blue"SET"$normal" ]"
		sed -i 's/\exit 0//g' /etc/rc.local
		echo "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &"  >> /etc/rc.local
		sh -c "echo 'exit 0' >> /etc/rc.local"
	fi
	sleep 1
	
	
fi

### Checking if rtc dtoverlay module is loaded which doesn't work on older kernels
	rtcmodule=`cat $config | grep dtoverlay=i2c-rtc,ds1307`
	if [ "$rtcmodule" == "#dtoverlay=i2c-rtc,ds1307" ]; then
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc enabled in /boot/config.txt		  [ "$bold""$blue"SET"$normal" ]"
		sed -i -e 's/dtoverlay=i2c-rtc,ds1307/dtoverlay=i2c-rtc,ds1307/g' $config		
	else
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc already disabled in /boot/config.txt	   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

else

if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then
	if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
		echo " [ "$bold"INFO"$normal" ] old rtc module disabled in /etc/modules		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules
	else
		echo " [ "$bold"INFO"$normal" ] old rtc module already disabled in /etc/modules		   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1
	

### Checking for old kernel rtc statement in rc.local
	if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
		echo " [ "$bold"INFO"$normal" ] rtc rc.local statement disabled in /etc/rc.local		  [ "$bold""$blue"SET"$normal" ]"
	sed -i "s,$rtcmoduleold2,#echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &," /etc/rc.local		
	else
		echo " [ "$bold"INFO"$normal" ] rtc rc.local statement already disabled in /etc/rc.local	   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1
fi
### Checking if rtc dtoverlay module is loaded which doesn't work on older kernels
	rtcmodule=`cat $config | grep dtoverlay=i2c-rtc,ds1307`
	if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc already enabled in /boot/config.txt	   	   [ "$bold""$green"OK"$normal" ]"
	elif [ "$rtcmodule" == "#dtoverlay=i2c-rtc,ds1307" ]; then
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i -e 's/#dtoverlay=i2c-rtc,ds1307/dtoverlay=i2c-rtc,ds1307/g' $config
	else
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc enabled in /boot/config.txt		  	  [ "$bold""$blue"SET"$normal" ]"
		sh -c "echo 'dtoverlay=i2c-rtc,ds1307' >> $config"
	fi
	sleep 1

fi	

### END OLD AND NEW KERNEL SETUP

### Checking if i2c baudrate is static
	raspii2cbaudrate=`cat $config | grep i2c_arm_baudrate | /usr/bin/cut -f 1 -d '='`	
	if [ "$raspii2cbaudrate" == "i2c_arm_baudrate" ] ; then
		echo " [ "$bold"INFO"$normal" ] i2c_arm_baudrate disabled in /boot/config.txt		  	    [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$raspii2cbaudrate,#$raspii2cbaudrate," $config		
	else
		echo " [ "$bold"INFO"$normal" ] i2c_arm_baudrate already disabled in /boot/config.txt	   	   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then	
### Checking if i2c-bcm2708 module is loaded
	bcmmodule=`cat /etc/modules | grep i2c-bcm2708`
	if [ "$bcmmodule" == "i2c-bcm2708" ]; then
		echo " [ "$bold"INFO"$normal" ] i2c-bcm2708 module already enabled in /etc/modules		   [ "$bold""$green"OK"$normal" ]"
	elif [ "$bcmmodule" == "#i2c-bcm2708" ]; then
		echo " [ "$bold"INFO"$normal" ] i2c-bcm2708 module enabled in /etc/modules		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$bcmmodule,i2c-bcm2708," /etc/modules
	else
		echo " [ "$bold"INFO"$normal" ] i2c-bcm2708 module enabled in /etc/modules		  	  [ "$bold""$blue"SET"$normal" ]"
		sh -c "echo 'i2c-bcm2708' >> /etc/modules"
	fi
	sleep 1

### Checking if i2c-dev module is loaded
	i2cmodule=`cat /etc/modules | grep i2c-dev`
	if [ "$i2cmodule" == "i2c-dev" ]; then
		echo " [ "$bold"INFO"$normal" ] i2c-dev module already enabled in /etc/modules		   [ "$bold""$green"OK"$normal" ]"
	elif [ "$i2cmodule" == "#i2c-dev" ]; then
		echo " [ "$bold"INFO"$normal" ] i2c-dev module enabled in /etc/modules		  	  [ "$bold""$blue"SET"$normal" ]"
		sed -i "s,$i2cmodule,i2c-dev," /etc/modules
	else
		echo " [ "$bold"INFO"$normal" ] i2c-dev module enabled in /etc/modules		  	  [ "$bold""$blue"SET"$normal" ]"
		sh -c "echo 'i2c-dev' >> /etc/modules"
	fi
	sleep 1
fi
### Checking if hciuart service is loaded
	uartstatus=`systemctl is-active hciuart 2>/dev/null`
	if [ "$uartstatus" == "active" ]; then
		echo " [ "$bold"INFO"$normal" ] hciuart service already active		   		   [ "$bold""$green"OK"$normal" ]"
	else
		echo " [ "$bold"INFO"$normal" ] hciuart service enabled		   			  [ "$bold""$blue"SET"$normal" ]"
		systemctl enable hciuart > /dev/null 2>&1
	fi	
	sleep 1

	if [ "$os" == "$libre" ] ; then
	echo " [ "$bold"INFO"$normal" ] Mounted /flash as read only again				   [ "$bold""$green"OK"$normal" ]"
	mount -o remount,ro /flash
	sleep 1	
	fi
	
### PIco UPS HV3.0A package necessities check and installation
if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A and $ospretty necessities installation"
	echo ""$yellow"================================================================================="$normal""
	echo " "	
	pythonrpigpio=`dpkg-query -W -f='${Status}' python-rpi.gpio 2>/dev/null | grep -c "ok installed"`
	pythondev=`dpkg-query -W -f='${Status}' python-dev 2>/dev/null | grep -c "ok installed"`
	pythonserial=`dpkg-query -W -f='${Status}' python-serial 2>/dev/null | grep -c "ok installed"`
	pythonsmbus=`dpkg-query -W -f='${Status}' python-smbus 2>/dev/null | grep -c "ok installed"`
	pythonjinja2=`dpkg-query -W -f='${Status}' python-jinja2 2>/dev/null | grep -c "ok installed"`
	pythonxmltodict=`dpkg-query -W -f='${Status}' python-xmltodict 2>/dev/null | grep -c "ok installed"`
	pythonpsutil=`dpkg-query -W -f='${Status}' python-psutil 2>/dev/null | grep -c "ok installed"`
	pythonpip=`dpkg-query -W -f='${Status}' python-pip 2>/dev/null | grep -c "ok installed"`
	i2ctools=`dpkg-query -W -f='${Status}' i2c-tools 2>/dev/null | grep -c "ok installed"`

if [ $pythonrpigpio -eq 0 ] || [ $pythondev -eq 0 ] || [ $pythonserial -eq 0 ] || [ $pythonsmbus -eq 0 ] || [ $pythonjinja2 -eq 0 ] || [ $pythonxmltodict -eq 0 ] || [ $pythonpsutil -eq 0 ] || [ $pythonpip -eq 0 ] || [ $i2ctools -eq 0 ]; then
	echo -n " [ "$bold"EXEC"$normal" ] Updating repo sourcelist " 
	apt-get update > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done	
	echo "				      [ "$bold""$blue"UPDATED"$normal" ]"
fi


	if [ $pythonrpigpio -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-rpi.gpio package "
		apt-get install python-rpi.gpio -y > /dev/null 2>&1	 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done		

		pythonrpigpio=`dpkg-query -W -f='${Status}' python-rpi.gpio 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonrpigpio -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-rpi.gpio package already installed			   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

	if [ $pythondev -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-dev package "
		apt-get install python-dev -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done		

		pythondev=`dpkg-query -W -f='${Status}' python-dev 2>/dev/null | grep -c "ok installed"`	
		if [ $pythondev -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-dev package already installed				   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

	if [ $pythonserial -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-serial package "
		apt-get install python-serial -y > /dev/null 2>&1 &

					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done		

		pythonserial=`dpkg-query -W -f='${Status}' python-serial 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonserial -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-serial package already installed			   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1
	
	if [ $pythonsmbus -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-smbus package "
		apt-get install python-smbus -y > /dev/null 2>&1 &
		
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
					
		pythonsmbus=`dpkg-query -W -f='${Status}' python-smbus 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonsmbus -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-smbus package already installed			   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

	if [ $pythonjinja2 -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-jinja2 package "
		apt-get install python-jinja2 -y > /dev/null 2>&1 &

					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
					
		pythonjinja2=`dpkg-query -W -f='${Status}' python-jinja2 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonjinja2 -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-jinja2 package already installed			   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

	if [ $pythonxmltodict -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-xmltodict package "
		apt-get install python-xmltodict -y > /dev/null 2>&1 &	

					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
					
		pythonxmltodict=`dpkg-query -W -f='${Status}' python-xmltodict 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonxmltodict -ne 1 ] ; then
			echo "			[ "$bold""$red"ERROR"$normal" ]"
		else
			echo "		            [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-xmltodict package already installed			   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

	if [ $pythonpsutil -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-psutil package "
		apt-get install python-psutil -y > /dev/null 2>&1 &

					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
					
		pythonpsutil=`dpkg-query -W -f='${Status}' python-psutil 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonpsutil -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-psutil package already installed			   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1
	
	if [ $pythonpip -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing python-pip package "
		apt-get install python-pip -y > /dev/null 2>&1	&

					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
					
		pythonpip=`dpkg-query -W -f='${Status}' python-pip 2>/dev/null | grep -c "ok installed"`	
		if [ $pythonpip -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] python-pip package already installed				   [ "$bold""$green"OK"$normal" ]"
	fi
	sleep 1

	if [ $i2ctools -eq 0 ]; then	
		echo -n " [ "$bold"EXEC"$normal" ] Installing i2c-tools package "
		apt-get install i2c-tools -y > /dev/null 2>&1 &

					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
					
		i2ctools=`dpkg-query -W -f='${Status}' i2c-tools 2>/dev/null | grep -c "ok installed"`	
		if [ $i2ctools -ne 1 ] ; then
			echo "			        [ "$bold""$red"ERROR"$normal" ]"
		else
			echo "			    [ "$bold""$blue"INSTALLED"$normal" ]"
		fi
	else
	echo " [ "$bold"INFO"$normal" ] i2c-tools package already installed				   [ "$bold""$green"OK"$normal" ]"	
	fi
	sleep 1

### Terminate Toolkit if FALSE	
	if [ $pythonrpigpio -eq 0 ] || [ $pythondev -eq 0 ] || [ $pythonserial -eq 0 ] || [ $pythonsmbus -eq 0 ] || [ $pythonjinja2 -eq 0 ] || [ $pythonxmltodict -eq 0 ] || [ $pythonpsutil -eq 0 ] || [ $pythonpip -eq 0 ] || [ $i2ctools -eq 0 ]; then
		echo " "
		echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
		echo " "
		exit 1			
	fi
fi

### PIco UPS HV3.0A daemon installation
	picogitclone="PiModules/README.md"
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A daemons and tools installation"
	echo ""$yellow"================================================================================="$normal""
	echo " "
if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then	
	if [ -f $picogitclone ] ; then
		echo " [ "$bold"EXEC"$normal" ] Cloning PiModules from git				       [ "$bold""$purple"CLONED"$normal" ]"
		git clone https://github.com/Siewert308SW/PiModules.git> /dev/null 2>&1
	else
		echo " [ "$bold"EXEC"$normal" ] Cloning PiModules from git				       [ "$bold""$purple"CLONED"$normal" ]"
		git clone https://github.com/Siewert308SW/PiModules.git> /dev/null 2>&1
	fi
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Installing PIco mail daemon				    [ "$bold""$blue"INSTALLED"$normal" ]"
		cd ./PiModules/code/python/package
		python setup.py install > /dev/null 2>&1
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Installing PIcofssd daemon				    [ "$bold""$blue"INSTALLED"$normal" ]"
		cd ../upspico/picofssd
		python setup.py install > /dev/null 2>&1
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Setting PIcofssd defaults to update-rc.d			  [ "$bold""$blue"SET"$normal" ]"
		update-rc.d picofssd defaults > /dev/null 2>&1
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Enabling PIcofssd daemon				      [ "$bold""$purple"ENABLED"$normal" ]"
		update-rc.d picofssd enable > /dev/null 2>&1
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Starting PIcofssd daemon				      [ "$bold""$purple"STARTED"$normal" ]"
		/etc/init.d/picofssd start > /dev/null 2>&1
		cd $dir
		sleep 1

fi

if [ "$os" == "$libre" ]; then

		picosystemdcheck=`ls /storage/.config/system.d | grep -c pico`
		picosystemdservicefile=`ls /storage/.config/system.d | grep pico`
		picosystemdservice=`ls /storage/.config/system.d | grep pico | /usr/bin/cut -f 1 -d '.'`
        if [ $picosystemdcheck -eq 1 ] ; then
		echo " [ "$bold"EXEC"$normal" ] Found old PIcofssd daemon				     [ "$bold""$red"DISABLED"$normal" ]"	
		systemctl disable $picosystemdservice > /dev/null 2>&1
		rm -rf /storage/.config/system.d/$picosystemdservicefile
		fi
		
		echo " [ "$bold"EXEC"$normal" ] Getting PIcofssd daemon from git			       [ "$bold""$purple"CLONED"$normal" ]"
		picogitfiles="/tmp/pico_daemon_libre.zip"
		if [ -f $picogitfiles ] ; then
		rm -rf /tmp/pico_daemon_libre.zip > /dev/null 2>&1
		rm -rf /tmp/pico_status_libreelec.py > /dev/null 2>&1
		rm -rf /tmp/picofssd > /dev/null 2>&1
		fi
		
		wget https://github.com/Siewert308SW/pico_installer/raw/master/pico_daemon_libre.zip > /dev/null 2>&1
		unzip pico_daemon_libre.zip > /dev/null 2>&1
		mkdir /storage/upspico > /dev/null 2>&1
		cp pico_status_libreelec.py /storage/upspico/pico_status_libreelec.py > /dev/null 2>&1
		cp picofssd /storage/upspico/picofssd > /dev/null 2>&1
		chmod +x /storage/upspico/pico_status_libreelec.py > /dev/null 2>&1
		chmod +x /storage/upspico/picofssd > /dev/null 2>&1
		sleep 1
		
		echo " [ "$bold"EXEC"$normal" ] Setting up PIcofssd system.d			  	          [ "$bold""$blue"SET"$normal" ]"
		touch /storage/.config/system.d/picofssd.service > /dev/null 2>&1
		sh -c "echo '[Unit]' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo 'Description=UPS PIco file-safe shutdown LibreELEC daemon' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo ' ' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo '[Service]' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo 'ExecStart=/usr/bin/python /storage/upspico/picofssd' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo ' ' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo '[Install]' >> /storage/.config/system.d/picofssd.service"
		sh -c "echo 'WantedBy=multi-user.target' >> /storage/.config/system.d/picofssd.service"
		chmod +x /storage/.config/system.d/picofssd.service > /dev/null 2>&1
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Enabling PIcofssd daemon				      [ "$bold""$blue"ENABLED"$normal" ]"
		systemctl enable picofssd > /dev/null 2>&1
		sleep 1
		echo " [ "$bold"EXEC"$normal" ] Starting PIcofssd daemon				      [ "$bold""$purple"STARTED"$normal" ]"
		systemctl start picofssd > /dev/null 2>&1
		sleep 1	
fi
		
### PIco UPS HV3.0A installation finished
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A Installation Finished"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	echo " Thx "$green"$user"$normal" for using PIco HV3.0A Toolkit"
	echo " "
	echo " PIco UPS HV3.0a installation finished"
	echo " If no errors occured then everything should be up and active"
	echo " Your shiny PIco PCB should be alive after the system has been rebooted"	
	echo " "
	secs=$((2 * 10))
	while [ $secs -gt 0 ]; do
	   echo -ne "System will be rebooted in: "$cyan"$secs\033[0K\r"$normal""
	   sleep 1
	   : $((secs--))
	done
	sleep 1
	reboot
	
#######################################################################################################
### END - MENU OPTION 1: PIco UPS HV3.0A Installation END
#######################################################################################################
	;;

"Remove  - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 2: PIco UPS HV3.0A Removal START
#######################################################################################################

	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A Removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	echo " Dear "$green"$user"$normal","
	echo " You're about to remove all PIco HV3.0a UPS necessities"
	echo " Some necessities aren't PIco related and could be in use by other resources"
	echo " There for you will be asked if you want to remove them..."
	echo " "
	echo " "$bold"Disclaimer:"$normal""
	echo " I don't take any responsibility if your OS, Rpi or PIco board gets broken"
	echo " You are using this script on your own responsibility!!!"
	echo " "
	read -p " Continue? (y/n)" CONT
	if [ "$CONT" = "y" ]; then
		if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then	
			pythonrpigpio=`dpkg-query -W -f='${Status}' python-rpi.gpio 2>/dev/null | grep -c "ok installed"`
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
			raspii2c=`cat $config | grep dtparam=i2c_arm=on`
			raspiuart=`cat $config | grep enable_uart`
			rtcmodule=`cat $config | grep dtoverlay=i2c-rtc,ds1307`
			bcmmodule=`cat /etc/modules | grep i2c-bcm2708`
			rtcmoduleold=`cat /etc/modules | grep rtc-ds1307`
			rtcmoduleold2=`cat /etc/rc.local | grep echo`
			i2cmodule=`cat /etc/modules | grep i2c-dev`
		elif [ "$os" == "$libre" ] ; then
			picosystemdcheck=`ls /storage/.config/system.d | grep -c pico`
			picosystemdservicefile=`ls /storage/.config/system.d | grep pico`
			picosystemdservice=`ls /storage/.config/system.d | grep pico | /usr/bin/cut -f 1 -d '.'`		
		fi	
	else
			echo " "
			echo ""$yellow":::"$normal" PIco HV3.0a Toolkit Terminated"		  
			echo ""$yellow"================================================================================="$normal""
			echo " "
			echo " Thx "$green"$user"$normal" for using PIco HV3.0a toolkit"
			echo " "
			exit
	fi
	
#######################################################################################################
### PIco UPS HV3.0a packages, modules and daemons removal
#######################################################################################################
if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ]; then

	if [ "$raspii2c" == "dtparam=i2c_arm=on" ] || [ "$raspiuart" == "enable_uart=1" ] || [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ] || [ "$bcmmodule" == "i2c-bcm2708" ] || [ "$rtcmoduleold" == "rtc-ds1307" ] || [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ] || [ "$i2cmodule" == "i2c-dev" ] || [ $pythonrpigpio -eq 1 ] || [ $pythondev -eq 1 ] || [ $pythonserial -eq 1 ] || [ $pythonsmbus -eq 1 ] || [ $pythonjinja2 -eq 1 ] || [ $pythonxmltodict -eq 1 ] || [ $pythonpsutil -eq 1 ] || [ $pythonpip -eq 1 ] || [ $i2ctools -eq 1 ] || [ -f $picofile1 ] || [ -f $picofile2 ] || [ -f $picofile3 ] || [ -f $picofile4 ] || [ -f $picofile5 ]; then
	
	echo " "	
	echo ""$yellow":::"$normal" PIco UPS HV3.0a daemons removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	
### Checking if there's a PIco service active
	picoserviceactive=`systemctl is-active picofssd 2>/dev/null`
	if [ "$picoserviceactive" == "active" ] ; then
		echo " [ "$bold"EXEC"$normal" ] Detected a active PIco service			      [ "$bold""$purple"STOPPED"$normal" ]"
		systemctl stop picofssd 2>/dev/null	
		sleep 1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected a active PIco service				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi
	
### Checking if there's a PIco daemon active
	picodaemon="/usr/local/bin/picofssd"
	if [ -f $picodaemon ] ; then
		echo " [ "$bold"EXEC"$normal" ] PIco daemon removed					      [ "$bold""$purple"REMOVED"$normal" ]"
		rm -rf /usr/local/bin/picofssd > /dev/null 2>&1
		rm -rf /etc/pimodules > /dev/null 2>&1
		rm -rf /usr/local/bin/picofssdxmlconfig > /dev/null 2>&1
		rm -rf /usr/local/lib/python2.7/dist-packages/pimodules-0.1dev.egg-info > /dev/null 2>&1
		rm -rf /usr/local/lib/python2.7/dist-packages/pimodules > /dev/null 2>&1
		rm -rf /etc/default/picofssd > /dev/null 2>&1		
		sleep 1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected a PIco daemon				   	   [ "$bold""$green"OK"$normal" ]"
	fi
		sleep 1

### Checking if there's a PIco init file loaded
	picoinit="/etc/init.d/picofssd"
	if [ -f $picoinit ] ; then
		echo " [ "$bold"EXEC"$normal" ] PIco init file removed				      [ "$bold""$purple"REMOVED"$normal" ]"
		rm -rf /etc/init.d/picofssd > /dev/null 2>&1
	else
		echo " [ "$bold"INFO"$normal" ] Didn't detected a PIco init file				   [ "$bold""$green"OK"$normal" ]"
		fi
		sleep 1

	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0a system modules removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "


### Checking if i2c is enabled
	if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"
		read -p " disable dtparam=i2c_arm in /boot/config.txt? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i "s,$raspii2c,#dtparam=i2c_arm=on," $config
		fi
	else
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm already disabled in /boot/config.txt		   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

### Checking if serial uart is enabled
	if [ "$raspiuart" == "enable_uart=1" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " disable enable_uart in /boot/config.txt? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i "s,$raspiuart,#enable_uart=1," $config
		fi
	else
		echo " [ "$bold"INFO"$normal" ] enable_uart already disabled in /boot/config.txt		   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

### Checking if rtc dtoverlay module is loaded
	if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"
		read -p " disable dtoverlay=i2c-rtc in /boot/config.txt? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i -e 's/dtoverlay=i2c-rtc/#dtoverlay=i2c-rtc/g' $config
		fi
	else
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc already disabled in /boot/config.txt	   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi
	
### Checking if i2c-bcm2708 module is loaded
	if [ "$bcmmodule" == "i2c-bcm2708" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"
		read -p " disable i2c-bcm2708 in /etc/modules? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i "s,$bcmmodule,#i2c-bcm2708," /etc/modules
		fi
	else
		echo " [ "$bold"INFO"$normal" ] i2c-bcm2708 already disabled in /etc/modules		   	   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

### Checking for old rtc module load statement
	if [ "$rtcmoduleold" == "rtc-ds1307" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " disable old kernel rtc-ds1307 in /etc/modules? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i "s,$rtcmoduleold,#rtc-ds1307," /etc/modules
		fi
	else
		echo " [ "$bold"INFO"$normal" ] rtc-ds1307 already disabled in /etc/modules		   	   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

### Checking for old rtc load statement in rc.local
	if [ "$rtcmoduleold2" == "echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device ( sleep 4; hwclock -s ) &" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " disable old kernel rtc statement in /etc/rc.local? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i -e 's/echo ds1307 0x68/#echo ds1307 0x68/g' /etc/rc.local
		fi
	else
		echo " [ "$bold"INFO"$normal" ] old kernel rtc statement already disabled in /etc/rc.local	   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0a system package removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "
###	
	if [ $pythonrpigpio -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-rpi.gpio package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
				echo -n " [ "$bold"EXEC"$normal" ] removing python-rpi.gpio package " 
					apt-get remove python-rpi.gpio -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done				
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"			
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-rpi package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythondev -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-dev package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-dev package "
			apt-get remove python-dev -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-dev package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythonserial -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-serial package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-serial package "
		apt-get remove python-serial -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-serial package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythonsmbus -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-smbus package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-smbus package "
		apt-get remove python-smbus -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-smbus package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythonjinja2 -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-jinja2 package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-jinja2 package "
		apt-get remove python-jinja2 -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-jinja2 package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythonxmltodict -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-xmltodict package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-xmltodict package "
			apt-get remove python-xmltodict -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-xmltodict package already removed			   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythonpsutil -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-psutil package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-psutil package "
			apt-get remove python-psutil -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-psutil package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $pythonpip -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove python-pip package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing python-pip package "
		apt-get remove python-pip -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
		fi
	else
		echo " [ "$bold"INFO"$normal" ] python-pip package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

###
	if [ $i2ctools -eq 1 ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " remove i2c-tools package? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
		echo -n " [ "$bold"EXEC"$normal" ] removing i2c-tools package "
			apt-get remove i2c-tools -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done
				echo "			    [ "$bold""$blue"REMOVED"$normal" ]"						
			if [ "$i2cmodule" == "i2c-dev" ]; then
					sed -i "s,$i2cmodule,#i2c-dev," /etc/modules
			fi
		fi

	else
		echo " [ "$bold"INFO"$normal" ] i2c-tools package already removed				   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

	pythonrpigpio=`dpkg-query -W -f='${Status}' python-rpi.gpio 2>/dev/null | grep -c "ok installed"`
	pythondev=`dpkg-query -W -f='${Status}' python-dev 2>/dev/null | grep -c "ok installed"`
	pythonserial=`dpkg-query -W -f='${Status}' python-serial 2>/dev/null | grep -c "ok installed"`
	pythonsmbus=`dpkg-query -W -f='${Status}' python-smbus 2>/dev/null | grep -c "ok installed"`
	pythonjinja2=`dpkg-query -W -f='${Status}' python-jinja2 2>/dev/null | grep -c "ok installed"`
	pythonxmltodict=`dpkg-query -W -f='${Status}' python-xmltodict 2>/dev/null | grep -c "ok installed"`
	pythonpsutil=`dpkg-query -W -f='${Status}' python-psutil 2>/dev/null | grep -c "ok installed"`
	pythonpip=`dpkg-query -W -f='${Status}' python-pip 2>/dev/null | grep -c "ok installed"`
	i2ctools=`dpkg-query -W -f='${Status}' i2c-tools 2>/dev/null | grep -c "ok installed"`
	
	if [ $pythonrpigpio -ne 1 ] || [ $pythondev -ne 1 ] || [ $pythonserial -ne 1 ] || [ $pythonsmbus -ne 1 ] || [ $pythonjinja2 -ne 1 ] || [ $pythonxmltodict -ne 1 ] || [ $pythonpsutil -ne 1 ] || [ $pythonpip -ne 1 ] || [ $i2ctools -ne 1 ] || [ -f $picofile1 ] || [ -f $picofile2 ] || [ -f $picofile3 ] || [ -f $picofile4 ] || [ -f $picofile5 ]; then
	
### PIco UPS HV3.0A Removal Cleaning up
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A Removal Cleanup"
	echo ""$yellow"================================================================================="$normal""
	echo " This could take a awhile"
	echo " Please Standby!"
	echo " "
				echo -n " [ "$bold"EXEC"$normal" ] Executing apt-get autoremove " 
				apt-get autoremove -y > /dev/null 2>&1 &
					PID=$!
					i=1
					sp="/-\|"
					echo -n ' '
					while [ -d /proc/$PID ]
					do
					  printf "\b${sp:i++%${#sp}:1}"
					  sleep 0.5
					done				
				echo "			      [ "$bold""$blue"CLEANED"$normal" ]"
	sleep 1	
	fi
	
### PIco UPS HV3.0A removal finished
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A Removal Script Finished"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	echo " Thx "$green"$user"$normal" for using PIco HV3.0A removal script"
	echo " "
	echo " PIco UPS HV3.0a removal finished"
	echo " If no errors occured then everything has been removed or disabled"
	echo " After the system has been rebooted it is save to shutdown the system and remove the PIco board"	
	echo " "
	secs=$((2 * 10))
	while [ $secs -gt 0 ]; do
	   echo -ne "System will be rebooted in: "$cyan"$secs\033[0K\r"$normal""
	   sleep 1
	   : $((secs--))
	done
	sleep 1
	reboot

	else
		echo " "
		echo ""$yellow":::"$normal" PIco HV3.0a Removal Terminated"		  
		echo ""$yellow"================================================================================="$normal""
		echo " "
		echo " Thx "$green"$user"$normal" for using PIco HV3.0a toolkit"
		echo " But it looks like there isn't anything to remove..."
		echo " "	
	exit
	fi
fi

if [ "$os" == "$libre" ] ; then

#######################################################################################################
### PIco UPS HV3.0a packages, modules and daemons removal
#######################################################################################################
	echo " "	
	echo ""$yellow":::"$normal" PIco UPS HV3.0a daemons removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	
### Checking if there's a PIco service active
        if [ $picosystemdcheck -eq 1 ] ; then
		echo " [ "$bold"EXEC"$normal" ] Found old PIcofssd daemon				     [ "$bold""$red"REMOVED"$normal" ]"	
		systemctl stop $picosystemdservice > /dev/null 2>&1		
		systemctl disable $picosystemdservice > /dev/null 2>&1
		rm -rf /storage/.config/system.d/$picosystemdservicefile
		fi

	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0a system modules removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "

### Checking if i2c is enabled
	if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"
		read -p " disable dtparam=i2c_arm in /boot/config.txt? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i "s,$raspii2c,#dtparam=i2c_arm=on," $config
		fi
	else
		echo " [ "$bold"INFO"$normal" ] dtparam=i2c_arm already disabled in /boot/config.txt		   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

### Checking if serial uart is enabled
	if [ "$raspiuart" == "enable_uart=1" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"	
		read -p " disable enable_uart in /boot/config.txt? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i "s,$raspiuart,#enable_uart=1," $config
		fi
	else
		echo " [ "$bold"INFO"$normal" ] enable_uart already disabled in /boot/config.txt		   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

### Checking if rtc dtoverlay module is loaded
	if [ "$rtcmodule" == "dtoverlay=i2c-rtc,ds1307" ]; then
		echo -n " [ "$bold"Q&A"$normal" ]"
		read -p " disable dtoverlay=i2c-rtc in /boot/config.txt? (y/n)" CONT
		if [ "$CONT" = "y" ]; then
			sed -i -e 's/dtoverlay=i2c-rtc/#dtoverlay=i2c-rtc/g' $config
		fi
	else
		echo " [ "$bold"INFO"$normal" ] dtoverlay=i2c-rtc already disabled in /boot/config.txt	   [ "$bold""$green"OK"$normal" ]"
		sleep 1
	fi

	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0a system package removal"
	echo ""$yellow"================================================================================="$normal""
	echo " "
				libresystemtools="/storage/.kodi/addons/virtual.system-tools/default.py"
				librerpitools="/storage/.kodi/addons/virtual.rpi-tools/default.py"
				if [ -f $libresystemtools ] ; then
					echo " [ "$bold"INFO"$normal" ] LibreELEC system-tools still installed	   	   	   [ "$bold""$green"OK"$normal" ]"
					sleep 1
				else
					echo " [ "$bold"INFO"$normal" ] LibreELEC system-tools aint installed	   	   		[ "$bold""$red"FALSE"$normal" ]"
					sleep 1
				fi
				
				if [ -f $librerpitools ] ; then
					echo " [ "$bold"INFO"$normal" ] LibreELEC rpi-tools still installed	   	   		   [ "$bold""$green"OK"$normal" ]"
					sleep 1
				else
					echo " [ "$bold"INFO"$normal" ] LibreELEC rpi-tools aint installed	   	   		[ "$bold""$red"FALSE"$normal" ]"
					sleep 1
				fi				

				if [ -f $librerpitools ] && [ -f $libresystemtoolstools ] ; then
				
					echo " "
					echo " [ "$bold"INFO"$normal" ] Please make sure you remove addons as discribe above manually..."
					echo " "								
				else
					echo " "
					echo " [ "$bold"INFO"$normal" ] All toolkit necessity packages are uninstalled 		   	   [ "$bold""$green"OK"$normal" ]"				
					echo " [ "$bold""$red"ERROR"$normal" ] Toolkit terminated!"
					echo " "		
				fi

### PIco UPS HV3.0A removal finished
	echo " "
	echo ""$yellow":::"$normal" PIco UPS HV3.0A Removal Script Finished"
	echo ""$yellow"================================================================================="$normal""
	echo " "
	echo " Thx "$green"$user"$normal" for using PIco HV3.0A removal script"
	echo " "
	echo " PIco UPS HV3.0a removal finished"
	echo " If no errors occured then everything has been removed or disabled"
	echo " After the system has been rebooted it is save to shutdown the system and remove the PIco board"	
	echo " "
	secs=$((2 * 10))
	while [ $secs -gt 0 ]; do
	   echo -ne "System will be rebooted in: "$cyan"$secs\033[0K\r"$normal""
	   sleep 1
	   : $((secs--))
	done
	sleep 1
	reboot
	
fi

#######################################################################################################
### MENU OPTION 2: PIco UPS HV3.0A Removal END
#######################################################################################################
	;;
	
"Status  - PIco HV3.0A")
#######################################################################################################
### MENU OPTION 3: PIco UPS HV3.0A Status Script START
#######################################################################################################
clear
echo "$intro"
	echo ""$yellow":::"$normal" PIco HV3.0a Status"		  
	echo ""$yellow"================================================================================="$normal""
	picoserviceactive=`systemctl is-active picofssd 2>/dev/null`
if [ "$picoserviceactive" != "active" ] ; then
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

if [ "$os" == "$raspbian" ] || [ "$os" == "$ubuntu" ] ; then
	picostatus="/tmp/pico_status-master/pico_status.py"
	if [ -f $picostatus ] ; then
	python /tmp/pico_status-master/pico_status.py
	else
	wget https://github.com/Siewert308SW/pico_status/archive/master.zip > /dev/null 2>&1
	unzip master.zip > /dev/null 2>&1
	chmod +x /tmp/pico_status-master/pico_status.py
	python /tmp/pico_status-master/pico_status.py
	rm -rf master.zip
	fi
fi

if [ "$os" == "$libre" ] ; then
	picostatus="/tmp/pico_status-master/pico_status_libreelec.py"
	if [ -f $picostatus ] ; then
	python /tmp/pico_status-master/pico_status_libreelec.py
	else
	wget https://github.com/Siewert308SW/pico_status/archive/master.zip > /dev/null 2>&1
	unzip master.zip > /dev/null 2>&1
	chmod +x /tmp/pico_status-master/pico_status_libreelec.py
	python /tmp/pico_status-master/pico_status_libreelec.py
	rm -rf master.zip
	fi
fi
fi
	echo ""$yellow"================================================================================="$normal""
	echo " "
break
#######################################################################################################
### MENU OPTION 3: PIco UPS HV3.0A Status Script END
#######################################################################################################
;;

"Quit")
#######################################################################################################
### MENU OPTION 6: PIco UPS HV3.0A Quit
#######################################################################################################
	echo "$terminate"
	exit 0
	;;
	*) echo invalid option;;
		 esac
	 done
	 done
