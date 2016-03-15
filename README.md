# nobootsound
Simple and effective solution to mute the boot sound of Mac computers.

The only effective way of disabling the boot sound, without resorting to hacks, is to mute the Mac before shutting it off. This script works by muting the Mac right before shutdown and by restoring the volume state after the login.

With **nobootsound**, you won't need to remember to mute your Mac, and you will get rid of the boot sound, which can be very annoying, especially if you have to boot in places where silence is golden, such as libraries, classrooms, conference halls...

## Installation instructions
To install the script, run the script `install.sh` with administrative privileges:

    sudo sh install.sh
	
This script will just copy two files in the `/Library/LogHook` folder and register them as hooks for login and logout, so that they will be called each time the Mac is shut down and powered up.

## Removal instructions
To uninstall the script, run the script `install.sh` with the `-u` flag with administrative privileges:

    sudo sh install.sh -u
