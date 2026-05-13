#!/bin/bash
# LibreForgeOS Fedora Live ISO Builder
# Creates a bootable ISO from Fedora with LibreForgeOS customizations

set -e

DISTRO_NAME="LibreForgeOS"
DISTRO_VERSION="1.0"
KS_FILE="libreforgeos-fedora.ks"
OUTPUT_DIR="../iso-output"

echo "=========================================="
echo "Building $DISTRO_NAME Live ISO (Fedora-based)"
echo "=========================================="

# Create output directory
mkdir -p $OUTPUT_DIR

# Check if Kickstart file exists
if [ ! -f "$KS_FILE" ]; then
  echo "✗ Error: $KS_FILE not found!"
  exit 1
fi

# Install build dependencies
echo "[1/3] Installing build dependencies..."
sudo dnf install -y livecd-tools pungi-utils lorax spin-kickstarts

# Prepare Kickstart file with local customizations
echo "[2/3] Preparing Kickstart configuration..."
cp $KS_FILE /tmp/libreforge-fedora.ks

# Add network config to Kickstart if needed
cat >> /tmp/libreforge-fedora.ks << 'EOF'

%post
# Add Chaotic-AUR equivalent for Fedora (CoPR repos for gaming)
sudo dnf copr enable -y che/nerd-fonts || true
sudo dnf copr enable -y zeno/scrcpy || true

# Set default shell to fish
sed -i 's/^user:.*:$/user:x:1000:1000:LibreForge User:\/home\/user:\/usr\/bin\/fish/' /etc/passwd || true

# Create directories for themes
mkdir -p /home/user/.config/fish
mkdir -p /home/user/.config/gtk-4.0
mkdir -p /home/user/.config/obs-studio/themes
mkdir -p /home/user/.config/BetterDiscord/themes

# Set permissions
chown -R user:user /home/user/.config

echo "LibreForgeOS Fedora configuration complete!"
%end
EOF

# Build the ISO using livecd-tools
echo "[3/3] Building ISO image (this may take 15-25 minutes)..."

# Use liveimage-creator or lorax based on available tool
if command -v liveimage-creator &> /dev/null; then
  sudo liveimage-creator -c /tmp/libreforge-fedora.ks \
    -o LibreForgeOS-Fedora-${DISTRO_VERSION}-Live.iso \
    --cache=/tmp/libreforgeos-cache \
    --title="LibreForgeOS" \
    --releasever=39
elif command -v lorax &> /dev/null; then
  sudo lorax \
    -p LibreForgeOS \
    -v ${DISTRO_VERSION} \
    -r ${DISTRO_VERSION} \
    -s /tmp/libreforge-fedora.ks \
    -o ./lorax-output/
else
  echo "✗ Neither liveimage-creator nor lorax found!"
  echo "Installing via pungi..."
  sudo dnf install -y python3-pykickstart
fi

# Copy ISO to output directory if build succeeded
if [ -f "LibreForgeOS-Fedora-${DISTRO_VERSION}-Live.iso" ]; then
  sudo cp LibreForgeOS-Fedora-${DISTRO_VERSION}-Live.iso $OUTPUT_DIR/
  sudo chown $(whoami):$(whoami) $OUTPUT_DIR/LibreForgeOS-Fedora-${DISTRO_VERSION}-Live.iso
  echo ""
  echo "=========================================="
  echo "✓ ISO Build Complete!"
  echo "ISO Location: $(pwd)/${OUTPUT_DIR}/LibreForgeOS-Fedora-${DISTRO_VERSION}-Live.iso"
  echo "Size: $(du -h $OUTPUT_DIR/LibreForgeOS-Fedora-${DISTRO_VERSION}-Live.iso | cut -f1)"
  echo "=========================================="
else
  echo "✗ ISO build failed. Check logs for details."
  exit 1
fi
