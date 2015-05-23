#!/bin/bash
#
# Install the script by moving the two script files 
# to the user home directory ~ (hiding them with a dot .)
# and then hooking them to the login and logout
#

if [ "$(id -u)" != "0" ]; then
	echo "You need administrative privileges to install this script.\nPlease run\nsudo sh install.sh"
	exit 1
fi

ACTUAL_USER=$(sudo stat -f '%Su' ~)

uninstallmode=false

while getopts ":u" opt; do
  case $opt in
    u)
		uninstallmode=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


if [ "$uninstallmode" = true ]; then
	echo "Removing hooks..."
	defaults delete com.apple.loginwindow LoginHook
	defaults delete com.apple.loginwindow LogoutHook
	
	echo "Removing files..."
	rm ~/.nobootsound_loginhook
	rm ~/.nobootsound_logouthook
	rm ~/.nobootsound_logoutvol
	
else
	echo "Copying files..."
	sudo -u $ACTUAL_USER cp nobootsound_loginhook ~/.nobootsound_loginhook
	sudo -u $ACTUAL_USER cp nobootsound_logouthook ~/.nobootsound_logouthook
	sudo -u $ACTUAL_USER chmod +x ~/.nobootsound_loginhook
	sudo -u $ACTUAL_USER chmod +x ~/.nobootsound_logouthook
	sudo -u $ACTUAL_USER echo "false" > ~/.nobootsound_logoutvol

	echo "Registering hooks..."
	defaults write com.apple.loginwindow LoginHook  ~/.nobootsound_loginhook
	defaults write com.apple.loginwindow LogoutHook ~/.nobootsound_logouthook

	echo "Done!"
fi