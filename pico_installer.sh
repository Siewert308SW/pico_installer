#!/bin/bash

###############################################################################################################################################################	

### pico_installer.sh
### @author	: Siewert Lameijer
### @since	: 21-3-2017
### @updated: 21-3-2017
### Script for installing PIco HV3.0A UPS necessities
	
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
release=`/usr/bin/lsb_release -s -d`
rpiversion=`cat /proc/device-tree/model`
picoversion=`sudo i2cget -y 1 0x69 0x26`
kernel=`uname -r`
user=`whoami`
	
#######################################################################################################
### Checking if script is executed as root	
if [[ $EUID -ne 0 ]]; then
	echo " "
	echo "::: PIco UPS HV3.0A Installer"
	echo "---------------------------------------------------"
	echo "--- Hi $user,"
	echo "--- This script must be executed as root"
	echo "--- Installer terminated!"
	echo " "	
   exit
fi

#######################################################################################################
### Checking if OS version matches preferences

if [ "$release" != "Raspbian GNU/Linux 8.0 (jessie)" ]; then
	echo " "
	echo "::: PIco UPS HV3.0A Installer"
	echo "---------------------------------------------------"
	echo "--- Hi $user,"
	echo "--- Installer is intended for Raspbian GNU/Linux 8.0 (jessie)"
	echo "--- Instal script detected you are using $release"
	echo "--- Installer terminated!"
	echo " "	
	exit
fi

#######################################################################################################
### Checking if RPi version matches preferences

if [ "$rpiversion" != "Raspberry Pi 3 Model B Rev 1.2" ]; then
	echo " "
	echo "::: PIco UPS HV3.0A Installer"
	echo "---------------------------------------------------"
	echo "--- Hi $user,"
	echo "--- Installer is intended for Raspberry Pi 3 Model B Rev 1.2"
	echo "--- Install script detected you are using $rpiversion"
	echo "--- Installer terminated!"
	echo " "	
	exit
fi

#######################################################################################################
### Checking if RPi version matches preferences

if [ "$picoversion" != "0x30" ]; then
	echo " "
	echo "::: PIco UPS HV3.0A Installer"
	echo "---------------------------------------------------"
	echo "--- Hi $user,"
	echo "--- Installer is intended for PIco firmware 0x30"
	echo "--- Install script detected you are using $picoversion"
	echo "--- Please upgrade your PIco firmware"	
	echo "--- Installer terminated!"
	echo " "	
	exit
fi
	
#######################################################################################################
### Install Menu
	
	if [ ! -f /home/pi/pico_installer.conf ]; then
		echo installer=0 >> /home/pi/pico_installer.conf


			echo "::: PIco UPS HV3.0A Installer"
			echo "---------------------------------------------------"
			echo "Welcome $user,"
			echo "You are about to install all necessities for PIco HV3.0A UPS series"
			echo "There are some precautions to take before you continue the installer"
			echo " "
			echo "Disclaimer:"			
			echo "I don't take any responsibility if your OS, Rpi or PIco board gets broken"
			echo "You are using this script on your own responsibility!!!"			
			echo " "
			echo "Precautions:"
			echo "1. Install your PIco board before continuing the installer"
			echo "2. Raspberry Pi 3 Model B Rev 1.2"			
			echo "3. Use a clean Rasbian Jessie 8.0 installation"
			echo "   Or a installation which hasn't seen a previously installed PIco daemon "
			echo "4. Latest 4.9 kernel"
			echo "5. Preflashed PIco firmware 0x30 or higher"				
			echo "6. Enable i2c in raspi-config"
			echo "7. Enable serial in raspi-config"	
			echo "8. Set correct timezone in raspi-config"
			echo "9. Take in mind which battery type you have installed (installer asks for it later on)"			
			echo "10. It's advised to make a backup of your sdcard first before continuing the installer"	
			echo " "
			echo " "
			read -p "==> Continue! (y/n)?" CONT
							if [ "$CONT" = "y" ]; then
							echo " "
							else
							echo " "						
							echo "--- Installer terminated!"
							echo "--- Good Bye"	
							rm /home/pi/pico_installer.conf							
							echo " "
							echo " "	
							exit
							fi
							
#######################################################################################################
### Checking if kernel version matches preferences

currentver="$kernel"
requiredver="4.9"
if [ "$(printf "$requiredver\n$currentver" | sort -V | head -n1)" == "$currentver" ] && [ "$currentver" != "$requiredver" ]; then
	echo "::: PIco UPS HV3.0A Installer"
	echo "---------------------------------------------------"
	echo "--- Hi $user,"
	echo "--- Installer is intended for Raspberry Linux 4.9 kernel"
	echo "--- Install script detected you are using $kernel"
	echo " "
	echo "--- Do You want to upgrade kernel to 4.9?"
			read -p "==> Upgrade Kernel! (y/n)?" CONT
							if [ "$CONT" = "y" ]; then
							echo " "
							sudo apt-get update
							sudo apt-get install rpi-update -y
							sudo rpi-update
							echo " "
							echo " "
							echo "--- It's mandatory to reboot after a kernel upgrade"
							echo "--- Restart installer after rebooting..."							
							read -p "==> Reboot Now! (y/n)?" CONT
											if [ "$CONT" = "y" ]; then
											echo " "
											echo " "
											rm /home/pi/pico_installer.conf											
											sudo reboot
											exit
											echo " "							
											else
											echo " "
											echo " "						
											echo "--- Installer terminated!"
											echo "--- Good Bye"	
											rm /home/pi/pico_installer.conf							
											echo " "
											echo " "	
											exit
											fi	

							
							else
							echo " "
							echo " "						
							echo "--- Installer terminated!"
							echo "--- Good Bye"	
							rm /home/pi/pico_installer.conf							
							echo " "
							echo " "	
							exit
							fi	
 fi							

		echo "::: PIco UPS HV3.0A Install Menu"
		echo "---------------------------------------------------"
		echo "--- Please select?"
		echo " "
		options=("Install - PIco HV3.0A" "Remove - PIco HV3.0A" "Quit")
		select opt in "${options[@]}"
		do
			case $opt in
				"Install - PIco HV3.0A")
					installer=`cat /home/pi/pico_installer.conf | grep installer`	
					if [ "$installer" != "installer=1" ] ; then	
					sed -i "s,$installer,installer=1," /home/pi/pico_installer.conf
					fi		
					break			
					;;
				"Remove - PIco HV3.0A")
					installer=`cat /home/pi/pico_installer.conf | grep installer`	
					if [ "$installer" != "installer=2" ] ; then	
					sed -i "s,$installer,installer=2," /home/pi/pico_installer.conf
					fi	
					break			
					;;
				"Quit")
					installer=`cat /home/pi/pico_installer.conf | grep installer`	
					if [ "$installer" != "installer=3" ] ; then	
					sed -i "s,$installer,installer=3," /home/pi/pico_installer.conf
					fi
					break
					;;
				*) echo invalid option;;
			esac
		done
	fi

#######################################################################################################
### necessities
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
	
### Checking daemons and modules	
	picoinit="/etc/init.d/picofssd"
	picodaemon="/usr/local/bin/picofssd"	
	raspiuart=`sudo cat /boot/config.txt | grep enable_uart`
	raspii2c=`sudo cat /boot/config.txt | grep dtparam=i2c_arm`
	raspirtc=`sudo cat /boot/config.txt | grep dtoverlay=i2c-rtc | awk {'print $1'}`
	picoserviceactive=`sudo service picofssd status | grep Active | awk {'print $2'}`
	picoservicerunning=`sudo service picofssd status | grep Active | awk {'print $3'} | /usr/bin/cut -d "(" -f 2 | /usr/bin/cut -d ")" -f 1`
	i2cbcm2835module=`sudo lsmod | grep i2c_bcm2835 | awk {'print $1'}`	
	i2cdevmodule=`sudo lsmod | grep i2c_dev | awk {'print $1'}`
	i2cetcmodules=`sudo cat /etc/modules | grep i2c-dev`
	rtcds1307module=`sudo lsmod | grep rtc_ds1307 | awk {'print $1'}`
	
### Installer Checks
	installer=`sudo cat /home/pi/pico_installer.conf | grep installer`
	installerstage=`sudo cat /home/pi/pico_installer.conf | grep installerstage`
	daemoncheck=`sudo cat /home/pi/pico_installer.conf | grep daemoncheck`
	bootconfig=`sudo cat /home/pi/pico_installer.conf | grep bootconfig`
	bootconfigcheck=`sudo cat /home/pi/pico_installer.conf | grep bootconfigcheck`
	raspirepo=`sudo cat /home/pi/pico_installer.conf | grep raspirepo`	
	raspiaptget=`sudo cat /home/pi/pico_installer.conf | grep raspiaptget`
	installdaemon=`sudo cat /home/pi/pico_installer.conf | grep installdaemon`
	modules=`sudo cat /home/pi/pico_installer.conf | grep modules`

#######################################################################################################
### Start PIco Install
	
if [ "$installer" == "installer=1" ]; then	### Start 1
echo installerstage=1 >> /home/pi/pico_installer.conf
#######################################################################################################
### Welcome		
			echo " "
			echo " "	
			echo "::: PIco UPS HV3.0A Installer"
			echo "---------------------------------------------------"
			echo "--- Welcome $user,"
			echo "--- The PIco HV3.0A installer will start from here"
			echo "--- Please Standby!"
			echo " "		
			sleep 3

#######################################################################################################
### Checking for existing daemons

	if [ "$daemoncheck" != "daemoncheck=1" ] ; then	
	echo daemoncheck=1 >> /home/pi/pico_installer.conf

			echo "::: Checking for a previous daemon installation"
			echo "---------------------------------------------------"
			
			if [ "$picoserviceactive" == "inactive" ] ; then
			echo "--- No PIco service active"	
			else
			echo "--- Looks like you already installed a PIco daemon"
			echo "--- As there is a daemon active"		
			echo "--- As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
			echo "--- Installer terminated!"
			echo " "		
			rm /home/pi/pico_installer.conf		   
			exit			
		fi
			sleep 1
			
		if [ -f $picodaemon ] ; then
			echo "--- Looks like you already installed a PIco daemon"
			echo "--- As the script found some leftovers"		
			echo "--- As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
			echo "--- Installer terminated!"
			echo " "		
			rm /home/pi/pico_installer.conf		   
			exit	
			else
			echo "--- No PIco daemon file found"	
		fi	
			sleep 1
		
		if [ -f $picoinit ] ; then
			echo "--- Looks like you already installed a PIco daemon"
			echo "--- As the script found some leftovers"		
			echo "--- As advised you should use this installer on a clean Rasbian 8.0 clean/fresh install"
			echo "--- Installer terminated!"
			echo " "	
			rm /home/pi/pico_installer.conf	   
			exit	
			else
			echo "--- No PIco init file found"	
		fi
			echo "--- Done!"	
			echo " "	
			sleep 1			
	fi

#######################################################################################################
### Backing up /boot/config.txt

	if [ "$bootconfig" != "bootconfig=1" ] ; then	
	echo bootconfig=1 >> /home/pi/pico_installer.conf
			echo "::: Backing up /boot/config.txt"
			echo "---------------------------------------------------"		
			if [ -f /boot/config.txt ] && [ ! -f /boot/config.bak ]; then
			echo "--- Copied /boot/config.txt to /boot/config.bak"		
			cp /boot/config.txt /boot/config.bak
			else
			echo "--- Didn't backup /boot/config.txt"
			echo "--- As it seems there is already a backup version available"		
			fi
			echo "--- Done!"	
			echo " "	
			sleep 1		
	fi

#######################################################################################################
### Checking if /boot/config.txt has the right settings

	if [ "$bootconfigcheck" != "bootconfigcheck=1" ] ; then	
	echo bootconfigcheck=1 >> /home/pi/pico_installer.conf
			echo "::: Setting up new /boot/config.txt values"
			echo "---------------------------------------------------"
			### Enabling serial port	
			if [ "$raspiuart" == "enable_uart=1" ]; then
			echo "--- Serial port already enabled"
			elif [ "$raspiuart" == "enable_uart=0" ]; then
			echo "--- Serial port enabled"
			sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
			elif [ -z "$raspiuart" ]; then
			echo "--- Serial port enabled"
			sh -c "echo 'enable_uart=1' >> /boot/config.txt"
			elif [ "$raspiuart" != "enable_uart=1" ]; then
			echo "--- Serial port enabled"
			sed -i "s,$raspiuart,enable_uart=1," /boot/config.txt
			else
			echo "--- Error enabling serial port"
			echo "--- Please enable it via raspi-config and restart installer"	
			echo "--- Installer terminated!"
			echo " "		
			rm /home/pi/pico_installer.conf		   
			exit	
			fi
			
			sleep 1

			### Enabling i2c	
			if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
			echo "--- i2c already enabled"
			if [ "$i2cetcmodules" == "#i2c-dev" ]; then
			sed -i "s,#i2c-dev,i2c-dev," /etc/modules	
			fi			
			elif [ "$raspii2c" == "dtparam=i2c_arm-off" ]; then
			echo "--- i2c enabled"
			if [ "$i2cetcmodules" == "#i2c-dev" ]; then
			sed -i "s,#i2c-dev,i2c-dev," /etc/modules	
			fi			
			sed -i "s,$raspii2c,dtparam=i2c_arm=on," /boot/config.txt
			elif [ -z "$raspii2c" ]; then
			echo "--- i2c enabled"
			if [ "$i2cetcmodules" == "#i2c-dev" ]; then
			sed -i "s,#i2c-dev,i2c-dev," /etc/modules	
			fi			
			sh -c "echo 'dtparam=i2c_arm=on' >> /boot/config.txt"
			elif [ "$raspii2c" != "dtparam=i2c_arm=on" ]; then
			echo "--- i2c enabled"
			if [ "$i2cetcmodules" == "#i2c-dev" ]; then
			sed -i "s,#i2c-dev,i2c-dev," /etc/modules	
			fi			
			sed -i "s,$raspii2c,dtparam=i2c_arm=on," /boot/config.txt
			else
			echo "--- Error enabling i2c"
			echo "--- Please enable it via raspi-config and restart installer"	
			echo "--- Installer terminated!"
			echo " "		
			rm /home/pi/pico_installer.conf		   
			exit	
			fi
				
			sleep 1

			### Enabling rtc
			if [ "$raspirtc" == "dtoverlay=i2c-rtc,ds1307" ]; then
			echo "--- rtc already enabled"
			elif [ -z "$raspirtc" ]; then
			echo "--- rtc enabled"
			sh -c "echo 'dtoverlay=i2c-rtc,ds1307' >> /boot/config.txt"
			elif [ "$raspirtc" != "dtoverlay=i2c-rtc,ds1307" ]; then
			echo "--- rtc enabled"
			sed -i "s,$raspirtc,dtoverlay=i2c-rtc,ds1307," /boot/config.txt
			else
			echo "--- Error enabling rtc"
			echo "--- Please enable it via raspi-config and restart installer"	
			echo "--- Installer terminated!"
			echo " "		
			rm /home/pi/pico_installer.conf		   
			exit	
			fi
			
			echo "--- Done!"	
			echo " "
	fi	

#######################################################################################################
### Updating Rasbian packages list and upgrading if needed

	if [ "$raspirepo" != "raspirepo=1" ] ; then	
	echo raspirepo=1 >> /home/pi/pico_installer.conf
			echo "::: Updating $release sourcelist"
			echo "---------------------------------------------------"
			echo "--- Updating $release sourcelist"
			echo "--- This could take a awhile"	
			echo "--- Please Standby!"
			sleep 1		
			sudo apt-get update > /dev/null 2>&1	
			echo "--- Done!"	
			echo " "	
			sleep 1

			echo "::: Updating $release packages"
			echo "---------------------------------------------------"
			echo "--- Updating $release"
			echo "--- This could take a awhile"	
			echo "--- Please Standby!"
			sleep 1
			sudo apt-get upgrade -y	
			echo "--- Done!"	
			echo " "	
			sleep 1					
	fi
	
#######################################################################################################
### Checking and installing PIco necessities
	
	if [ "$raspiaptget" != "raspiaptget=1" ] ; then	
		echo raspiaptget=1 >> /home/pi/pico_installer.conf

			echo "::: Checking if necessities exists"
			echo "---------------------------------------------------"
			echo "--- Installing Pico necessities, if needed"
			echo "--- This could take a awhile"	
			echo "--- Please Standby!"
			echo " "

			if [ $pythonrpigpio -eq 1 ]; then
			echo "--- python-rpi.gpio already installed"
			sleep 1   
			else
			echo "--- Installing python-rpi.gpio"
			sudo apt-get install -y python-rpi.gpio > /dev/null 2>&1
			fi

			if [ $git -eq 3 ]; then
			echo "--- git already installed"
			sleep 1   
			else
			echo "--- Installing git"
			sudo apt-get install -y git > /dev/null 2>&1
			fi

			if [ $pythondev -eq 2 ]; then
			echo "--- python-dev already installed"
			sleep 1   
			else
			echo "--- Installing python-dev"
			sudo apt-get install -y python-dev > /dev/null 2>&1
			fi

			if [ $pythonserial -eq 1 ]; then
			echo "--- python-serial already installed"
			sleep 1   
			else
			echo "--- Installing python-serial"
			sudo apt-get install -y python-serial > /dev/null 2>&1
			fi

			if [ $pythonsmbus -eq 1 ]; then
			echo "--- python-smbus already installed"
			sleep 1   
			else
			echo "--- Installing python-smbus"
			sudo apt-get install -y python-smbus > /dev/null 2>&1
			fi

			if [ $pythonjinja2 -eq 1 ]; then
			echo "--- python-jinja2 already installed"
			sleep 1   
			else
			echo "--- Installing python-jinja2"
			sudo apt-get install -y python-jinja2 > /dev/null 2>&1
			fi

			if [ $pythonxmltodict -eq 1 ]; then
			echo "--- python-xmltodict already installed"
			sleep 1   
			else
			echo "--- Installing python-xmltodict"
			sudo apt-get install -y python-xmltodict > /dev/null 2>&1
			fi

			if [ $pythonpsutil -eq 1 ]; then
			echo "--- python-psutil already installed"
			sleep 1   
			else
			echo "--- Installing python-psutil"
			sudo apt-get install -y python-psutil > /dev/null 2>&1
			fi

			if [ $pythonpip -eq 1 ]; then
			echo "--- python-pip already installed"
			sleep 1   
			else
			echo "--- Installing python-pip"
			sudo apt-get install -y python-pip > /dev/null 2>&1
			fi

			if [ $i2ctools -eq 1 ]; then
			echo "--- i2c-tools already installed"
			sleep 1   
			else
			echo "--- Installing i2c-tools"
			sudo apt-get install -y i2c-tools > /dev/null 2>&1
			fi		

			echo "--- Done!"
			echo " "
			sleep 1
	fi

#######################################################################################################
### Installing PIco daemon and scripts
	
	if [ "$installdaemon" != "installdaemon=1" ] ; then	
	echo installdaemon=1 >> /home/pi/pico_installer.conf
			echo "::: Installing PIco daemon"
			echo "---------------------------------------------------"
			echo "--- Installing PIco scripts and daemon"
			echo "--- This could take a awhile"	
			echo "--- Please Standby!"
			echo " "
			echo "--- Cloning PiModules git"	
			git clone https://github.com/modmypi/PiModules.git	> /dev/null 2>&1
			echo "--- Installing PIco mail daemon"	
			cd PiModules/code/python/package
			sudo python setup.py install > /dev/null 2>&1
			sleep 1
			echo "--- Installing PIco fssd daemon"			
			cd ../upspico/picofssd
			sudo python setup.py install > /dev/null 2>&1
			sleep 1		
			echo "--- Set picofssd defaults to update-rc.d"	
			sudo update-rc.d picofssd defaults > /dev/null 2>&1
			sleep 1
			echo "--- Enabling picofssd daemon"			
			sudoupdate-rc.d picofssd enable > /dev/null 2>&1
			sleep 1
			echo "--- Starting picofssd daemon"
			echo "--- One moment!"			
			sudo /etc/init.d/picofssd start > /dev/null 2>&1
			sudo rm -rf /home/pi/PiModules		
			sleep 10	
			echo "--- Done!"
			echo " "
	
				echo "::: Reboot system"
			echo "---------------------------------------------------"
			echo "--- Installed PIco necessities and daemon"
			echo "--- A system reboot is mandatory at this stage"
			echo "--- Please reboot your system and restart the installer"
			echo " "
			
				read -p "==> Reboot Now! (y/n)?" CONT
				if [ "$CONT" = "y" ]; then
				echo " "
					installerstage=`cat /home/pi/pico_installer.conf | grep installerstage`
					if [ "$installerstage" == "installerstage=1" ] ; then	
					sed -i "s,$installerstage,installerstage=2," /home/pi/pico_installer.conf
					fi			
				sudo reboot
				exit
				else
				echo "--- Please reboot your system and restart the installer"
				echo "--- Installer terminated!"
					installerstage=`cat /home/pi/pico_installer.conf | grep installerstage`
					if [ "$installerstage" == "installerstage=1" ] ; then	
					sed -i "s,$installerstage,installerstage=2," /home/pi/pico_installer.conf
					fi					
				exit
				fi
	fi

fi ### end 1

if [ "$installerstage" == "installerstage=2" ]; then	### Start 3

#######################################################################################################
### continuing installation		

			echo " "	
			echo "::: PIco UPS HV3.0A Installer"
			echo "---------------------------------------------------"
			echo "--- Welcome back $user,"
			echo "--- The PIco HV3.0A installer is continuing installation"
			echo "--- Please Standby!"
			echo " "		
			sleep 3
			
#######################################################################################################
### Checking modules		

	if [ "$modules" != "modules=1" ] ; then
	echo modules=1 >> /home/pi/pico_installer.conf
			echo "::: Checking if system in PIco ready"
			echo "---------------------------------------------------"
		
### Checking if PIco service is up and running	
			if [ "$picoserviceactive" == "active" ] ; then	
			echo "--- PIco service is $picoserviceactive and $picoservicerunning"
			else
			echo "--- PIco service is $picoserviceactive and $picoservicerunning"
			fi
			sleep 1
### Checking if i2c_bcm2835 is loaded	
			if [ "$i2cbcm2835module" == "i2c_bcm2835" ]; then	
			echo "--- i2c_bcm2835 module is loaded"	
			else
			echo "--- i2c_bcm2835 module isn't loaded"		
			fi		
			sleep 1
### Checking if i2c_dev is loaded	
			if [ "$i2cdevmodule" == "i2c_dev" ]; then	
			echo "--- i2c_dev module is loaded"	
			else
			echo "--- i2c_dev module isn't loaded"
			fi		
			sleep 1
### Checking if rtc clock is up and running
		rtcclock=`sudo hwclock -r --test | grep seconds | awk {'print $1'}`
		osclock=`date | grep $rtcclock | awk {'print $1'}`

		rtcclockcompare=`sudo hwclock -r --test | grep seconds | awk {'print $5'}`
		osclockcompare=`date | grep $rtcclock | awk {'print $4'}`	
			if [ "$rtcclock" == "$osclock" ]; then	
			echo "--- RTC clock is up and running"
			sleep 1
			if [ "$rtcclockcompare" != "$osclockcompare" ]; then
			sudo hwclock -w	
			sleep 1
			echo "--- RTC clock has been synced to - "$rtcclockcompare
			fi
			else
			echo "--- RTC clock isn't detected"
			fi		
			echo "--- Done!"	
			echo " "	
			sleep 1		
	fi

#######################################################################################################
### Set battery type

	if [ "$picoserviceactive" == "active" ] && [ "$i2cbcm2835module" == "i2c_bcm2835" ] && [ "$i2cdevmodule" == "i2c_dev" ] && [ "$rtcclock" == "$osclock" ] ; then
			picobatversion=`sudo i2cget -y 1 0x6b 0x07`
			if [ "$picobatversion" == "0x50" ] ; then
			battery="LiPO (ASCII: P) version Plus"
			fi
			
			if [ "$picobatversion" == "0x53" ] ; then
			battery="LiPO (ASCII: S) version Stack/TopEnd"
			fi

			if [ "$picobatversion" == "0x51" ] ; then
			battery="LiFePO4 (ASCII: Q) version Plus"
			fi

			if [ "$picobatversion" == "0x46" ] ; then
			battery="LiFePO4 (ASCII : F) version Stack/TopEnd"
			fi				
			
			echo "::: PIco Battery type"
			echo "---------------------------------------------------"
			echo "--- Which type of battery do you've stacked onto your PIco UPS?"
			echo " "
			echo "--- Current register value tells you have stacked:"
			echo "--- $battery"
			echo "--- If this is true then select menu option (5)"			
			echo " "			
		options=("LiPO (ASCII: P) version Plus" "LiPO (ASCII: S) version Stack/TopEnd" "LiFePO4 (ASCII: Q) version Plus" "LiFePO4 (ASCII : F) version Stack/TopEnd" "Quit")
		select opt in "${options[@]}"
		do
			case $opt in
				"LiPO (ASCII: P) version Plus")
					echo "--- You chose, LiPO (ASCII: P) version Plus"
					 i2cset -y 1 0x6b 0x07 0x50
					break			
					;;
				"LiPO (ASCII: S) version Stack/TopEnd")
					echo "--- You chose, LiPO (ASCII: S) version Stack/TopEnd"
					 i2cset -y 1 0x6b 0x07 0x53
					break			
					;;
				"LiFePO4 (ASCII: Q) version Plus")
					echo "--- You chose, LiFePO4 (ASCII: Q) version Plus"
					 i2cset -y 1 0x6b 0x07 0x51
					break			
					;;
				"LiFePO4 (ASCII : F) version Stack/TopEnd")
					echo "--- You chose, LiFePO4 (ASCII : F) version Stack/TopEnd"
					 i2cset -y 1 0x6b 0x07 0x46
					break			
					;;			
				"Quit")
					break
					;;
				*) echo invalid option;;
			esac
		done	
			echo " "	
			sleep 1
			firmware=`sudo i2cget -y 1 0x69 0x26 | grep 0x | awk {'print substr($1,3); '}`
			bootloader=`sudo i2cget -y 1 0x69 0x25 | grep 0x | awk {'print substr($1,3); '}`
			pcb=`sudo i2cget -y 1 0x69 0x24 | grep 0x | awk {'print substr($1,3); '}`
			batterytype=`sudo i2cget -y 1 0x6b 0x07 | grep 0x | awk {'print substr($1,3); '}`			
			hwclockget=`sudo hwclock -r --test | grep seconds | awk {'print $1, $2, $3, $4, $5'}`		
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
			echo "::: PIco installation finished"
			echo "---------------------------------------------------"
			echo "--- If all went well then you haven't seen any error during the installation"
			echo "--- If you did see errors then please debug"
			echo "--- Also take note if there is a new firmware version to enjoy your UPS more"	
			echo " "
			echo " "
			echo "::: UPS PIco HV3.0A Status"
			echo "---------------------------------------------------"
			echo " "			
			echo "- PIco Firmware..........: "$firmware
			echo "- PIco Bootloader........: "$bootloader
			echo "- PIco PCB Version.......: "$pcb
			echo "- PIco BAT Version.......: "$battery
			echo "- HWclock................: "$hwclockget
			echo " "			
			echo "---------------------------------------------------"
			echo " "
			echo " "	
			echo "--- Installation script finished"
			echo "--- Please reboot your system"
			echo " "			
			echo "--- Good bye and enjoy your PIco HV3.0A UPS..."			
			echo " "
			echo " "
			echo " "
			cp /home/pi/pico_installer.conf	/home/pi/pico_installer_bak.conf	
			sudo rm /home/pi/pico_installer.conf
			exit	
	else
			echo "::: PIco installation finished with errors"
			echo "---------------------------------------------------"
			echo "--- Looks like something went wrong during installation"
			echo " "
			if [ "$picoserviceactive" != "active" ]; then
			echo "--> PIco daemon isn't active"
			fi

			if [ "$i2cbcm2835module" == "i2c_bcm2835" ]; then
			echo "--> i2c_bcm2835 module isn't loaded"
			fi	

			if [ "$i2cdevmodule" == "i2c_dev" ]; then
			echo "--> i2c_dev module isn't loaded"
			fi

			if [ "$rtcclock" == "$osclock" ]; then
			echo "--> rtc clock module isn't loaded"
			fi
			echo " "			
			echo "--- Please review your installation"
			echo "--- Or install UPS as per manual"
			echo "--- Installer terminated!"	
			echo " "
			cp /home/pi/pico_installer.conf	/home/pi/pico_installer_bak.conf	
			sudo rm /home/pi/pico_installer.conf			
			exit
	fi	
fi



#######################################################################################################
### Start PIco Removal		
	if [ "$installer" == "installer=2" ] ; then	
	echo " "
	echo " "	
	echo "::: PIco UPS HV3.0A removal"
	echo "---------------------------------------------------"
	echo "--- Thx $user for using PIco HV3.0A Installer"
	echo "--- All PIco necessities will be removed"
	echo " "
	echo "--- Reseting PIco UPS"
	#sudo i2cset 0x6B 0x00 0xee
	sleep 2
	echo "--- Stopping PIco daemon"
	if [ "$picoserviceactive" == "active" ]; then
	sudo /etc/init.d/picofssd stop > /dev/null 2>&1	
	fi
	sleep 1
	
	echo "--- Removing PIco i2c-tools"
	echo "--- Please Standby!"
	sudo apt-get remove i2c-tools -y > /dev/null 2>&1
	sleep 1	

	echo "--- Disabling PIco update-rc.d defaults"
	sudo update-rc.d picofssd disable > /dev/null 2>&1
	sudo update-rc.d picofssd remove > /dev/null 2>&1
	rm -rf /etc/default/picofssd > /dev/null 2>&1
	rm -rf /usr/local/lib/python2.7/dist-packages/picofssd-0.1dev-py2.7.egg-info > /dev/null 2>&1	
	sleep 1
	
	echo "--- Removing PIco daemon"	
	if [ -f $picodaemon ] ; then
	rm $picodaemon > /dev/null 2>&1
	fi
	sleep 1

	echo "--- Removing PIco init file"	
	if [ -f $picoinit ] ; then
	rm $picoinit > /dev/null 2>&1
	fi
	sleep 1
	
	echo "--- Removing PIco mail daemon"
	rm -rf /etc/pimodules > /dev/null 2>&1
	rm -rf /usr/local/bin/picofssdxmlconfig > /dev/null 2>&1
	sleep 1

	if [ "$raspii2c" == "dtparam=i2c_arm=on" ]; then
	echo "--- Committing out i2c overlay from /boot/config.txt"
	sed -i "s,dtparam=i2c_arm=on,#dtparam=i2c_arm=on," /boot/config.txt	
	fi
	sleep 1
	
	if [ "$i2cetcmodules" == "i2c-dev" ]; then
	echo "--- Committing out i2c module from /etc/modules"
	sed -i "s,i2c-dev,#i2c-dev," /etc/modules	
	fi
	sleep 1
	
	if [ "$raspiuart" == "enable_uart=1" ]; then	
	echo "--- Committing out PIco uart from /boot/config.txt"
	sed -i "s,enable_uart=1,#enable_uart=1," /boot/config.txt	
	fi
	sleep 1
	
	if [ "$raspirtc" == "dtoverlay=i2c-rtc,ds1307" ]; then
	echo "--- Committing out PIco rtc overlay from /boot/config.txt"
	sed -i "s,$raspirtc,#dtoverlay=i2c-rtc,ds1307," /boot/config.txt
	fi
	sleep 1
		
			echo " "	
			echo "--- Removal script finished"
			echo "--- Please reboot your system"		
			echo "--- Good bye..."			
			echo " "
	rm /home/pi/pico_installer.conf
	exit
	fi

#######################################################################################################
### Quit PIco Install Menu	
	if [ "$installer" == "installer=3" ] ; then
	echo " "
	echo " "	
	echo "::: PIco UPS HV3.0A Installer Terminated"
	echo "---------------------------------------------------"
	echo "--- Thx $user for using PIco HV3.0A Installer"
	echo "--- Installer terminated!"
	echo " "	
	rm /home/pi/pico_installer.conf	
	fi
