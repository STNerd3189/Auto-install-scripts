#!/bin/bash

#Updating base system
sudo pacman -Syu --noconfirm

#Install Linux 7 Kernel
sudo pacman -S --noconfirm linux linux-headers linux-lts

#Optional: Install alternative kernel flavors for Linux 7
# Uncomment desired flavor:
# sudo pacman -S --noconfirm linux-zen linux-zen-headers
# sudo pacman -S --noconfirm linux-hardened linux-hardened-headers

#Add Chaotic-AUR for Garuda packages
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf
sudo pacman -Sy --noconfirm

#Install packages
sudo pacman -S vim curl ruby fish p7zip exa gnome gnome-tweaks steam lutris wine proton-gamemode mangohud goverlay ardour obs-studio discord --noconfirm

#Install Garuda Dragonized specific
sudo pacman -S garuda-dr460nized garuda-gnome-settings garuda-assistant --noconfirm

#Install flatpaks
flatpak install chat.schildi.desktop com.atlauncher.ATLauncher com.microsoft.Edge com.microsoft.Teams org.gnome.Boxes org.onlyoffice.desktopeditors org.telegram.desktop -y
flatpak update -y

#Downloading por
curl -o por https://raw.githubusercontent.com/bigc0127/por/main/por
curl -o help.txt https://raw.githubusercontent.com/bigc0127/por/main/help.txt
curl -o config.txt https://raw.githubusercontent.com/bigc0127/por/main/config.txt

#Installing Por
mkdir ~/.utils
mv -v ./por ~/.utils/
mv -v ./help.txt ~/.utils/
mv -v ./config.txt ~/.utils/
chmod 755 ~/.utils/por
chmod 755 ~/.utils/help.txt
chmod 755 ~/.utils/config.txt
echo 'export PATH="$HOME/.utils:$PATH"' >> ~/.bashrc

#Setting up fish
sudo pacman -S fastfetch --noconfirm
mkdir ~/.config/fish/
mv -v ./config.fish ~/.config/fish/

#Change Shell
chsh -s /usr/bin/fish

#Wallpapers
mv -v ./P1/* ./Purple/
mv -v ./P2/* ./Purple/
mv -v ./P3/* ./Purple/
mv -v ./P4/* ./Purple/
mv -v ./P5/* ./Purple/
mkdir ./Wallpapers
mv -v ./Purple ./Wallpapers/
mv -v ./Other ./Wallpapers/
mv -v ./Tech ./Wallpapers/
mv -v ./76walls ./Wallpapers/
mv -v ./Wallpapers ~/Pictures/

#Themes and Icons
mv -v ./looks.7z ~/
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

#Remove bullshit
sudo pacman -R libreoffice firefox --noconfirm

#The End
echo "all done, Welcome home"
echo "recommend reboot now for full effect"
