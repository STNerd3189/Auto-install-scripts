#!/bin/bash

#Updating base system
sudo apt update
sudo apt upgrade -y

#Install Linux 7 Kernel
sudo apt install -y linux-image-amd64 linux-headers-amd64 linux-source

#Add necessary repositories
sudo add-apt-repository universe multiverse -y
sudo add-apt-repository ppa:ubuntugaming/ppa -y
sudo apt update

#Install packages
sudo apt install -y vim curl ruby fish p7zip-full exa gnome-tweaks steam lutris wine wine32 wine64 proton-gamemode mangohud goverlay ardour obs-studio discord fastfetch

#Install flatpaks
flatpak install -y chat.schildi.desktop com.atlauncher.ATLauncher com.microsoft.Edge com.microsoft.Teams org.gnome.Boxes org.onlyoffice.desktopeditors org.telegram.desktop
flatpak update -y

#Downloading por
curl -o por https://raw.githubusercontent.com/bigc0127/por/main/por
curl -o help.txt https://raw.githubusercontent.com/bigc0127/por/main/help.txt
curl -o config.txt https://raw.githubusercontent.com/bigc0127/por/main/config.txt

#Installing Por
mkdir -p ~/.utils
mv -v ./por ~/.utils/
mv -v ./help.txt ~/.utils/
mv -v ./config.txt ~/.utils/
chmod 755 ~/.utils/por
chmod 755 ~/.utils/help.txt
chmod 755 ~/.utils/config.txt
echo 'export PATH="$HOME/.utils:$PATH"' >> ~/.bashrc

#Setting up fish
mkdir -p ~/.config/fish/
mv -v ./config.fish ~/.config/fish/

#Change Shell
chsh -s /usr/bin/fish

#Wallpapers
mv -v ./P1/* ./Purple/
mv -v ./P2/* ./Purple/
mv -v ./P3/* ./Purple/
mv -v ./P4/* ./Purple/
mv -v ./P5/* ./Purple/
mkdir -p ./Wallpapers
mv -v ./Purple ./Wallpapers/
mv -v ./Other ./Wallpapers/
mv -v ./Tech ./Wallpapers/
mv -v ./76walls ./Wallpapers/
mv -v ./Wallpapers ~/Pictures/

#Themes and Icons
mv -v ./looks.7z ~/
mkdir -p ~/.config/gtk-4.0/
mv -v ./gtk-4.0/* ~/.config/gtk-4.0/
cd ~/
7z x ./looks.7z -y

#Setting up themes
cd ~/Auto-install-scripts/
7z x ./gnome-shell.7z -y
rm -rfv ~/.local/share/gnome-shell
mv -v ./gnome-shell ~/.local/share/
gnome-tweaks

#Apply Star Trek ENT LCARs schema to apps
#For OBS
mkdir -p ~/.config/obs-studio/themes
cd ~/.config/obs-studio/themes
wget https://obsproject.com/forum/resources/lcars-theme.163/download -O lcars.zip
unzip lcars.zip

#For Discord
# Install BetterDiscord
curl -o betterdiscord.tar.gz https://github.com/BetterDiscord/Installer/releases/latest/download/BetterDiscord-Linux.tar.gz
tar -xzf betterdiscord.tar.gz
cd BetterDiscord-Linux
./installer.sh
# Apply LCARs theme
mkdir -p ~/.config/BetterDiscord/themes
cd ~/.config/BetterDiscord/themes
wget https://raw.githubusercontent.com/StarTrekTheme/Discord/master/LCARS.theme.css -O LCARS.theme.css

#For Twitch, use a custom themed app or extension (placeholder)
# Perhaps install a themed Twitch client if available

#Remove bloatware
sudo apt remove -y libreoffice firefox

#The End
echo "all done, Welcome home"
echo "recommend reboot now for full effect"
