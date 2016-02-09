#!/bin/bash
#
# Install the script by moving the two script files 
# to the user home directory ~ (hiding them with a dot .)
# and then hooking them to the login and logout
#

installation_folder="/Library/LogHook/"
loginhook="nobootsound_loginhook"
logouthook="nobootsound_logouthook"
logoutvolume="nobootsound_logoutvol"

#-- Find 'echo' program in PATH or use Mac Ports default location
ECHO="$( which echo )"
ECHO="${ECHO:-/opt/local/libexec/gnubin/echo}"

#-- Directory containing this installer and the scripts to install.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#-- Bash version check for 'echo'
[ -n "${BASH_VERSION}" ] \
  && ECHO="echo -e" \
  || ECHO="echo"

if [ "$(id -u)" != "0" ]; then
	${ECHO} "You need administrative privileges to install this script.\nPlease run: sudo ./install.sh"
	exit 1
fi

uninstallmode=false

while getopts ":u" opt; do
  case $opt in
    u)
		uninstallmode=true
      ;;
    \?)
      ${ECHO} "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


if [ "$uninstallmode" = true ]; then
	${ECHO} "Removing hooks..."
	defaults delete com.apple.loginwindow LoginHook
	defaults delete com.apple.loginwindow LogoutHook
	
	${ECHO} "Removing files..."
	rm "$installation_folder$loginhook"
	rm "$installation_folder$logouthook"
	rm "$installation_folder$logoutvolume"

	${ECHO} "Done!"
	
else
	${ECHO} "Copying files..."

	# Create installation folder if it doesn't already exists.
	mkdir -p "$installation_folder"

	# Create file where the mute state is stored
	sudo ${ECHO} "false" > "$installation_folder$logoutvolume"
	
	# Copy login and logout scripts and make them executable
	sudo cp "${DIR}/$loginhook" "$installation_folder"
	sudo cp "${DIR}/$logouthook" "$installation_folder"
	sudo chmod +x "$installation_folder$loginhook"
	sudo chmod +x "$installation_folder$logouthook"

	${ECHO} "Registering hooks..."
	# Register the scripts as login and logout hooks
	defaults write com.apple.loginwindow LoginHook  "$installation_folder$loginhook"
	defaults write com.apple.loginwindow LogoutHook "$installation_folder$logouthook"

	${ECHO} "Done!"
fi
