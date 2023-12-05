#!/usr/bin/env bash

create_desktop_shortcut()
{
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

rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"
cd "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/"
wget "https://discord.com/api/download?platform=linux&format=tar.gz" -O discord.tar.gz
tar -xvf discord.tar.gz -C ${XDG_DATA_HOME:-$HOME/.local/share}
if [ -e "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/discord.png" ]; then
	rm "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/discord.png"
	cp "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/discord.png" "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/"
else
	cp "${XDG_DATA_HOME:-$HOME/.local/share}/Discord/discord.png" "${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/256x256/apps/"
fi
if [ -e "${XDG_DATA_HOME:-$HOME/.local/share}/applications/discord-stable.desktop" ]; then
	rm "${XDG_DATA_HOME:-$HOME/.local/share}/applications/discord-stable.desktop"
	create_desktop_shortcut
else
	create_desktop_shortcut
fi
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
