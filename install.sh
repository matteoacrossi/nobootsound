#!/bin/bash
#
# Install the script by moving the two script files 
# to the /Library/LogHook/ directory and then 
# hooking them to the login and logout.
#

installation_folder="/Library/LogHook/"
loginhook="nobootsound_loginhook"
logouthook="nobootsound_logouthook"
logoutvolume="nobootsound_logoutvol"

#-- Directory containing this installer and the scripts to install.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$(id -u)" != "0" ]; then
	printf "You need administrative privileges to install this script.\nPlease run: sudo ./install.sh\n"
	exit 1
fi

uninstallmode=false

while getopts ":u" opt; do
  case $opt in
    u)
		uninstallmode=true
      ;;
    \?)
      printf "Invalid option: -$OPTARG\n" >&2
      ;;
  esac
done


if [ "$uninstallmode" = true ]; then
	printf "Removing hooks...\n"
	defaults delete com.apple.loginwindow LoginHook
	defaults delete com.apple.loginwindow LogoutHook
	
	printf "Removing files...\n"
	rm "$installation_folder$loginhook"
	rm "$installation_folder$logouthook"
	rm "$installation_folder$logoutvolume"

	printf "Done!\n"
	
else
	printf "Copying files...\n"

	# Create installation folder if it doesn't already exists.
	mkdir -p "$installation_folder"

	# Create file where the mute state is stored
	sudo printf "false" > "$installation_folder$logoutvolume"
	
	# Copy login and logout scripts and make them executable
	sudo cp "${DIR}/$loginhook" "$installation_folder"
	sudo cp "${DIR}/$logouthook" "$installation_folder"
	sudo chmod +x "$installation_folder$loginhook"
	sudo chmod +x "$installation_folder$logouthook"

	printf "Registering hooks...\n"
	# Register the scripts as login and logout hooks
	defaults write com.apple.loginwindow LoginHook  "$installation_folder$loginhook"
	defaults write com.apple.loginwindow LogoutHook "$installation_folder$logouthook"

	printf "Done!\n"
fi
