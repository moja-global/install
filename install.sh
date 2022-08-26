#!/usr/bin/env bash

# =============================================================================
#                    Install script for FLINT
# =============================================================================

export FLINT_HOME_DIR=$HOME/.local/bin/

FLINT_GITHUB_URL="https://api.github.com/repos/moja-global/install/releases/latest"

OPT_INSTALL=0
OPT_INSTALL_DEV=0
OPT_UNINSTALL=0
OPT_UPDATE=0
OPT_HELP=0

function usage() {
	help_text="Install script for FLINT AppImages
Usage: ./install.sh [parameters]

General options:
%2s--install <release>: Install FLINT on the system - release can either be 'dev' or 'stable' (default: stable)
%2s--uninstall: Install FLINT on the system
%2s--update: Install FLINT on the system
%2s--help: Install FLINT on the system
	"

	printf "$help_text"
}


# Parse the arguments
if [ $# -ne 0 ]; then
	while [ $# -ne 0 ]
	do 
		if [[ "$1" = '--install' || "$1" = '-i' ]]; then
			OPT_INSTALL=1
			shift
			if [[ "$1" = 'dev' ]]; then
				OPT_INSTALL_DEV=1
			fi
		fi

		if [[ "$1" = '--uninstall' ]]; then
			OPT_UNINSTALL=1
		fi
		if [[ "$1" = '--update' || "$1" = '-u' ]]; then
			OPT_UPDATE=1
		fi
		if [[ "$1" = '--help' || "$1" = '-h' ]]; then
			OPT_HELP=1
		fi

		shift
	done
else 
	usage
fi


# Fetch the latest FLINT AppImage release
fetch_release() {
	HOME_DIR=$HOME/Downloads
	mkdir -p $HOME_DIR

	UBUNTU_VERSION=$(cat /etc/os-release | grep ^VERSION_ID | cut -d '=' -f2 | tr -d '"')
	FLINT_LATEST_VERSION=""

	if [ $OPT_INSTALL_DEV -eq 1 ]; then
		# TODO: Change this when we get dynamic tags.
		FLINT_LATEST_VERSION="https://github.com/moja-global/install/releases/download/dev/FLINT-ubuntu-$UBUNTU_VERSION.AppImage"
	else
		FLINT_LATEST_VERSION=$(curl -sS $FLINT_GITHUB_URL | jq -r '.assets[].browser_download_url' | grep $UBUNTU_VERSION)
	fi

	echo "Fetching latest version of FLINT"

	# Get latest release URL
	
	curl -L $FLINT_LATEST_VERSION --output $HOME_DIR/FLINT.AppImage

	# Check if AppImage is empty or does not exist. 
	if [ -s $HOME_DIR/FLINT.AppImage ]; then
		echo -e "\n\nAppImage fetched successfully!"
	else
		echo "Failed to fetch AppImage"
	fi
}

update_appimage() {
	APPIMAGE_LOCATION=/home/$USER/.local/bin/FLINT.AppImage
	UBUNTU_VERSION=$(cat /etc/os-release | grep ^VERSION_ID | cut -d '=' -f2 | tr -d '"')

	# Get latest release URL
	FLINT_LATEST_VERSION=$(curl -sS $FLINT_GITHUB_URL | jq -r '.assets[].browser_download_url' | grep $UBUNTU_VERSION)

	test -f $APPIMAGE_LOCATION 
	if [ $? -eq 1 ];then
		echo "No FLINT Installation found"
		exit
	fi

	LOCAL_APPIMAGE_HASH=$(sha256sum $APPIMAGE_LOCATION | cut -d " " -f1)

	# TODO: Find a better way to get the checksum of a release asset. Preferably without downloading it.
	REMOTE_APPIMAGE_HASH=$(curl -L $FLINT_LATEST_VERSION --output /tmp/FLINT.AppImage && sha256sum /tmp/FLINT.AppImage | cut -d " " -f1)

	if [ "$LOCAL_APPIMAGE_HASH" = "$REMOTE_APPIMAGE_HASH" ]; then
		echo "AppImage is up to date"
		exit
	else
		echo "AppImage is out of date! Updating..." 
		mv /tmp/FLINT.AppImage $APPIMAGE_LOCATION
		chmod +x $APPIMAGE_LOCATION
		echo "Done updating!"
	fi
}

main() {
	which jq 1>/dev/null
	if [ $? -eq 1 ]; then
		echo "jq not found. Installing jq..."
		sudo apt update
		sudo apt install -y jq
	fi

	if [ $OPT_INSTALL -eq 1 ]; then
		test -f $APPIMAGE_DIR/FLINT.AppImage
		if [ $? -eq 0 ]; then
			echo "FLINT installation is already present on the system"
			exit
		fi

		fetch_release

		APPIMAGE_DIR=/home/$USER/.local/bin
		mkdir -p $APPIMAGE_DIR
		mv /home/$USER/Downloads/FLINT.AppImage $APPIMAGE_DIR
		chmod +x $APPIMAGE_DIR/FLINT.AppImage
		$APPIMAGE_DIR/FLINT.AppImage 1>/dev/null

		if [ $? -eq 0 ]; then
			echo -e "\n\nInstalled FLINT AppImage at $APPIMAGE_DIR. Please make sure the folder is included in your PATH variable."
		else
			echo -e "\n\nFLINT installation failed!"
			exit
		fi
	fi

	if [ $OPT_UNINSTALL -eq 1 ]; then
		test -f $FLINT_HOME_DIR/FLINT.AppImage
		if [ $? == 0 ]; then
			rm $FLINT_HOME_DIR/FLINT.AppImage
			echo "Uninstalled FLINT AppImage successfully!"
		else
			echo "FLINT installation not found!"
		fi
	fi

	if [ $OPT_UPDATE -eq 1 ]; then
		update_appimage
	fi

	if [ $OPT_HELP -eq 1 ]; then
		usage
	fi
}

main
