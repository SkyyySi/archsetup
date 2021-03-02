#!/usr/bin/env bash
# Error out if not root
if [[ ${EUID} != 0 ]]; then
	echo 'This script must run as root!'
	if command -v sudo; then
		echo -n 'Run with sudo? [Y/n]'
		read run_as_root
		case $run_as_root in
			'y'|'Y') sudo ${0} ${@}
			*)       exit 1
		esac
	else
		exit 1
	fi
fi

# Install dependencies
echo 'Installing dependencies...'
yes 'y' | pacman -S --needed dialog
echo 'Done!'
