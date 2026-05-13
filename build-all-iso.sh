#!/bin/bash
# LibreForgeOS Multi-Distribution ISO Builder
# Builds all three ISO variants in sequence

set -e

OUTPUT_DIR="./iso-output"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BUILD_LOG="build_${TIMESTAMP}.log"

mkdir -p $OUTPUT_DIR

echo "=========================================="
echo "LibreForgeOS Multi-Distribution ISO Builder"
echo "=========================================="
echo "Output Directory: $OUTPUT_DIR"
echo "Build Log: $BUILD_LOG"
echo ""

# Function to build each ISO
build_debian() {
  echo "┌──────────────────────────────────────────┐"
  echo "│ Building Debian-based LibreForgeOS ISO   │"
  echo "└──────────────────────────────────────────┘"
  cd debian
  chmod +x build-iso.sh
  ./build-iso.sh 2>&1 | tee -a ../$BUILD_LOG
  cd ..
  echo ""
}

build_fedora() {
  echo "┌──────────────────────────────────────────┐"
  echo "│ Building Fedora-based LibreForgeOS ISO   │"
  echo "└──────────────────────────────────────────┘"
  cd fedora
  chmod +x build-iso.sh
  ./build-iso.sh 2>&1 | tee -a ../$BUILD_LOG
  cd ..
  echo ""
}

build_arch() {
  echo "┌──────────────────────────────────────────┐"
  echo "│ Building Arch-based LibreForgeOS ISO     │"
  echo "└──────────────────────────────────────────┘"
  cd arch
  chmod +x build-iso.sh
  ./build-iso.sh 2>&1 | tee -a ../$BUILD_LOG
  cd ..
  echo ""
}

# Build ISOs
build_debian
build_fedora
build_arch

# Summary
echo "=========================================="
echo "✓ All ISO builds complete!"
echo "=========================================="
echo ""
echo "Generated ISOs:"
echo ""
ls -lh $OUTPUT_DIR/*.iso 2>/dev/null || echo "No ISOs found in $OUTPUT_DIR"
echo ""
echo "MD5 Checksums:"
md5sum $OUTPUT_DIR/*.iso 2>/dev/null || echo "No ISOs to checksum"
echo ""
echo "Build log saved to: $BUILD_LOG"
echo "=========================================="
