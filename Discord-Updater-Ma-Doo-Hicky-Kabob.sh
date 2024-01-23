#!/usr/bin/env bash

# kill any running instances of discord
# just in case
killall Discord

create_desktop_shortcut()
{
# Function too create a desktop file for discord at
# (your user folder)/.local/share/applications/
# named discord-stable.desktop
# using the command "cat"
cat > "${XDG_DATA_HOME:-$HOME/.local/share}/applications/discord-stable.desktop" << EOL
[Desktop Entry]
Type=Application
Exec=/bin/sh -c "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/Discord"
Name=Discord
Icon=discord
Comment=Text and voice chat for gamers.
X-GNOME-Autostart-enabled=true
EOL
}


# first we move to the temp folder so that both of our downloaded files get deleted on system reboot
cd /tmp/


# download the current .tar.gz release of discord
# and name it discord.tar.gz
# located in /tmp/
wget "https://discord.com/api/download?platform=linux&format=tar.gz" -O discord.tar.gz


# then we download the vencord installer script to the temp folder
# with the name "vencord-installer"
wget "https://github.com/Vencord/Installer/releases/latest/download/VencordInstallerCli-linux" -O vencord-installer


# check if the (your user folder)/.local/share/Discord/
# folder if it exist
if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/" ]; then
	# if it does, remove it and exerything in it
	rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"
fi


# Recreate the (your user folder)/.local/share/Discord/ folder
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"
# Extract everything in discord.tar.gz
# into (your user folder)/.local/share/
# so that everything merges with the existing folder
tar -xvf discord.tar.gz -C ${XDG_DATA_HOME:-$HOME/.local/share}
# check if the proper icon for discord exists in the user's proper icon folder
# which is (your user folder)/.local/share/icons/hicolor/256x256/apps/


if [ -e "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/discord.png" ]; then
	# if it does, remove it
	rm "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/discord.png"
	# then copy the current one from the stuff we just extracted
 	# in its place, incase discord changes its icon one day
	cp "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/discord.png" "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/"
# a catch for if the icon doesn't already exist in the users proper icon folder
else
	# in which case, nothing needs	to be removed
	# just go ahead and copy the current one into the proper folder 
	cp "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/discord.png" "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/"
# this is the end of the check for if the icon already exists or not
fi


# now we check if the desktop shortcut used to run discord already exists
# located in (your user folder)/.local/share/applications/
if [ -e "${XDG_DATA_HOME:-$HOME/.local/share}/applications/discord-stable.desktop" ]; then
	# if it does, we remove it
	rm "${XDG_DATA_HOME:-$HOME/.local/share}/applications/discord-stable.desktop"
 	# then we call the function from the top of the script to create the desktop shortcut
	create_desktop_shortcut
# here we have another catch in case the desktop shortcut doesn't already exist
else
	# in which case, again, nothing needs removed
	# we just call the function to go ahead and create it
	create_desktop_shortcut
# this is the end of the check for if the desktop shortcut already exists or not
fi


# now we change a flag on the "vencord-installer" to allow us to run it
chmod +x vencord-installer
# then we run "vencord-installer"
# with an argument of "-location ${XDG_DATA_HOME:-$HOME/.local/share}/Discord/" 
# this makes it look for the discord install located in
# the (your user folder)/.local/share/Discord/ folder
# along with another argument of "-install-openasar
# and installs open asar
# it is a framework that can be used to improve the performance of discord
# a notoriously spaghetti code electron application
./vencord-installer -location "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"  -install-openasar
# next we run the vencord-installer again
# but with the argument of "-install-openasar" replaced with
# an argument of -install
# which is the main event we're here for
# the one that lets you use custom themes and plugins
./vencord-installer -location "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"  -install
