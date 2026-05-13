# LibreForgeOS - Complete Build System

A comprehensive multi-distribution Linux ISO builder for gaming, streaming, and music production with Star Trek ENT 23rd Century LCARs theming.

## Quick Start

```bash
# Build all ISO variants
chmod +x build-all-iso.sh
./build-all-iso.sh

# Generate checksums
chmod +x generate-checksums.sh
./generate-checksums.sh

# Burn to USB
chmod +x burn-iso.sh
./burn-iso.sh
```

## Directory Structure

```
Auto-install-scripts/
├── debian/
│   ├── debian-setup.sh              # Post-install configuration
│   ├── libreforgeos-debian.preseed  # Unattended installation
│   └── build-iso.sh                 # ISO builder
├── fedora/
│   ├── fedora-setup.sh              # Post-install configuration
│   ├── libreforgeos-fedora.ks       # Kickstart configuration
│   └── build-iso.sh                 # ISO builder
├── arch/
│   ├── arch-setup.sh                # Post-install configuration
│   └── build-iso.sh                 # archiso builder
├── iso-output/                      # Generated ISO images
├── build-all-iso.sh                 # Multi-distribution builder
├── generate-checksums.sh            # Checksum generator
├── burn-iso.sh                      # USB burner utility
├── grub.cfg                         # Multi-boot GRUB configuration
├── ISO-BUILD-INFO.md                # ISO documentation
└── README.md                        # This file
```

## Distribution Variants

### 🐧 Debian-based LibreForgeOS
- **Base**: Debian Bookworm (stable)
- **Desktop**: GNOME with Wayland
- **Package Manager**: apt
- **Build System**: live-build
- **Size**: ~3.5 GB

**Advantages**:
- Largest software repository
- Longest support cycle
- Traditional package management
- Excellent stability

### 🎩 Fedora-based LibreForgeOS
- **Base**: Fedora 39+ (bleeding edge)
- **Desktop**: GNOME with Wayland
- **Package Manager**: dnf
- **Build System**: lorax/liveimage-creator
- **Size**: ~3.8 GB

**Advantages**:
- Latest software packages
- RPMFusion gaming repositories
- SELinux support
- Modern tooling

### 🏹 Arch-based LibreForgeOS
- **Base**: Arch Linux (rolling)
- **Desktop**: GNOME with Wayland
- **Package Manager**: pacman
- **Build System**: archiso
- **Size**: ~3.2 GB

**Advantages**:
- Rolling updates
- Garuda Dragonized integration
- Access to AUR (community packages)
- Lightweight and fast
- Cutting-edge packages

## Included Features (All Variants)

### 🎮 Gaming
- Steam with Proton
- Lutris game manager
- Wine with 32/64-bit support
- MangoHUD (FPS overlay)
- GameMode optimization
- Support for every modern game

### 📹 Streaming & Recording
- OBS Studio with LCARs theme
- Advanced scene management
- Multi-source audio
- GPU encoding support (NVENC/VAAPI)
- Custom LCARs interface

### 🎵 Music Production
- Ardour Digital Audio Workstation
- ALSA & PulseAudio support
- JACK audio server
- Low-latency recording
- Professional mixing capabilities

### 💬 Communication
- Discord with LCARs theme (via BetterDiscord)
- Twitch support
- Matrix/Element chat
- Telegram client

### 🎨 Theming
- Star Trek ENT 23rd Century LCARs schema
- GNOME Shell theming
- GTK-4 dark theme
- Custom cursor themes
- Wallpaper packs (P1-P5, Purple, 76 Walls)

### 🛠️ Development
- Build tools (gcc, make, cmake)
- Git & version control
- Ruby, Python, Node.js
- Fish shell with fastfetch
- Full compilation support

## Building ISOs

### Prerequisites

**Debian/Ubuntu**:
```bash
sudo apt install live-build debootstrap syslinux isolinux xorriso squashfs-tools
```

**Fedora**:
```bash
sudo dnf install livecd-tools pungi-utils lorax spin-kickstarts
```

**Arch**:
```bash
sudo pacman -S archiso
```

### Build Single Distribution
```bash
cd debian && bash build-iso.sh
cd fedora && bash build-iso.sh
cd arch && bash build-iso.sh
```

### Build All at Once
```bash
bash build-all-iso.sh 2>&1 | tee build.log
```

Build time estimates:
- Debian: 15-20 minutes
- Fedora: 20-25 minutes
- Arch: 25-30 minutes

## Installation Methods

### 1. Live USB Boot (Recommended)
```bash
bash burn-iso.sh
```
- Insert USB drive
- Follow prompts
- Boot from USB on target machine
- Click "Install" from desktop menu

### 2. Unattended Network Installation

**Debian**:
```bash
# Use preseed file for fully automated install
# Configure network boot via DHCP + preseed URL
```

**Fedora**:
```bash
# Use Kickstart file via network boot
# Point to libreforgeos-fedora.ks URL
```

### 3. Virtual Machine
```bash
# QEMU/KVM
qemu-system-x86_64 -m 4G -smp 4 -enable-kvm \
  -cdrom iso-output/LibreForgeOS-*.iso

# VirtualBox
VBoxManage createvm --name LibreForgeOS --ostype Linux_64
```

## ISO Verification

### Generate Checksums
```bash
bash generate-checksums.sh
```

### Verify Downloaded ISOs
```bash
cd iso-output
sha256sum -c LibreForgeOS-Checksums-*.txt
```

### Manual Verification
```bash
sha256sum LibreForgeOS-Debian-*.iso
sha256sum LibreForgeOS-Fedora-*.iso
sha256sum LibreForgeOS-Arch-*.iso
```

## System Requirements

### Minimum (All Variants)
- **CPU**: 2 GHz dual-core
- **RAM**: 2 GB minimum, 4 GB recommended
- **Disk**: 20 GB SSD (minimum), 50 GB recommended
- **GPU**: Any integrated graphics
- **Network**: Optional (for package downloads)

### Recommended (Gaming/Streaming)
- **CPU**: 4+ GHz quad-core (6+ cores for streaming)
- **RAM**: 16 GB minimum, 32 GB for streaming
- **Disk**: 100+ GB SSD (OS + games + recordings)
- **GPU**: NVIDIA GTX 1060+ or AMD equivalent
- **Network**: Gigabit Ethernet (for streaming)

## Post-Installation

### First Boot Setup
1. Update system packages
2. Configure user accounts
3. Install additional applications
4. Configure streaming/music software
5. Apply custom themes

### Update System
```bash
# Debian/Ubuntu
sudo apt update && sudo apt upgrade -y

# Fedora
sudo dnf upgrade -y

# Arch
sudo pacman -Syu
```

### Run Distribution-Specific Setup
```bash
cd debian && bash debian-setup.sh
cd fedora && bash fedora-setup.sh
cd arch && bash arch-setup.sh
```

## Troubleshooting

### ISO Build Fails
- Check disk space (need 20+ GB free)
- Verify internet connection
- Check build logs in iso-output/
- Try building one distribution at a time

### Booting Issues
- Ensure USB drive is bootable (use burn-iso.sh)
- Try BIOS/UEFI hybrid mode in boot menu
- Disable Secure Boot if needed
- Check ISO integrity with checksums

### Installation Hangs
- Disable hardware acceleration in installer
- Try nomodeset kernel parameter
- Use console-only installation
- Check system RAM (minimum 2GB)

## Customization

### Modify Package Lists
Edit distribution-specific files:
- `debian/build-iso.sh` - config/package-lists/
- `fedora/libreforgeos-fedora.ks` - %packages section
- `arch/build-iso.sh` - packages.x86_64 file

### Change Theming
Place custom theme files in:
- `gtk-4.0/` - GTK themes
- Theme archives in root directory
- Custom wallpapers in P1-P5 folders

### Add Custom Scripts
Modify post-install hooks:
- `debian/build-iso.sh` - config/hooks/normal/
- `fedora/libreforgeos-fedora.ks` - %post section
- `arch/build-iso.sh` - customize_airootfs.sh

## File Descriptions

| File | Purpose |
|------|---------|
| `build-all-iso.sh` | Master script to build all variants |
| `debian/build-iso.sh` | Debian ISO builder using live-build |
| `fedora/build-iso.sh` | Fedora ISO builder using lorax |
| `arch/build-iso.sh` | Arch ISO builder using archiso |
| `debian-setup.sh` | Debian post-installation customization |
| `fedora-setup.sh` | Fedora post-installation customization |
| `arch-setup.sh` | Arch post-installation customization |
| `generate-checksums.sh` | Create ISO verification checksums |
| `burn-iso.sh` | Safe USB drive burning utility |
| `grub.cfg` | Multi-boot GRUB configuration |
| `ISO-BUILD-INFO.md` | Detailed ISO documentation |

## Performance Tuning

### Kernel Parameters
Edit GRUB configuration:
```bash
# For gaming
intel_idle.max_cstate=1  # Disable C-states for better latency
cpufreq.default_governor=performance

# For low-latency audio
rt  # Real-time kernel (Arch only)
```

### GPU Acceleration
```bash
# Verify Vulkan support
vulkaninfo

# Check DRI drivers
glxinfo | grep "OpenGL"

# NVIDIA
nvidia-smi

# AMD
radeontop
```

## Network Boot (PXE)

### Configure DHCP Server
```
dhcp-boot=vmlinuz,libreforge,192.168.1.100
```

### HTTP Server
```bash
# Debian
cd debian-live-build && python3 -m http.server 8080

# Fedora
cd fedora-build && python3 -m http.server 8080

# Arch
cd archiso-build && python3 -m http.server 8080
```

## Support & Documentation

- **Official Docs**: See `ISO-BUILD-INFO.md`
- **Build Logs**: Check `build_TIMESTAMP.log`
- **Upstream**: Refer to distribution documentation
  - Debian: https://debian.org
  - Fedora: https://fedoraproject.org
  - Arch: https://archlinux.org

## Contributing

To contribute improvements:
1. Fork the repository
2. Create a feature branch
3. Make changes to scripts
4. Test on all variants
5. Submit pull request

## License

LibreForgeOS respects licenses of all included software:
- **Debian**: DFSG-compliant free software
- **Fedora**: Fedora Project License
- **Arch**: Various FOSS licenses
- **Star Trek Theming**: Fan-made, non-commercial

## Credits

LibreForgeOS integrates:
- Debian Live-Build
- Fedora Kickstart/Lorax
- Arch ISO tools
- GNOME Desktop
- Steam/Proton
- OBS Studio
- Ardour DAW
- Garuda Linux theming

---

**LibreForgeOS** - Enterprise-Grade Gaming & Streaming Linux Distribution  
*Built with the precision of Starfleet technology*

**Version**: 1.0  
**Last Updated**: May 13, 2026
