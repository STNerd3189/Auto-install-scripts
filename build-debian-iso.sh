#!/bin/bash
# LibreForgeOS Debian/Ubuntu Live ISO Builder
# Creates a bootable ISO from Debian with LibreForgeOS customizations

set -e

DISTRO_NAME="LibreForgeOS"
DISTRO_VERSION="1.0"
BUILD_DIR="./debian-live-build"
OUTPUT_DIR="./iso-output"

echo "=========================================="
echo "Building $DISTRO_NAME Live ISO (Debian-based)"
echo "=========================================="

# Create necessary directories
mkdir -p $BUILD_DIR
mkdir -p $OUTPUT_DIR

# Install build dependencies
echo "[1/5] Installing build dependencies..."
sudo apt install -y live-build debootstrap syslinux isolinux xorriso squashfs-tools

# Create live-build configuration
echo "[2/5] Setting up live-build environment..."
cd $BUILD_DIR
sudo rm -rf build.log* || true
sudo lb clean --purge

# Initialize live-build
sudo lb config \
  --architecture amd64 \
  --distribution bookworm \
  --image-type iso-hybrid \
  --mirror-bootstrap http://deb.debian.org/debian/ \
  --mirror-chroot http://deb.debian.org/debian/ \
  --mirror-chroot-security http://security.debian.org/debian-security/ \
  --mirror-binary http://deb.debian.org/debian/ \
  --mirror-binary-security http://security.debian.org/debian-security/ \
  --bootappend-live "boot=live components hostname=libreforge username=user" \
  --linux-flavours amd64 \
  --linux-packages linux-image

# Add LibreForgeOS packages
echo "[3/5] Configuring packages..."
cat > config/package-lists/libreforge.list.chroot << 'EOF'
# Linux 7 Kernel
linux-image-amd64
linux-headers-amd64
linux-source

# Base packages
vim
curl
ruby
fish
p7zip-full
exa
fastfetch

# GNOME Desktop
gnome-shell
gnome-tweaks
gnome-desktop-environment

# Gaming and multimedia
steam
lutris
wine
wine32
wine64
proton-gamemode
mangohud
goverlay
ardour
obs-studio
discord

# Flatpak support
flatpak
flatpak.io

# Development
build-essential
git
wget
EOF

# Create hooks for theme installation
echo "[4/5] Setting up post-install hooks..."
mkdir -p config/hooks/normal
cat > config/hooks/normal/8000-libreforge-themes.chroot << 'EOF'
#!/bin/bash
set -e

# Set up fish shell
mkdir -p /etc/skel/.config/fish
echo "# LibreForgeOS Fish Configuration" > /etc/skel/.config/fish/config.fish

# Set up GTK themes directory
mkdir -p /etc/skel/.config/gtk-4.0/

# Install BetterDiscord support
mkdir -p /etc/skel/.config/BetterDiscord/themes

# OBS themes directory
mkdir -p /etc/skel/.config/obs-studio/themes

# Enable Flatpak by default
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true

echo "LibreForgeOS customizations installed!"
EOF

chmod +x config/hooks/normal/8000-libreforge-themes.chroot

# Build the ISO
echo "[5/5] Building ISO image (this may take 10-20 minutes)..."
sudo lb build 2>&1 | tee build.log

# Copy ISO to output directory
if [ -f "live-image-amd64.hybrid.iso" ]; then
  sudo cp live-image-amd64.hybrid.iso ../$OUTPUT_DIR/LibreForgeOS-Debian-${DISTRO_VERSION}-amd64-live.iso
  sudo chown $(whoami):$(whoami) ../$OUTPUT_DIR/LibreForgeOS-Debian-${DISTRO_VERSION}-amd64-live.iso
  echo ""
  echo "=========================================="
  echo "✓ ISO Build Complete!"
  echo "ISO Location: $(pwd)/../${OUTPUT_DIR}/LibreForgeOS-Debian-${DISTRO_VERSION}-amd64-live.iso"
  echo "Size: $(du -h ../$OUTPUT_DIR/LibreForgeOS-Debian-${DISTRO_VERSION}-amd64-live.iso | cut -f1)"
  echo "=========================================="
else
  echo "✗ ISO build failed. Check build.log for details."
  exit 1
fi
