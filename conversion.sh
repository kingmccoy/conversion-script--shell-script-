#!/bin/bash

clear

#######################################################
#                                                     #
#   AUTOMATED CONVERSION PROGRAM BASH SHELL SCRIPT    #
#           by: TEST ENGINEERING DEPARTMENT           #
#                    Version 6.0                      #
#                                                     #
#######################################################

# Changes v5.0: Adding lotid to conversion
# Changes v6.0: Bug Fixes; New: Checked recent conversion LOTID, FIRMWARE, BOOTLOADER, and FLASH at the same time. Before: Checked recent conversion. LOTID first then followed by FIRMWARE, BOOTLOADER, and FLASH

#######################################################
#----------Remove # for dedidated directory-----------#
#######################################################

#-----------------------Demo--------------------------#

# RS9113 Calibration Conversion Home

	# home=/mnt/d/Documents/Macky/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/release/
	# directory=/mnt/d/Documents/Macky/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/release/flash/WC/
	# makedirectory=/mnt/d/Documents/Macky/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/
	# versions=/mnt/d/Documents/Macky/SavingScript/work/versions/
	# firmwares=/mnt/d/Documents/Macky/SavingScript/work/versions/firmware/
	# bootloaders=/mnt/d/Documents/Macky/SavingScript/work/versions/bootloader/
	# flashdirectory=/mnt/d/Documents/Macky/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/utils/
	# lotdirectory=/mnt/d/Documents/Macky/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/release/flash/

# RS9113 Calibration Coversion Office

	home=/mnt/d/macky_program/bash_shell_script/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P8/Driver_slave/wlan_slave/release/
	directory=/mnt/d/macky_program/bash_shell_script/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P8/Driver_slave/wlan_slave/release/flash/WC/
	makedirectory=/mnt/d/macky_program/bash_shell_script/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P8/Driver_slave/wlan_slave/
	versions=/mnt/d/macky_program/bash_shell_script/SavingScript/work/versions/
	firmwares=/mnt/d/macky_program/bash_shell_script/SavingScript/work/versions/firmware/
	bootloaders=/mnt/d/macky_program/bash_shell_script/SavingScript/work/versions/bootloader/
	flashdirectory=/mnt/d/macky_program/bash_shell_script/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P8/Driver_slave/wlan_slave/utils/
	lotdirectory=/mnt/d/macky_program/bash_shell_script/SavingScript/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P8/Driver_slave/wlan_slave/release/flash/

#######################################################

#---------------------Production----------------------#

# RS9113 Calibration

	# home=/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/release/
	# directory=/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/release/flash/WC/
	# makedirectory=/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/
	# versions=/work/versions/
	# firmwares=/work/versions/firmware/
	# bootloaders=/work/versions/bootloader/
	# flashdirectory=/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/utils/
	# lotdirectory=/work/Mfg_Softwares/RS9113_Module_MfgSoftware_V4P3/Driver_slave/wlan_slave/release/flash/

#######################################################

echo -e "\n\e[34m#######################################################"
echo "#                                                     #"
echo "#      >>>>> SILABS CALIBRATION CONVERSION <<<<<      #"
echo "#                                                     #"
echo -e "#######################################################\n\e[0m"

# Checking WC folder
if [[ -d $directory ]]; then
	cd $directory
else
	echo -e "No such folder \e[1mWC\e[0m"
	echo -e "\n\e[31mExiting command...\e[0m"
	exit
fi

fwbl=versions
firmdir=firmware
firmdirs=firmwares
bootdir=bootloader
bootdirs=bootloaders
fwrps=$firmdir.rps
blrps=$bootdir.rps
wc=WC

# List firmware
firmware() {
	ls RS9113.NBZ.WC*OSI*.rps
}

# List bootloader
bootloader() {
	ls RS9113_WC_BL*.rps
}

# Select flash type
chkft() {
	echo -e "\n\e[94mPlease select required flash\e[0m"
	cd $flashdirectory

	selectedmicron="$(sed -n 30p Makefile)" || read $selectedmicron
	selectedmacronix="$(sed -n 32p Makefile)" || read $selectedmacronix

	if [[ $selectedmicron = "#DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
		select flashtype in Micron;
		do
			if [[ $flashtype == ""  ]]; then
				echo -e "\e[96m>>> \e[31mPlease select the number corresponding to flash\e[0m"
			else
				echo -e "\nFlash \e[91m$flashtype\e[0m selected"
				break;
			fi
		done
	else
		if [[ $selectedmicron = "DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "#DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
			select flashtype in Macronix;
			do
				if [[ $flashtype == ""  ]]; then
					echo -e "\e[96m>>> \e[31mPlease select the number corresponding to flash\e[0m"
				else
					echo -e "\nFlash \e[91m$flashtype\e[0m selected"
					break;
				fi
			done
		fi
	fi

}

# Reselecting firmware, bootloader, and flash
reselectingfwblft() {
	echo -e "\n\e[95m>>> Checking LOTID, FIRMWARE, BOOTLOADER and FLASH after make command <<<\e[0m"

	lot
	
	cd $directory
	echo -e "\n\e[33mFIRMWARE\e[0m"
	firmware=$(ls RS9113.NBZ.WC*OSI*.rps)
	echo $firmware

	echo -e "\n\e[33mBOOTLOADER\e[0m"
	bootloader=$(ls RS9113_WC_BL*.rps)
	echo $bootloader

	ft
	
	qfwblft() {
		echo -n -e "\nIs the above Lot ID, Firmware, Bootloader and Flash correct? \e[1mY/N  :\e[0m""  "
		read fwblftverification
	}

	ynfwblftreselecting() {
		case $fwblftverification in
			[Yy]|[Yy][Ee][Ss])
				echo -e "\n\e[32mConversion finished\e[0m"
				cd $home
				history -c
				exit
				;;
			[Nn]|[Nn][Oo])
				echo -e "\n\e[32mReselecting FIRMWARE, BOOTLOADER and FLASH\e[0m"
				chkrecentlotid
				firmwarechangeqry
				;;
			"")
				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
				qfwblft
				ynfwblftreselecting
				;;
			*)
				echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
				qfwblft
				ynfwblftreselecting
				;;
		esac

		# if [[ $fwblftverification == "Y" || $fwblftverification == "y" || $fwblftverification == "YES" || $fwblftverification == "Yes" || $fwblftverification == "yes" ]]; then
		# 	echo -e "\n\e[32mConversion finished\e[0m"
		# 	cd $home
		# 	history -c
		# 	exit
		# else
		# 	if [[ $fwblftverification == "N" || $fwblftverification == "n" || $fwblftverification == "NO" || $fwblftverification == "No" || $fwblftverification == "no" ]]; then
		# 		echo -e "\n\e[32mReselecting FIRMWARE, BOOTLOADER and FLASH\e[0m"
		# 		chkrecentlotid
		# 		firmwarechangeqry
		# 	else
		# 		if [[ $fwblftverification != "" ]]; then
		# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
		# 			qfwblft
		# 			ynfwblftreselecting
		# 		else
		# 			if [[ $fwblftverification == "" ]]; then
		# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
		# 				qfwblft
		# 				ynfwblftreselecting
		# 			fi
		# 		fi
		# 	fi
		# fi
	}

	qfwblft
	ynfwblftreselecting
}

# Verity firmware, bootloader, and flash type after being converted
fwblftchecking() {
	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes yes yes yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes yes yes yes good"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no no no no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no no no no good"
					echo -e "\n\e[32m#######################################################"
					echo -e "#\e[34m-----------------\e[0mNO\e[34m-\e[0mCONVERTION\e[34m-\e[0mMADE\e[34m------------------\e[32m#"
					echo -e "#######################################################\e[0m"
					echo -e "\n\e[31mExiting conversion\e[0m"
					exit
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes yes yes no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes yes yes no good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes yes no no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "no" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes yes no no good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes no no no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes no no no good"
					echo -e "\n\e[32m#######################################################"
					echo -e "#\e[34m-------------------\e[0mLOT\e[34m-\e[0mID\e[34m-\e[0mCONVERTED\e[34m------------------\e[32m#"
					echo -e "#######################################################\e[0m"
					reselectingfwblft
					exit
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no no no yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no no no yes good"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no no yes yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no no yes yes good"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no yes yes yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no yes yes yes good"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes no no yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes no no yes good"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no yes yes no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no yes yes no good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes no yes no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes no yes no good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no yes no yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no yes no yes good"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes yes no yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes yes no yes good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#no yes no no Result
	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
		if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
			if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
				if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
					# echo "no yes no no good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi	

	#LT FW BL FT Result (Lot) (Firmware) (Bootloader) (Flash Type)
	#yes no yes yes Result
	if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
		if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
			if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
				if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
					# echo "yes no yes yes good"
					echo -e "\n\e[32mMaking...\e[0m\n"
					makefile
				fi
			fi
		fi
	fi
}

# Compiling MFG (Make command)
makefile() {
	cd $makedirectory
	make

	makeui() {
		echo -n -e "\nMake success?   \e[1mY/N  :\e[0m""  "
		read makeresult

		case $makeresult in
			[Yy]|[Yy][Ee][Ss])
				echo -e "\n\e[32m#######################################################"
				echo -e "#\e[34m-----------------\e[0mSTATION\e[34m-\e[0mCONVERTED\e[34m-------------------\e[32m#"
				echo -e "#######################################################\e[0m"
				reselectingfwblft
				;;
			[Nn]|[Nn][Oo])
				echo -e "\n\e[32m>>> \e[31mPlease restart the computer!\e[0m\n"
				echo -e "\e[31mExiting conversion\e[0m"
				cd $home
				history -c
				exit
				;;
			"")
				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
				makeui
				;;
			*)
				echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
				makeui
				;;
		esac
		
		# if [[ $makeresult == "Y" || $makeresult == "y" || $makeresult == "YES" || $makeresult == "Yes" || $makeresult == "yes" ]]; then
		# 	echo -e "\n\e[32m#######################################################"
		# 	echo -e "#\e[34m-----------------\e[0mSTATION\e[34m-\e[0mCONVERTED\e[34m-------------------\e[32m#"
		# 	echo -e "#######################################################\e[0m"
		# 	reselectingfwblft
		# else
		# 	if [[ $makeresult == "N" || $makeresult == "n" || $makeresult == "NO" || $makeresult == "No" || $makeresult == "no" ]]; then
		# 		echo -e "\n\e[32m>>> \e[31mPlease restart the computer!\e[0m\n"
		# 		echo -e "\e[31mExiting conversion\e[0m"
		# 		cd $home
		# 		history -c
		# 		exit
		# 	else
		# 		if [[ $makeresult != "" ]]; then
		# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
		# 			makeui
		# 		else
		# 			if [[ $makeresult == "" ]]; then
		# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
		# 				makeui
		# 			fi
		# 		fi
		# 	fi
		# fi
	}
	makeui
}

# Append firmware and bootloader
appendfwbl() {
	echo -e "\n\e[32mAppending...\e[0m\n"

	append() {
		cd $directory

		firmware=$(ls RS9113.NBZ.WC*OSI*.rps)
		bootloader=$(ls RS9113_WC_BL*.rps)

		./append_fw_single_image.sh $firmware $bootloader

		appendqry(){
			echo -n -e "\nAppending success?   \e[1mY/N  :\e[0m""  "
			read appendresult

			case $appendresult in
				[Yy]|[Yy][Ee][Ss])
					reselectingfwbl
					;;
				[Nn]|[Nn][Oo])
					echo -e "\n\e[32mRe-appending...\e[0m\n"
					append
					;;
				"")
					echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
					appendqry
					;;
				*)
					echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
					appendqry
					;;
			esac
			
			# if [[ $appendresult == "Y" || $appendresult == "y" || $appendresult == "YES" || $appendresult == "Yes" || $appendresult == "yes" ]]; then
			# 	reselectingfwbl
			# else
			# 	if [[ $appendresult == "N" || $appendresult == "n" || $appendresult == "NO" || $appendresult == "No" || $appendresult == "no" ]]; then
			# 		echo -e "\n\e[32mRe-appending...\e[0m\n"
			# 		append
			# 	else
			# 		if [[ $appendresult != "" ]]; then
			# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
			# 			appendqry
			# 		else
			# 			if [[ $appendresult == "" ]]; then
			# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
			# 				appendqry
			# 			fi
			# 		fi
			# 	fi
			# fi
		}
		appendqry
	}
	append
}

# Append firmware and booloader selection
appendingui() {
	cd $directory
	
	if [[ $changefirmware == RS9113.NBZ.WC*OSI*.rps && $changebootloader == RS9113_WC_BL*.rps ]]; then
		appendfwbl
	else
		if [[ $changefirmware != RS9113.NBZ.WC*OSI*.rps && $changebootloader != RS9113_WC_BL*.rps ]]; then
			flashtypechangeqry
		else
			if [[ $changefirmware == RS9113.NBZ.WC*OSI*.rps && $changebootloader != RS9113_WC_BL*.rps ]]; then
				appendfwbl
			else
				if [[ $changefirmware != RS9113.NBZ.WC*OSI*.rps && $changebootloader == RS9113_WC_BL*.rps ]]; then
					appendfwbl
				fi
			fi
		fi
	fi
}

# Select Firmware
chkfws() {
	echo -e "\n\e[94mPlease select required firmware\e[0m"
	cd $firmwares

	select changefirmware in *;
	do
		if [[ $changefirmware == ""  ]]; then
			echo -e "\e[32m>>> \e[31mPlease select the number corresponding to firmware\e[0m"
			else
			echo -e "\nFirmware \e[91m$changefirmware\e[0m selected"
			break;
		fi
	done
	changefwyesoption
}

# Select bootloader
chkbls() {
	echo -e "\n\e[94mPlease select required bootloader\e[0m"
	cd $bootloaders

	select changebootloader in *;
	do
		if [[ $changebootloader == "" ]]; then
			echo -e "\e[32m>>> \e[31mPlease select the number corresponding to bootloader\e[0m"
		else
			echo -e "\nBootloader \e[91m$changebootloader\e[0m selected"
			break;
		fi
	done
	changeblyesoption
}

# Move bootloader
cpmvbootloader() {
	bootloader=$(ls RS9113_WC_BL*.rps)
	mv $directory$bootloader $bootloaders
	mv $bootloaders$changebootloader $directory
	fwblchecking
}

# Flash type change query
flashtypechangeqry() {
	echo -n -e "\nProceed to flash change?      \e[1mY/N  :\e[0m""  "
	read changeflashtype

	cd $flashdirectory
	selectedmicron="$(sed -n 30p Makefile)" || read $selectedmicron
	selectedmacronix="$(sed -n 32p Makefile)" || read $selectedmacronix

	case $changeflashtype in
		[Yy]|[Yy][Ee][Ss])
			changeflashtypeyesoption() {
				if [[ $selectedmicron = "#DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
					sed -i '32 s/DEBUG_FLAG += -D MACRONIX_FLASH/#DEBUG_FLAG += -D MACRONIX_FLASH/' $flashdirectory/Makefile && sed -i '30 s/#DEBUG_FLAG += -D MICRON_FLASH/DEBUG_FLAG += -D MICRON_FLASH/' $flashdirectory/Makefile
					echo -e "\n\e[32mMaking...\e[0m\n"
					fwblftchecking
					exit
				else
					if [[ $selectedmicron = "DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "#DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
						sed -i '32 s/#DEBUG_FLAG += -D MACRONIX_FLASH/DEBUG_FLAG += -D MACRONIX_FLASH/' $flashdirectory/Makefile && sed -i '30 s/DEBUG_FLAG += -D MICRON_FLASH/#DEBUG_FLAG += -D MICRON_FLASH/' $flashdirectory/Makefile
						echo -e "\n\e[32mMaking...\e[0m\n"
						fwblftchecking
					fi
				fi
			}

			requiredft() {
				chkft
				changeflashtypeyesoption
			}

		requiredft
			;;
		[Nn]|[Nn][Oo])
			fwblftchecking
			;;
		"")
			echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
			flashtypechangeqry
			;;
		*)
			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
			flashtypechangeqry
			;;
	esac

	# if [[ $changeflashtype == "Y" || $changeflashtype == "y" || $changeflashtype == "YES" || $changeflashtype == "Yes" || $changeflashtype == "yes" ]]; then
	# 	changeflashtypeyesoption() {
	# 		if [[ $selectedmicron = "#DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
	# 			sed -i '32 s/DEBUG_FLAG += -D MACRONIX_FLASH/#DEBUG_FLAG += -D MACRONIX_FLASH/' $flashdirectory/Makefile && sed -i '30 s/#DEBUG_FLAG += -D MICRON_FLASH/DEBUG_FLAG += -D MICRON_FLASH/' $flashdirectory/Makefile
	# 			echo -e "\n\e[32mMaking...\e[0m\n"
	# 			fwblftchecking
	# 			exit
	# 		else
	# 			if [[ $selectedmicron = "DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "#DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
	# 				sed -i '32 s/#DEBUG_FLAG += -D MACRONIX_FLASH/DEBUG_FLAG += -D MACRONIX_FLASH/' $flashdirectory/Makefile && sed -i '30 s/DEBUG_FLAG += -D MICRON_FLASH/#DEBUG_FLAG += -D MICRON_FLASH/' $flashdirectory/Makefile
	# 				echo -e "\n\e[32mMaking...\e[0m\n"
	# 				fwblftchecking
	# 			fi
	# 		fi
	# 	}

	# 	requiredft() {
	# 		chkft
	# 		changeflashtypeyesoption
	# 	}

	# 	requiredft
	# else
	# 	if [[ $changeflashtype == "N" || $changeflashtype == "n" || $changeflashtype == "NO" || $changeflashtype == "No" || $changeflashtype == "no" ]]; then
	# 		fwblftchecking
	# 	else
	# 		if [[ $changeflashtype != "" ]]; then
	# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
	# 			flashtypechangeqry
	# 		else
	# 			if [[ $changeflashtype == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
	# 				flashtypechangeqry
	# 			fi				
	# 		fi
	# 	fi
	# fi
}

# Bootloader change query
bootloaderchangeqry() {
	echo -n -e "\nProceed to bootloader change? \e[1mY/N  :\e[0m""  "
	read blchki

	case $blchki in
		[Yy]|[Yy][Ee][Ss])
			changeblyesoption() {
				chkblexist() {
					cd $directory
					if [[ $changebootloader == RS9113_WC_BL*.rps ]]; then
						cpmvbootloader
					fi
				}

				if [[ -f "$bootloaders$changebootloader" ]]; then
					chkblexist
				else
					if [[ $changebootloader == "" ]]; then
						echo -e "\e[32m>>> \e[31mInput cannot be blank! Please select bootloader.\e[0m"
						requiredbl
					else
						echo -e "\e[31mbootloader $changebootloader doesn't exist! Please try again.\e[0m"
						requiredbl
					fi
				fi
			}
	
			requiredbl() {
				chkbls
			}
	
			requiredbl
			;;
		[Nn]|[Nn][Oo])
			fwblchecking
			#appendingui
			;;
		"")
			echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
			bootloaderchangeqry
			;;
		*)
			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
			bootloaderchangeqry
			;;
	esac

	# if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
	# 	changeblyesoption() {
	# 		chkblexist() {
	# 			cd $directory
	# 			if [[ $changebootloader == RS9113_WC_BL*.rps ]]; then
	# 				cpmvbootloader
	# 			fi
	# 		}

	# 		if [[ -f "$bootloaders$changebootloader" ]]; then
	# 			chkblexist
	# 		else
	# 			if [[ $changebootloader == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please select bootloader.\e[0m"
	# 				requiredbl
	# 			else
	# 				echo -e "\e[31mbootloader $changebootloader doesn't exist! Please try again.\e[0m"
	# 				requiredbl
	# 			fi
	# 		fi
	# 	}
	
	# 	requiredbl() {
	# 		chkbls
	# 	}
	
	# 	requiredbl
	# else
	# 	if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
	# 		fwblchecking
	# 		#appendingui
	# 	else
	# 		if [[ $blchki != "" ]]; then
	# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
	# 			bootloaderchangeqry
	# 		else
	# 			if [[ $blchki == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
	# 				bootloaderchangeqry
	# 			fi				
	# 		fi
	# 	fi	
	# fi
}

# Firmware change query
firmwarechangeqry() {
	echo -n -e "\nProceed to firmware change?   \e[1mY/N  :\e[0m""  "
	read fwchki

	case $fwchki in
		[Yy]|[Yy][Ee][Ss])
			#Check list of firmwares
			changefwyesoption() {
				chkfwexist() {
					cd $directory
					if [[ $changefirmware == RS9113.NBZ.WC*OSI*.rps ]]; then
						cpmvfirmware
					fi
				}

				if [[ -f "$firmwares$changefirmware" ]]; then
					chkfwexist
				else
					if [[ $changefirmware == "" ]]; then
						echo -e "\e[32m>>> \e[31mInput cannot be blank! Please select firmware.\e[0m"
						requiredfw
					else
						echo -e "\e[31mFirmware $changefirmware doesn't exist! Please try again.\e[0m"
						requiredfw
					fi
				fi
			}

			requiredfw() {
				chkfws
			}

			requiredfw
			;;
		[Nn]|[Nn][Oo])
			bootloaderchangeqry
			;;
		"")
			echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
			firmwarechangeqry
			;;
		*)
			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
			firmwarechangeqry
			;;
	esac
	
	# if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
	# 	#Check list of firmwares
	# 	changefwyesoption() {
	# 		chkfwexist() {
	# 			cd $directory
	# 			if [[ $changefirmware == RS9113.NBZ.WC*OSI*.rps ]]; then
	# 				cpmvfirmware
	# 			fi
	# 		}

	# 		if [[ -f "$firmwares$changefirmware" ]]; then
	# 			chkfwexist
	# 		else
	# 			if [[ $changefirmware == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please select firmware.\e[0m"
	# 				requiredfw
	# 			else
	# 				echo -e "\e[31mFirmware $changefirmware doesn't exist! Please try again.\e[0m"
	# 				requiredfw
	# 			fi
	# 		fi
	# 	}

	# 	requiredfw() {
	# 		chkfws
	# 	}

	# 	requiredfw
	# else
	# 	if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
	# 		bootloaderchangeqry
	# 	else
	# 		if [[ $fwchki != "" ]]; then
	# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
	# 			firmwarechangeqry
	# 		else
	# 			if [[ $fwchki == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
	# 				firmwarechangeqry
	# 			fi				
	# 		fi
	# 	fi
	# fi	
}

# Lot ID change query
lotidchangeqry() {
	echo -n -e "\nProceed to lot id change?     \e[1mY/N  :\e[0m""  "
	read lotchki

	case $lotchki in
		[Yy]|[Yy][Ee][Ss])
			echo -n -e "\nConvert with lot id?          \e[1mY/N  :\e[0m""  "
			read lotn

			lotnumber() {
				echo -e -n "\nPlease enter the lot number        :\e[0m""  "
				read lot
				
				if [[ ! $lot =~ ^71[0-9]{5}\.[0-9]{1,2}$ ]]; then
					echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
					lotnumber
				# else
					# echo
					# chkrecentfwblft
					# chkrecentlnfwblft
					# firmwarechangeqry
				fi
			}

			lotdate() {
				echo -e -n "\nPlease enter the datecode          :\e[0m""  "
				read lot

				if [[ ! $lot =~ ^[0-9]{2}[0-9]{2}[0-9]{4}$ ]]; then
					echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
					lotdate
				# else
					# echo
					# chkrecentfwblft
					# firmwarechangeqry
				fi
			}

			case $lotn in
				[Yy]|[Yy][Ee][Ss])
					lotnumber
					cd $lotdirectory
					sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
					firmwarechangeqry
					;;
				[Nn]|[Nn][Oo])
					lotdate
					cd $lotdirectory
					sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
					firmwarechangeqry
					;;
				*)
					echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
					lotidchangeqry
					;;
			esac 

			# if [[ $lotn == "Y" || $lotn == "y" || $lotn == "YES" || $lotn == "Yes" || $lotn == "yes" ]]; then
			# 	lotnumber
			# 	cd $lotdirectory
			# 	sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
			# 	firmwarechangeqry
			# else
			# 	if [[ $lotn == "N" || $lotn == "n" || $lotn == "NO" || $lotn == "No" || $lotn == "no" ]]; then
			# 		lotdate
			# 		cd $lotdirectory
			# 		sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
			# 		firmwarechangeqry
			# 	else
			# 		echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
			# 		lotidchangeqry
			# 	fi	
			# fi
			;;
		[Nn]|[Nn][Oo])
			# echo
			# chkrecentfwblft
			firmwarechangeqry
			;;
		*)
			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
			lotidchangeqry
			;;
	esac

	# if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
	# 	echo -n -e "\nConvert with lot id?          \e[1mY/N  :\e[0m""  "
	# 	read lotn

	# 	lotnumber() {
    # 		echo -e -n "\nPlease enter the lot number        :\e[0m""  "
 	# 		read lot
			
    # 		if [[ ! $lot =~ ^71[0-9]{5}\.[0-9]{1,2}$ ]]; then
	# 	        echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
   	# 	   		lotnumber
	# 		# else
	# 			# echo
	# 			# chkrecentfwblft
	# 			# chkrecentlnfwblft
	# 			# firmwarechangeqry
   	# 		fi
	# 	}

	# 	lotdate() {
	# 		echo -e -n "\nPlease enter the datecode          :\e[0m""  "
    # 		read lot

	#    		if [[ ! $lot =~ ^[0-9]{2}[0-9]{2}[0-9]{4}$ ]]; then
	#        		echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
    #    			lotdate
	# 		# else
	# 			# echo
	# 			# chkrecentfwblft
	# 			# firmwarechangeqry
	# 		fi
	# 	}

	# 	if [[ $lotn == "Y" || $lotn == "y" || $lotn == "YES" || $lotn == "Yes" || $lotn == "yes" ]]; then
	# 		lotnumber
	# 		cd $lotdirectory
	# 		sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
	# 		firmwarechangeqry
	# 	else
	#     	if [[ $lotn == "N" || $lotn == "n" || $lotn == "NO" || $lotn == "No" || $lotn == "no" ]]; then
	# 			lotdate
	# 			cd $lotdirectory
	# 			sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
	# 			firmwarechangeqry
	# 		else
	# 	        echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
	# 			lotidchangeqry
	# 		fi	
	# 	fi
	# else
	# 	if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
	# 		# echo
	# 		# chkrecentfwblft
	# 		firmwarechangeqry
	# 	else
	# 		echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
	# 		lotidchangeqry
	# 	fi
	# fi
}

# Move from WC to refence directory firmware vice versa
cpmvfirmware() {
	firmware=$(ls RS9113.NBZ.WC*OSI*.rps)
	mv $directory$firmware $firmwares
	mv $firmwares$changefirmware $directory
	bootloaderchangeqry
}

ynfwblreselecting() {
	case $fwblverification in
		[Yy]|[Yy][Ee][Ss])
			flashtypechangeqry
			;;
		[Nn]|[Nn][Oo])
			echo -e "\n\e[32mReselecting LOT ID, FIRMWARE and BOOTLOADER\e[0m"
			lotidchangeqry
			firmwarechangeqry
			;;
		"")
			echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
			qfwbl
			ynfwblreselecting
			;;
		*)
			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
			qfwbl
			ynfwblreselecting
			;;
	esac

	# if [[ $fwblverification == "Y" || $fwblverification == "y" || $fwblverification == "YES" || $fwblverification == "Yes" || $fwblverification == "yes" ]]; then
	# 	flashtypechangeqry
	# else
	# 	if [[ $fwblverification == "N" || $fwblverification == "n" || $fwblverification == "NO" || $fwblverification == "No" || $fwblverification == "no" ]]; then
	# 		echo -e "\n\e[32mReselecting LOT ID, FIRMWARE and BOOTLOADER\e[0m"
	# 		lotidchangeqry
	# 		firmwarechangeqry
	# 	else
	# 		if [[ $fwblverification != "" ]]; then
	# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
	# 			qfwbl
	# 			ynfwblreselecting
	# 		else
	# 			if [[ $fwblverification == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mInput cannot be blank! Please type \e[1mY/N\e[0m\e[31m.\e[0m"
	# 				qfwbl
	# 				ynfwblreselecting
	# 			fi
	# 		fi
	# 	fi
	# fi
}

reselectingfwbl() {
	echo -e "\n\e[95m>>> Checking LOT ID, FIRMWARE and BOOTLOADER after Appending <<<\e[0m"
	lot
	cd $directory
	echo -e "\n\e[33mFIRMWARE\e[0m"
	firmware=$(ls RS9113.NBZ.WC*OSI*.rps)
	echo $firmware
	echo -e "\n\e[33mBOOTLOADER\e[0m"
	bootloader=$(ls RS9113_WC_BL*.rps)
	echo $bootloader

	qfwbl() {
		echo -n -e "\nIs the above Lot ID, Firmware and Bootloader correct? \e[1mY/N  :\e[0m""  "
		read fwblverification
	}

	qfwbl
	ynfwblreselecting
}

fwblchecking() {
	#LT FW BL result
	#yes yes yes result
	if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
		if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
			if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
				appendfwbl
			fi
		fi
	fi

	#LT FW BL result
	#no no no result
	if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
		if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
			if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
				flashtypechangeqry
			fi
		fi
	fi

	#LT FW BL result
	#yes yes no result
	if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
		if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
			if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
				appendfwbl
			fi
		fi
	fi

	#LT FW BL result
	#yes no no result
	if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
		if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
			if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
				flashtypechangeqry
			fi
		fi
	fi

	#LT FW BL result
	#no no yes result
	if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
		if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
			if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
				appendfwbl
			fi
		fi
	fi

	#LT FW BL result
	#no yes yes result
	if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
		if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
			if [[  $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
				appendfwbl
			fi
		fi
	fi

	#LT FW BL result
	#yes no yes result
	if [[ $blchki == "Y" || $blchki == "y" || $blchki == "YES" || $blchki == "Yes" || $blchki == "yes" ]]; then
		if [[ $fwchki == "N" || $fwchki == "n" || $fwchki == "NO" || $fwchki == "No" || $fwchki == "no" ]]; then
			if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
				appendfwbl
			fi
		fi
	fi

	#LT FW BL result
	#no yes no result
	if [[ $blchki == "N" || $blchki == "n" || $blchki == "NO" || $blchki == "No" || $blchki == "no" ]]; then
		if [[ $fwchki == "Y" || $fwchki == "y" || $fwchki == "YES" || $fwchki == "Yes" || $fwchki == "yes" ]]; then
			if [[  $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
				appendfwbl
			fi
		fi
	fi
}

# Checking for recent lot id, firmware, boot loader and flash used
chkrecentlnfwblft() {
	echo -e "\e[95m>>> Checking for LOT ID, FIRMWARE, BOOTLOADER and FLASH used <<<\e[0m"
		
	lsfw=RS9113.NBZ.WC*OSI*.rps
	lsbl=RS9113_WC_BL*.rps

	appendchanges() {
		bl

		firmware=$(ls RS9113.NBZ.WC*OSI*.rps)
		bootloader=$(ls RS9113_WC_BL*.rps)

		echo -e "\n\e[32mAppending...\e[0m\n"	
		./append_fw_single_image.sh $firmware $bootloader

		result() {
			echo -e "\n\e[96m>>>\e[0m \e[33mAppend was performed for safety purposes\e[0m"
			echo -e "\nAppend result"
			select result in Success Failed;
			do
				check() {
					case $result in
						Success)
						echo -e "\n\e[32mMaking...\e[0m\n"
						# echo "chkrecentfwblft"
						echo "chkrecentlnfwblft"
							return 0
						;;

						Failed)
							echo -e "\n\e[32mRe-appending...\e[0m\n"
							./append_fw_single_image.sh $firmware $bootloader
							result
						;;
						
						*) echo -e "\e[32m>>> \e[31mError selection\e[0m"
						result
					esac
				}
				check
				break
			done
			makefile
		}
		result
	}

	#LOTID
	lot() {
		echo -e "\n\e[33mLOTID\e[0m"
		cd $lotdirectory
		
		lotid="$(sed -n 82p RSI_Config.txt)" || read $lotid
		substr="${lotid:6:10}"
		echo $substr		
	}

	#FIRMWARE
	fw() {
		echo -e "\n\e[33mFIRMWARE\e[0m"
		cd $directory
		
		multifwrpsselect=$(ls $lsfw 2> /dev/null)
		multifwrps=$(find $directory -maxdepth 1 -name "$lsfw" | wc -l)
	
		if [ $multifwrps -gt 1 ]; then
			echo "$multifwrps $firmdirs found"
			echo -e "Multiple $firmdir is not allowed, select only one."
			echo -e "\nSelect one $firmdir to remain"
			select multifwwc in $multifwrpsselect;
			do
				if [[ $multifwwc == ""  ]]; then
					echo -e "\e[96m>>> \e[31mPlease select the number corresponding to $firmdir\e[0m"
				else
					echo -e "\nFirmware \e[91m$multifwwc\e[0m selected"
					mv "$multifwwc" "tempfw.rps"
					mv $multifwrpsselect $firmwares 2> /dev/null
					mv "tempfw.rps" $multifwwc
					break
				fi
			done
			appendchanges
			echo -e "\n\e[95m>>> Checking for FIRMWARE, BOOTLOADER and FLASH used <<<\e[0m"
			fw
		else
			if [ -f RS9113.NBZ.WC*OSI*.rps ]; then
				firmware
			else
				nfw=$(echo "Firmware not found")
				echo $nfw
				echo -e "\n\e[31m$wc->\e[0m"
				echo -e "\e[96m>>>\e[0m Manually copy a single firmware to the \e[1m$wc\e[0m directory before proceeding"
				bl
				echo -e "\n\e[31mAborting conversion\e[0m"
				exit
			fi
		fi
	}

	#BOOTLOADER
	bl() {
		echo -e "\n\e[33mBOOTLOADER\e[0m"
		cd $directory

		multiblrpsselect=$(ls $lsbl 2> /dev/null)
		multiblrps=$(find $directory -maxdepth 1 -name "$lsbl" | wc -l)

		if [ $multiblrps -gt 1 ]; then
			echo "$multiblrps $bootdirs found"
			echo "Multiple $bootdir is not allowed, select only one."
			echo -e "\nSelect one $bootdir to remain"
			select multiblwc in $multiblrpsselect;
			do
				if [[ $multiblwc == "" ]]; then
					echo -e "\e[96m>>> \e[31mPlease select the number corresponding to $bootdir\e[0m"
				else
					echo -e "\nBootloader \e[91m$multiblwc\e[0m selected"
					mv "$multiblwc" "tempbl.rps"
					mv $multiblrpsselect $bootloaders 2> /dev/null
					mv "tempbl.rps" $multiblwc
					break
				fi
			done
				#appendchanges
			echo -e "\n\e[95m>>> Checking for FIRMWARE, BOOTLOADER and FLASH used <<<\e[0m"
			fw
			bl
		else
			if [ -f RS9113_WC_BL*.rps ]; then
				bootloader
			else
				nbl=$(echo "Bootloader not found")
				echo $nbl
				echo -e "\n\e[31m$wc->\e[0m"
				echo -e "\e[96m>>>\e[0m Manually copy a single bootloader to the \e[1m$wc\e[0m directory before proceeding\n"
				echo -e "\e[31mAborting conversion\e[0m"
				exit
			fi
		fi
	}

	#FLASHTYPE
	ft() {
		echo -e "\n\e[33mFLASH\e[0m"
		cd $flashdirectory
	
		selectedmicron="$(sed -n 30p Makefile)" || read $selectedmicron
		selectedmacronix="$(sed -n 32p Makefile)" || read $selectedmacronix

		if [[ $selectedmicron = "#DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
			echo "Macronix"
		else
			if [[ $selectedmicron = "DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "#DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
				echo "Micron"
			else
				if [[ $selectedmicron = "#DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "#DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
					echo "Invalid flash selection"
					echo "Please check Makefile"
					echo -e "\n\e[31mAborting conversion\e[0m"
					exit
				else
					if [[ $selectedmicron = "DEBUG_FLAG += -D MICRON_FLASH" && $selectedmacronix = "DEBUG_FLAG += -D MACRONIX_FLASH" ]]; then
						echo "Invalid flash selection"
						echo "Please select only 1 flash type"
						echo -e "\n\e[31mAborting conversion\e[0m"
						exit
					fi
				fi
			fi
		fi
	}

	lot
	fw
	bl
	ft
}

# # Checking for recent lot id
# chkrecentlotid() {
# 	echo -e "\e[95m>>> Checking Lot ID used <<<\e[0m"
# 	cd $lotdirectory

# 	#LOTID
# 	lot() {
# 		echo -e "\n\e[33mLOTID\e[0m"
# 		cd $lotdirectory
		
# 		lotid="$(sed -n 82p RSI_Config.txt)" || read $lotid
# 		substr="${lotid:6:10}"
# 		echo $substr		
# 	}

# 	# Lot ID change query
# 	lotidchangeqry() {
# 		echo -n -e "\nProceed to lot id change?     \e[1mY/N  :\e[0m""  "
# 		read lotchki

# 		if [[ $lotchki == "Y" || $lotchki == "y" || $lotchki == "YES" || $lotchki == "Yes" || $lotchki == "yes" ]]; then
# 			echo -n -e "\nConvert with lot id?          \e[1mY/N  :\e[0m""  "
# 			read lotn

# 			lotnumber() {
# 	    		echo -e -n "\nPlease enter the lot number        :\e[0m""  "
# 	 			read lot
			
# 	    		if [[ ! $lot =~ ^71[0-9]{5}\.[0-9]{1,2}$ ]]; then
# 			        echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
#     		   		lotnumber
# 				else
# 					echo
# 					chkrecentfwblft
#     			fi
# 			}

# 			lotdate() {
# 				echo -e -n "\nPlease enter the datecode          :\e[0m""  "
# 	    		read lot

# 		   		if [[ ! $lot =~ ^[0-9]{2}[0-9]{2}[0-9]{4}$ ]]; then
# 		       		echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
#         			lotdate
# 				else
# 					echo
# 					chkrecentfwblft
# 				fi
# 			}

# 			if [[ $lotn == "Y" || $lotn == "y" || $lotn == "YES" || $lotn == "Yes" || $lotn == "yes" ]]; then
# 			   	lotnumber
# 				cd $lotdirectory
# 				sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
# 			else
# 		    	if [[ $lotn == "N" || $lotn == "n" || $lotn == "NO" || $lotn == "No" || $lotn == "no" ]]; then
# 		   			lotdate
# 					cd $lotdirectory
#    					sed -i "82 s/$substr/"$lot"/" RSI_Config.txt
# 				else
# 			        echo -e "\e[32m>>> \e[31mInvalid lot number. Please enter again.\e[0m"
# 					lotidchangeqry
#    				fi	
# 			fi

# 		else
# 			if [[ $lotchki == "N" || $lotchki == "n" || $lotchki == "NO" || $lotchki == "No" || $lotchki == "no" ]]; then
# 				echo
# 				chkrecentfwblft
# 			else
# 				echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
# 				lotidchangeqry
# 			fi
# 		fi
# 	}

# 	lot
# 	lotidchangeqry
# }

# Checking firmware and bootloader directories for valid contents
checkingcontent(){
	lsfw=RS9113.NBZ.WC*OSI*.rps
	lsbl=RS9113_WC_BL*.rps

	firmdir() {
		cd $firmwares

		#Checking firmware refrence directory - exist
		if [ "$(ls -A $firmwares)" ]; then
			#Checking content - valid firmware
			for fw in $lsfw; do
				[ -e "$fw" ] && 
				#Checking content - valid firmware
				bootdir && return 0 || 
				#Checking content - no valid firmware
				echo -e "\e[31m$firmdir->\e[0m"
				echo -e "No valid firmware found"
				echo -e "Manually place a \e[32m$fwrps\e[0m to this directory before you proceed!"
				echo -n -e "\e[96m>>> \e[35m"
				pwd
				echo -e "\n\e[34m*************************************\e[0m"
				bootdir
				echo -e "\n\e[31mAborting conversion\e[0m"
				exit
			done
		else
			#Checking firmware reference directory - non exist
			if [ ! "$(ls -A $firmwares)" ]; then
				echo -e "\e[1m$firmdir\e[0m directory is empty.\n"
				echo -e "\e[31m$firmdir->\e[0m"
				echo -e "Manually place a \e[32m$fwrps\e[0m to this directory before you proceed!"
				echo -n -e "\e[96m>>> \e[35m"
				pwd
				echo -e "\n\e[34m*************************************\e[0m"
				bootdir
				echo -e "\n\e[31mAborting conversion\e[0m"
				exit
			fi
		fi
	}

	bootdir() {
		cd $bootloaders

		#Checking bootloader refrence directory - exist
		if [ "$(ls -A $bootloaders)" ]; then
			#Checking content - valid bootloader
			for bl in $lsbl; do
				[ -e "$bl" ] && 
				return 0 || 
				#Checking content - no valid bootloader
				echo -e "\e[31m$bootdir->\e[0m"
				echo -e "No valid bootloader found"
				echo -e "Manually place a \e[32m$blrps\e[0m to this directory before you proceed!"
				echo -n -e "\e[96m>>> \e[35m"
				pwd
				echo -e "\n\e[34m*************************************\e[0m"
				echo -e "\n\e[31mAborting conversion\e[0m"
				exit
			done
		else
			#Checking bootloader reference directory - non exist
			if [ ! "$(ls -A $bootloaders)" ]; then
				echo -e "\e[1m$bootdir\e[0m directory is empty.\n"
				echo -e "\e[31m$bootdir->\e[0m"
				echo -e "Manually place a \e[32m$blrps\e[0m to this directory before you proceed!"
				echo -n -e "\e[96m>>> \e[35m"
				pwd
				echo -e "\n\e[34m*************************************\e[0m"
				echo -e "\n\e[31mAborting conversion\e[0m"
				exit
			fi
		fi
	}

	firmdir
}

# Create bootloader directory if not found
refbldirchecking() {
	
	blreferencedir() {
		#Bootloader's refrence directory
		if [ ! -d $bootloaders ]; then
			echo -e "\e[96m>>>\e[0m Creating directory"
			echo -e "    Directory created\n"
			mkdir $bootloaders
			cd $bootloaders
			echo -e "\e[31m$bootdir->\e[0m"
			echo -e "Please move the existing $bootdirs to \e[1m$bootdir\e[0m directory before proceeding"
			echo -e "Error will encounter if no $bootdir exist"
			echo -n -e "\e[96m>>> \e[35m"
			pwd
			echo -e "\n\e[34m*************************************\e[0m"
		fi
	}

	echo -e "No reference directory for \e[1m$bootdir\e[0m"
	echo -n -e 'Create directory?  \e[1mY/N  :\e[0m'
	read bldirectory
	# read -p 'Create directory? ' bldirectory

	if [[ $bldirectory == "Y" || $bldirectory == "y" || $bldirectory == "Yes" || $bldirectory == "YES" || $bldirectory == "Yes" ]]; then
		echo
		blreferencedir
	else
		if [[ $bldirectory == "N" || $bldirectory == "n" || $bldirectory == "No" || $bldirectory == "No" || $bldirectory == "no" ]]; then
			echo -e "\n\e[96m>>>\e[0m Please check the reference directory"
		else
			if [[ $bldirectory != "" ]]; then
				echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
				refbldirchecking
			else
				if [[ $bldirectory == "" ]]; then
					echo -e "\e[32m>>> \e[31mPlease verify! Enter again.\n\e[0m"
					refbldirchecking
				fi
			fi
		fi
	fi
}

# Create firmware directory if not found
reffwdirchecking() {
	
	fwreferencedir() {
		#Firmware's reference directories
		if [ ! -d $firmwares ]; then
			echo -e "\e[96m>>>\e[0m Creating directory"
			echo -e "    Directory created\n"
			mkdir $firmwares
			cd $firmwares
			echo -e "\e[31m$firmdir->\e[0m"
			echo -e "Please move the existing $firmdir to \e[1m$firmdir\e[0m directory before proceeding"
			echo -e "Error will encounter if no $firmdir exist"
			echo -n -e "\e[96m>>> \e[35m"
			pwd
			echo -e "\n\e[34m*************************************\e[0m"
		fi
	}

	echo -e "No reference directory for \e[1m$firmdir\e[0m"
	echo -n -e 'Create directory?  \e[1mY/N  :\e[0m'
	read fwdirectory
	# read -p 'Create directory? ' fwdirectory

	case $fwdirectory in
		[Yy]|[Yy][Ee][Ss])
			echo
			fwreferencedir
			;;
		[Nn]|[Nn][Oo])
			echo -e "\n\e[96m>>>\e[0m Please check the reference directory"
			;;
		"")
			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\e[0m"
			reffwdirchecking
			;;
		*)
			echo -e "\e[32m>>> \e[31mPlease verify! Enter again.\e[0m"
			reffwdirchecking
			;;
	esac
	
	# if [[ $fwdirectory == "Y" || $fwdirectory == "y" || $fwdirectory == "Yes" || $fwdirectory == "YES" || $fwdirectory == "Yes" ]]; then
	# 	echo
	# 	fwreferencedir
	# else
	# 	if [[ $fwdirectory == "N" || $fwdirectory == "n" || $fwdirectory == "No" || $fwdirectory == "No" || $fwdirectory == "no" ]]; then
	# 		echo -e "\n\e[96m>>>\e[0m Please check the reference directory"
	# 	else
	# 		if [[ $fwdirectory != "" ]]; then
	# 			echo -e "\e[32m>>> \e[31mPlease type \e[1mY/N\e[0m \e[31mto proceed! Please enter again.\n\e[0m"
	# 			reffwdirchecking
	# 		else
	# 			if [[ $fwdirectory == "" ]]; then
	# 				echo -e "\e[32m>>> \e[31mPlease verify! Enter again.\n\e[0m"
	# 				reffwdirchecking
	# 			fi
	# 		fi
	# 	fi
	# fi
}

# Checking for firmware and bootload reference directory
refdirectorychecking() {
	
	#Firmware and Bootloader's root folder
	if [ ! -d $versions ]; then
		echo -e "No reference directory \e[1m$fwbl\e[0m"
		echo -e "\e[96m>>>\e[0m Creating directory"
		echo -e "    Directory created"
		mkdir $versions
		cd $versions
		echo -n -e "\n\e[96m>>> \e[35m"
		pwd
		echo -e "\n\e[34m*************************************\e[0m"
	fi

	#Firmware's reference directories
	if [ ! -d $firmwares ]; then
		echo -e "No reference directory \e[1m$firmdir\e[0m"
		echo -e "\e[96m>>>\e[0m Creating directory"
		echo -e "    Directory created\n"
		mkdir $firmwares
		cd $firmwares
		echo -e "\e[31m$firmdir->\e[0m"
		echo -e "Please move the existing $firmdirs to \e[1m$firmdir\e[0m directory before proceeding"
		echo -e "Error will encounter if no $firmdir exist"
		echo -n -e "\e[96m>>> \e[35m"
		pwd
		echo -e "\n\e[34m*************************************\e[0m"
	fi

	#Bootloader's refrence directory
	if [ ! -d $bootloaders ]; then
		echo -e "No reference directory \e[1m$bootdir\e[0m"
		echo -e "\e[96m>>>\e[0m Creating directory"
		echo -e "    Directory created\n"
		mkdir $bootloaders
		cd $bootloaders
		echo -e "\e[31m$bootdir->\e[0m"
		echo -e "Please move the existing $bootdirs to \e[1m$bootdir\e[0m directory before proceeding"
		echo -e "Error will encounter if no $bootdir exist"
		echo -n -e "\e[96m>>> \e[35m"
		pwd
		echo -e "\n\e[34m*************************************\e[0m"
	fi

	echo -e "\n\e[31mAborting conversion\e[0m"
	exit
}

#>> Script starts here <<#

if [ ! -d $versions ]; then
	refdirectorychecking
fi

if [[ ! -d $firmwares && ! -d $bootloaders ]]; then
	reffwdirchecking
	refbldirchecking
	echo -e "\n\e[31mAborting conversion\e[0m"
	exit
fi

if [ ! -d $firmwares ]; then
	reffwdirchecking
	echo -e "\n\e[31mAborting conversion\e[0m"
	exit
fi

if [ ! -d $bootloaders ]; then
	refbldirchecking
	echo -e "\n\e[31mAborting conversion\e[0m"
	exit
fi

if [ -d $versions ]; then
	checkingcontent
fi

# chkrecentlotid
chkrecentlnfwblft
# firmwarechangeqry
lotidchangeqry

# Developed by: Macky