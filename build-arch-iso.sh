#!/bin/bash
# TrekForgeOS Arch Live ISO Builder
# Creates a bootable archiso image with TrekForgeOS customizations

set -e

DISTRO_NAME="TrekForgeOS"
DISTRO_VERSION="1.0"
BUILD_DIR="./archiso-build"
OUTPUT_DIR="../iso-output"
PROFILE_DIR="./profile"

echo "=========================================="
echo "Building $DISTRO_NAME Live ISO (Arch-based)"
echo "=========================================="

# Create output directory
mkdir -p $OUTPUT_DIR

# Install build dependencies
echo "[1/4] Installing build dependencies..."
sudo pacman -Syu --noconfirm
sudo pacman -S archiso --noconfirm

# Create archiso profile
echo "[2/4] Creating archiso profile..."
mkdir -p $PROFILE_DIR/{airootfs/root,airootfs/etc/skel/.config,airootfs/boot/grub,}

# Copy archiso baseline
# Using the releng profile as base
if [ ! -d "$PROFILE_DIR/airootfs" ]; then
  sudo cp -r /usr/share/archiso/configs/releng/* $PROFILE_DIR/
fi

# Create packages.x86_64 file
echo "[3/4] Configuring packages..."
cat > $PROFILE_DIR/packages.x86_64 << 'EOF'
# Base system
base
linux
linux-firmware
linux-headers
base-devel

# Bootloader
grub
efibootmgr

# Network
networkmanager
net-tools
openssh

# Shell and terminal
fish
bash

# Tools
vim
curl
git
wget
p7zip
exa
fastfetch
man-pages

# Desktop environment (GNOME + Wayland)
gnome-shell
gnome-tweaks
gnome-desktop
gnome-terminal
nautilus

# Gaming and multimedia
steam
lutris
wine
wine-mono
wine-gecko
proton
proton-gamemode
mangohud
goverlay
lib32-vulkan-intel
lib32-vulkan-amd
lib32-opengl-driver
vulkan-intel
vulkan-amd

# Audio and video production
ardour
obs-studio
alsa-utils
pulseaudio

# Communication
discord

# Additional tools
flatpak
xclip
xsel

# Display server (Wayland)
wayland
libxcb
EOF

# Create pacman.conf customization
cat > $PROFILE_DIR/pacman.conf << 'EOF'
[options]
HoldPkg     = pacman glibc
Architecture = auto

CheckSpace
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
ParallelDownloads = 5

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF

# Create installation hooks
mkdir -p $PROFILE_DIR/airootfs/root

cat > $PROFILE_DIR/airootfs/root/customize_airootfs.sh << 'EOF'
#!/bin/bash
set -e

# Set up localization
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen

# Set up time zone
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

# Network configuration
systemctl enable NetworkManager

# Set root password (can be changed on first boot)
echo "root:trekforge" | chpasswd

# Create regular user
useradd -m -s /usr/bin/fish trekforge
echo "trekforge:trekforge" | chpasswd

# Set up fish shell for regular user
mkdir -p /home/trekforge/.config/fish
echo "# TrekForgeOS Fish Configuration" > /home/trekforge/.config/fish/config.fish
chown -R trekeforge:trekforge /home/trekforge/.config

# Install Chaotic-AUR for extra packages
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || true
pacman-key --lsign-key 3056513887B78AEB || true

# Theme directories
mkdir -p /home/libreforge/.config/gtk-4.0
mkdir -p /home/libreforge/.config/obs-studio/themes
mkdir -p /home/libreforge/.config/BetterDiscord/themes

# Enable Flatpak
systemctl enable flatpak || true

echo "LibreForgeOS Arch customization complete!"
EOF

chmod +x $PROFILE_DIR/airootfs/root/customize_airootfs.sh

# Build the ISO
echo "[4/4] Building archiso image (this may take 20-30 minutes)..."
sudo mkarchiso -v -w /tmp/archiso-work -o $OUTPUT_DIR $PROFILE_DIR

# Rename ISO
if [ -f "$OUTPUT_DIR/archlinux-"*.iso ]; then
  ISO_FILE=$(ls -1 $OUTPUT_DIR/archlinux-*.iso | head -1)
  sudo mv $ISO_FILE $OUTPUT_DIR/VForgeOS-Arch-${DISTRO_VERSION}-amd64-live.iso
  sudo chown $(whoami):$(whoami) $OUTPUT_DIR/TrekForgeOS-Arch-${DISTRO_VERSION}-amd64-live.iso
  echo ""
  echo "=========================================="
  echo "✓ ISO Build Complete!"
  echo "ISO Location: $(pwd)/${OUTPUT_DIR}/TrekForgeOS-Arch-${DISTRO_VERSION}-amd64-live.iso"
  echo "Size: $(du -h $OUTPUT_DIR/TrekForgeOS-Arch-${DISTRO_VERSION}-amd64-live.iso | cut -f1)"
  echo "=========================================="
else
  echo "✗ ISO build failed. Check logs for details."
  exit 1
fi
