#!/bin/bash
#
# Install the script by moving the two script files 
# to the user home directory ~ (hiding them with a dot .)
# and then hooking them to the login and logout
#

#-- Find 'echo' program in PATH or use Mac Ports default location
ECHO="$( which echo )"
ECHO="${ECHO:-/opt/local/libexec/gnubin/echo}"

#-- Bash version check for 'echo'
[ -n "${BASH_VERSION}" ] \
  && ECHO="echo -e" \
  || ECHO="echo"

if [ "$(id -u)" != "0" ]; then
	${ECHO} "You need administrative privileges to install this script.\nPlease run: sudo ./install.sh"
	exit 1
fi

#-- Force OS X 'stat' in case of GNU version installed
ACTUAL_USER=$(sudo /usr/bin/stat -f '%Su' ~)

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
	rm ~/.nobootsound_loginhook
	rm ~/.nobootsound_logouthook
	rm ~/.nobootsound_logoutvol
	
else
	${ECHO} "Copying files..."
	# Create file .nobootsound_logoutvol where the mute state is stored
	sudo -u $ACTUAL_USER ${ECHO} "false" > ~/.nobootsound_logoutvol
	
	# Copy login and logout scripts and make them executable
	sudo -u $ACTUAL_USER cp nobootsound_loginhook ~/.nobootsound_loginhook
	sudo -u $ACTUAL_USER cp nobootsound_logouthook ~/.nobootsound_logouthook
	sudo -u $ACTUAL_USER chmod +x ~/.nobootsound_loginhook
	sudo -u $ACTUAL_USER chmod +x ~/.nobootsound_logouthook

	${ECHO} "Registering hooks..."
	# Register the scripts as login and logout hooks
	defaults write com.apple.loginwindow LoginHook  ~/.nobootsound_loginhook
	defaults write com.apple.loginwindow LogoutHook ~/.nobootsound_logouthook

	${ECHO} "Done!"
fi
