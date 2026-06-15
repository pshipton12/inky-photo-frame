#!/bin/bash

# Inky Photo Frame - Installation Script
# For Raspberry Pi with Inky Impression 7.3" display

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════╗"
echo "║     📷 Inky Photo Frame - Installation                 ║"
echo "║     Universal - All Inky Impression Models             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Variables
PHOTOS_DIR="/home/peter/Images"
INSTALL_DIR="/home/peter/inky-photo-frame"
PASSWORD_FILE="/home/peter/.inky_credentials"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ]; then
    print_error "This script must be run on a Raspberry Pi"
    exit 1
fi

print_status "Starting installation..."

# STEP 5: Create photos directory
print_info "STEP 5: Creating photos directory..."
mkdir -p $PHOTOS_DIR
chown peter:peter $PHOTOS_DIR
chmod 755 $PHOTOS_DIR

# STEP 9: Create installation directory
print_info "STEP 9: Creating application directory..."
mkdir -p $INSTALL_DIR

# STEP 10: Download application files from GitHub
print_info "STEP 10: Downloading application files from GitHub..."

GITHUB_RAW="https://raw.githubusercontent.com/mehdi7129/inky-photo-frame/main"

# Download root-level files
ROOT_FILES=(
    "inky_photo_frame.py"
    "update.sh"
    "inky-photo-frame-cli"
    "logrotate.conf"
)

for file in "${ROOT_FILES[@]}"; do
    print_info "Downloading $file..."
    curl -sSL -o $INSTALL_DIR/$file "$GITHUB_RAW/$file"
    if [ $? -ne 0 ]; then
        print_error "Failed to download $file"
        exit 1
    fi
    chmod +x $INSTALL_DIR/$file
done

# Download package modules
print_info "Downloading inky_photo_frame package..."
mkdir -p $INSTALL_DIR/inky_photo_frame

PACKAGE_FILES=(
    "__init__.py"
    "__main__.py"
    "config.py"
    "display.py"
    "image_processor.py"
    "photos.py"
    "buttons.py"
    "welcome.py"
    "app.py"
)

for file in "${PACKAGE_FILES[@]}"; do
    curl -sSL -o "$INSTALL_DIR/inky_photo_frame/$file" "$GITHUB_RAW/inky_photo_frame/$file"
    if [ $? -ne 0 ]; then
        print_error "Failed to download inky_photo_frame/$file"
        exit 1
    fi
done

print_status "Application files downloaded successfully (shim + 9 package modules)"

# Get IP address
IP_ADDRESS=$(hostname -I | cut -d' ' -f1)

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║     ✅ Installation completed successfully!            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "   Add photos to start your slideshow!"
echo ""
echo "🛠️  USEFUL COMMANDS:"
echo "   inky-photo-frame status    # Check service status"
echo "   inky-photo-frame logs      # View live logs"
echo "   inky-photo-frame update    # Update to latest version"
echo "   inky-photo-frame info      # Show system information"
echo "   inky-photo-frame help      # Show all commands"
echo ""
