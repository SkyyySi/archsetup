#/usr/bin/env -i TERM=xterm-256color PATH=/usr/bin:/usr/local/bin bash --norc
####################################################################################################
#                                            Preperation                                           #
####################################################################################################
# Error out if not root and offer to re-run with sudo if possible.
if [[ ${EUID} != 0 ]]; then
	echo 'This script must run as root!'
	if command -v sudo; then
		echo -n 'Run with sudo? [Y/n]'
		read run_as_root
		case ${run_as_root} in
			'y'|'Y') sudo ${0} ${@};;
			*)       exit 1;;
		esac
	else
		exit 1
	fi
fi

# Function to print help text.
usage() {
echo "Usage: ${0} [OPTION]... [FILE]..."
echo "Helps you install Arch Linux by automating several steps."
echo
echo "A configuration file MUST be passed, and it MUST be passed last"'!'
echo
echo " -c   Enable (c)olored output"
echo " -h   Display this (h)elp and exit"
echo " -p   Change the (p)ath to the library directory. Default: /usr/share/archsetup"
echo
echo "Example:"
echo "  ${0} -c config_efi.sh  Run ${0} with colored output and use config_efi.sh in the current"
echo "                         directory as the configuration file."
}

# If no option is provided, print help and exit.
if [[ ${#} == 0 ]]; then
	usage
	exit 1
fi

# Default directory to look for library files.
LIB_DIR_PATH='/usr/share/archsetup'

while getopts ":ch:p:" arg; do
	case ${arg} in
		c) # Enable colored output
			COLOR_ERROR="\033[01;31m"
			COLOR_WARN="\033[33m"
			COLOR_SEPERATOR="\033[34m"
			COLOR_NORMAL="\033[00;00m"
		;;
		h) # Help message
			usage
		;;
		p) # Config dir path
			if [[ -d ${OPTARG} ]]; then
				LIB_DIR_PATH=${OPTARG}
			else
				echo "${COLOR_ERROR}Error${COLOR_NORMAL}: The directory '${OPTARG}' does not appear to exits"'!'
				exit 1
			fi
	esac
done

# Define the function for printing a seperator.
# If no color is used, the step for printing it is skipped altogether.
if [[ -n ${COLOR_SEPERATOR} ]]; then
	SEPERATOR() { echo -en ${COLOR_SEPERATOR}; printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '-'; }
else
	SEPERATOR() { printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -; }
fi

# Before continuing, warn the user and give a bit of time to prevent accidental deletion of files.
echo -e "${COLOR_ERROR}BIG, FAT WARNING${COLOR_NORMAL}: If your config file is invalid or you run this script on a machine that you don't want to wipe,"
echo "then cancel the execution of this script with Ctrl+C IMEDIATLY"'!!!'
echo "YOU ARE USING THIS SCRIPT AT YOUR OWN RISK! "
echo -e "THIS IS THE ONLY WARNING! I REPEAT: ${COLOR_WARN}THIS IS THE ONLY WARNING"'!!!'" ${COLOR_NORMAL}"
for e in {25..0}; do
	echo -en \\r"${e} seconds left... "
	sleep 1
done
if [[ ${?} != 0 ]]; then
	echo -e "\nOperation canceled! "
	exit 1
else
	echo -e "\nInstalling now! "
fi

####################################################################################################
#                                              Loading                                             #
####################################################################################################
# Source the config file.
if [[ -r "${@: -1}" ]]; then
	source "${@: -1}"
else
	echo "${COLOR_ERROR}Error${COLOR_NORMAL}: The file '${@: -1}' cannot be read or does not exist"'!'
	exit 1
fi

####################################################################################################
#                                         Drive partitions                                         #
####################################################################################################
SEPERATOR
echo "Creating partition table(s)... "
SEPERATOR
local TABLES=$(set -o posix; set | grep 'PARTITION_.*_TABLE' | sed 's/_[^_]*//2g' | uniq) l=''
for l in ${TABLES}; do
	local TABLE_TEMP=
done
unset p TABLES

local PARTITIONS=$(set -o posix; set | grep 'PARTITION_.*_DEVICE' | sed 's/_[^_]*//2g' | uniq) p=''
for p in ${PATITIONS}; do
	local PART_TEMP_DEV=$"${p}_DEVICE"
	local PART_TEMP_FS=$"${p}_FILESYSTEM"
	if [[ -e ${!PART_TEMP_DEV} ]] && command -v mkfs.${!PART_TEMP_FS}; then
		echo "Partitioning ${!PART_TEMP_DEV} as ${!PART_TEMP_FS}"
	fi
done
unset p PARTITIONS

# Create the mounting location
INSTALL_TARGET=

case ${SYSTEM_CHROOT_COMMAND} in
	'arch-chroot')    cchroot() { arch-chroot ${INSTALL_TARGET} ${@}; };;
	'chroot')         cchroot() { chroot ${INSTALL_TARGET} ${@}; };;
	'systemd-nspawn') cchroot() { systemd-nspawn -D ${INSTALL_TARGET} ${@}; };;
	*)                cchroot() { arch-chroot ${INSTALL_TARGET} ${@}; };;
esac

if [[ ${SYSTEM_CHROOT_ENABLE} == true ]]; then
	cchroot EXEC_TARGET
fi
