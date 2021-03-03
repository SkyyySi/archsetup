#!/usr/bin/bash
####################################################################################################
#                                          System options                                          #
####################################################################################################
# Enable the chroot functions in the 'Exec' section.
SYSTEM_CHROOT_ENABLE=true

# Set the chroot tool to use. 'arch-chroot', 'chroot' and 'systemd-nspawn' are supported.
# Please note that pacman (and probably other commands, too) won't work with normal chroot!
SYSTEM_CHROOT_COMMAND='systemd-nspawn'

# Toggle between 'eif' (UEFI) and 'legacy' (BIOS) mode. This option primarily exists to prevent
# the setup script from trying to install a legacy config onto a efi system or vice-versa.
SYSTEM_BOOT_TYPE='efi'

# Setting the bootloader here will toggle some default settings on. If the bootloader is unknown
# or you set the bootloader to 'none', no actions will be done and you'll have to add your own
# configuration in the 'Exec' section.
SYSTEM_BOOT_LOADER='systemd-boot'

# Setting this option to true will enable options for a graphical user environment.
SYSTEM_GRAPHICAL=true

# Set a directory with a system skeleton to copy to the target system. If the directory doesn't
# exist, nothing will be copied.
SYSTEM_PREINSTALL_SYSSKEL='/usr/local/share/archsetup/sysskel_pre'
SYSTEM_POSTINSTALL_SYSSKEL='/usr/local/share/archsetup/sysskel_post'

# Chroot into the newly installed system for further configuration.
SYSTEM_POSTINSTALL_CHROOT=false

# At the very end, reboot the system automatically.
SYSTEM_POSTINSTALL_REBOOT=false

####################################################################################################
#                                           Localization                                           #
####################################################################################################
# Set your localization options. The examples here are for German, because... I'm German.
# System language. You can find them in /etc/locale.gen (on an Arch Linux host or the live ISO).
LOCALE_SYSLANG='de_DE'

# This is for packages like Firefox, where the langaues are provided as seperate packages.
LOCALE_APPLANG='de'

# Keyboard layout (TTY).
LOCALE_KEYMAP_TTY='de-latin1'

# Keyboard layout (Xorg).
LOCALE_KEYMAP_XORG='de'

####################################################################################################
#                                         Drive partitions                                         #
####################################################################################################
# MAIN is the root partition ('/') while anything else is a directory
# on said partition (eg. PARTITION_boot means '/boot').
# Setting the size of a partition to 'MAX' will cause it to take up all available space (except
# for the space for other partitions).
# You can also specify a seperate esp partition (efi partition) here if you want,
# in which case you'll have to set its filesystem and mount point as well.
# However, using a seperate esp is not recommmended for Arch Linux.
# Setting the esp device to be the same string as the boot device will resoult in
# the boot partition being used as the efi partition as well.
# Also note: the partitions will be partitioned in alphabetical oder, so /dev/sda1 will
# come first, then /dev/sda2, then /dev/sdb1 and so on.
PARTITION_MAIN_DEVICE='sda2'
PARTITION_boot_DEVICE='sda1'
#PARTITION_esp_DEVICE="${PARTITION_boot_device}"
#PARTITION_home_DEVICE='/dev/sda1'

# Here are the partition tables defined.
# Unless you want to use legacy boot, just ignore these.
PARTITION_sda_TABLE='gpt'
#PARTITION_sdb_TABLE='gpt'

PARTITION_MAIN_FILESYSTEM='ext4'
PARTITION_boot_FILESYSTEM='vfat'
#PARTITION_esp_FILESYSTEM="${PARTITION_boot_filesystem}"
#PARTITION_home_FILESYSTEM='btrfs'

PARTITION_MAIN_MOUNTPOINT='/'
PARTITION_boot_MOUNTPOINT='/boot'
#PARTITION_esp_MOUNTPOINT='/efi'
#PARTITION_home_MOUNTPOINT='/home'

# The syntax is the one used by sfdisk, except for the 'MAX' exception mentioned above.
PARTITION_MAIN_SIZE='MAX'
PARTITION_boot_SIZE='+400M'
#PARTITION_esp_SIZE='/efi'
#PARTITION_home_SIZE='/home'

####################################################################################################
#                                             Packages                                             #
####################################################################################################
# PACKAGES_BASE will always be installed.
# PACKAGES_GRAPHICAL will only be installed if SYSTEM.GRAPHICAL is enabled.
# PACKAGES_PHYSICAL and PACKAGES.VIRTUAL are special cases which only trigger
# if a VM is (not) used.
PACKAGES_BASE=(base base-devel bluez linux-lts linux-lts-headers efibootmgr nano vim dhcpcd pkgfile
               xdg-user-dirs)
PACKAGES_GRAPHICAL=(xf86-video-amdgpu xf86-video-fbdev)

PACKAGES_PHYSICAL=(linux-firmware)
PACKAGES_VIRTUAL=()

PACKAGES_VMWARE=(gtk2 gtkmm3 open-vm-tools xf86-input-vmmouse xf86-video-vmware)
PACKAGES_VIRTUALBOX=(virtualbox-guest-dkms virtualbox-guest-utils)

# PACKAGES_GROUP_* is an exeption to the rules above. These variables can only be toggled on or off,
# as they are pre-made groups containing multiple packages and configuration.
PACKAGES_GROUP_AWESOME=true      # The "awesome" window manager
PACKAGES_GROUP_GNOME=false       # The GNOME desktop environment
PACKAGES_GROUP_KDE=false         # The KDE plasma desktop environment
PACKAGES_GROUP_VIRTUALBOX=false  # Drivers for Virtualbox
PACKAGES_GROUP_VMWARE=false      # Drivers for VMware
PACKAGES_GROUP_ZSH=true          # The Z shell

####################################################################################################
#                                             Systemd                                              #
####################################################################################################
# SYSTEMD_ENABLE and SYSTEMD.DISABLE will enable and disable unit files, respectively.
SYSTEMD_ENABLE=(dhcpcd.service pkgfile.timer)
SYSTEMD_DISABLE=()

####################################################################################################
#                                               Exec                                               #
####################################################################################################
# Once the installision is done, you can run commands, both from the host and from within
# the target using 
EXEC_HOST_PREINSTALL() {
	
}

EXEC_HOST_POSTINSTALL() {
	
}

# Since you cannot run a command inside a system where there is no system, there's only a
# post-install function.
EXEC_TARGET() {
	pkgfile -u
}
