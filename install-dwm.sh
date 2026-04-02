#!/bin/bash
#DWM Setup

set -e

# Command line options
ONLY_CONFIG=false
EXPORT_PACKAGES=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --only-config)
            ONLY_CONFIG=true
            shift
            ;;
        --export-packages)
            EXPORT_PACKAGES=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "  --only-config      Only copy config files (skip packages and external tools)"
            echo "  --export-packages  Export package lists for different distros and exit"
            echo "  --help            Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
TEMP_DIR="/tmp/dwm_$$"
LOG_FILE="$HOME/dwm-install.log"

# Logging and cleanup
exec > >(tee -a "$LOG_FILE") 2>&1
trap "rm -rf $TEMP_DIR" EXIT

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

die() { echo -e "${RED}ERROR: $*${NC}" >&2; exit 1; }
msg() { echo -e "${CYAN}$*${NC}"; }

# Export package lists for different distros
export_packages() {
    echo "=== DWM Setup - Package Lists for Different Distributions ==="
    echo
    
    # Combine all packages
    local all_packages=(
        "${PACKAGES_CORE[@]}"
        "${PACKAGES_UI[@]}"
        "${PACKAGES_FILE_MANAGER[@]}"
        "${PACKAGES_AUDIO[@]}"
        "${PACKAGES_UTILITIES[@]}"
        "${PACKAGES_TERMINAL[@]}"
        "${PACKAGES_FONTS[@]}"
        "${PACKAGES_BUILD[@]}"
    )
    
    echo "DEBIAN/UBUNTU:"
    echo "sudo apt install ${all_packages[*]}"
    echo
    
    # Arch equivalents
    local arch_packages=(
        "xorg-server xorg-xinit xorg-xbacklight xbindkeys xvkbd xorg-xinput"
        "base-devel sxhkd xdotool"
        "libnotify"
        "rofi dunst feh lxappearance network-manager-applet"
        "thunar thunar-archive-plugin thunar-volman"
        "gvfs dialog mtools smbclient cifs-utils unzip"
        "pavucontrol pulsemixer pamixer pipewire-pulse"
        "avahi acpi acpid xfce4-power-manager flameshot"
        "qimgv firefox nala xdg-user-dirs-gtk"
        "suckless-tools eza"
        "ttf-font-awesome terminus-font"
        "cmake meson ninja curl pkgconf"
    )
    
    echo "ARCH LINUX:"
    echo "sudo pacman -S ${arch_packages[*]}"
    echo
    
    # Fedora equivalents
    local fedora_packages=(
        "xorg-x11-server-Xorg xorg-x11-xinit xbacklight xbindkeys xvkbd xinput"
        "gcc make git sxhkd xdotool"
        "libnotify"
        "rofi dunst feh lxappearance NetworkManager-gnome"
        "thunar thunar-archive-plugin thunar-volman"
        "gvfs dialog mtools samba-client cifs-utils unzip"
        "pavucontrol pulsemixer pamixer pipewire-pulseaudio"
        "avahi acpi acpid xfce4-power-manager flameshot"
        "qimgv firefox xdg-user-dirs-gtk"
        "eza"
        "fontawesome-fonts terminus-fonts"
        "cmake meson ninja-build curl pkgconfig"
    )
    
    echo "FEDORA:"
    echo "sudo dnf install ${fedora_packages[*]}"
    echo
    
    echo "NOTE: Some packages may have different names or may not be available"
    echo "in all distributions. You may need to:"
    echo "  - Find equivalent packages in your distro's repositories"
    echo "  - Install some tools from source (like suckless tools)"
    echo "  - Use alternative package managers (AUR for Arch, Flatpak, etc.)"
    echo
    echo "After installing packages, you can use:"
    echo "  $0 --only-config    # To copy just the DWM configuration files"
}

# Check if we should export packages and exit
if [ "$EXPORT_PACKAGES" = true ]; then
    export_packages
    exit 0
fi

read -p "Install DWM? (y/n) " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

# Update system
if [ "$ONLY_CONFIG" = false ]; then
    msg "Updating system..."
    sudo apt-get update && sudo apt-get upgrade -y

fi

# Package groups for better organization
PACKAGES_CORE=(
    xorg xorg-dev xbacklight xbindkeys xvkbd xinput
    build-essential sxhkd xdotool dbus-x11
    libnotify-bin libnotify-dev libusb-0.1-4
)

PACKAGES_UI=(
    dunst feh lxappearance network-manager-gnome lxpolkit
)

PACKAGES_FILE_MANAGER=(
    thunar thunar-archive-plugin thunar-volman
    gvfs-backends dialog mtools smbclient cifs-utils unzip
)

PACKAGES_AUDIO=(
    pavucontrol pulsemixer pamixer pipewire-audio
)

PACKAGES_UTILITIES=(
    avahi-daemon acpi acpid xfce4-power-manager
    flameshot qimgv xdg-user-dirs-gtk fd-find
)

PACKAGES_TERMINAL=(
    suckless-tools
)

PACKAGES_FONTS=(
    fonts-recommended fonts-font-awesome fonts-terminus
)

PACKAGES_BUILD=(
    cmake meson ninja-build curl pkg-config wget
)


# Install packages by group
if [ "$ONLY_CONFIG" = false ]; then
    msg "Installing core packages..."
    sudo apt-get install -y "${PACKAGES_CORE[@]}" || die "Failed to install core packages"

    msg "Installing UI components..."
    sudo apt-get install -y "${PACKAGES_UI[@]}" || die "Failed to install UI packages"

    msg "Installing file manager..."
    sudo apt-get install -y "${PACKAGES_FILE_MANAGER[@]}" || die "Failed to install file manager"

    msg "Installing audio support..."
    sudo apt-get install -y "${PACKAGES_AUDIO[@]}" || die "Failed to install audio packages"

    msg "Installing system utilities..."
    sudo apt-get install -y "${PACKAGES_UTILITIES[@]}" || die "Failed to install utilities"
    
    # Try firefox-esr first (Debian), then firefox (Ubuntu)
    sudo apt-get install -y firefox-esr 2>/dev/null || sudo apt-get install -y firefox 2>/dev/null || msg "Note: firefox not available, skipping..."

    msg "Installing terminal tools..."
    sudo apt-get install -y "${PACKAGES_TERMINAL[@]}" || die "Failed to install terminal tools"
    
    # Try exa first (Debian 12), then eza (newer Ubuntu)
    sudo apt-get install -y exa 2>/dev/null || sudo apt-get install -y eza 2>/dev/null || msg "Note: exa/eza not available, skipping..."

   # msg "Installing fonts..."
  #  sudo apt-get install -y "${PACKAGES_FONTS[@]}" || die "Failed to install fonts"

 #   msg "Installing build dependencies..."
    sudo apt-get install -y "${PACKAGES_BUILD[@]}" || die "Failed to install build tools"

    # Enable services
    sudo systemctl enable avahi-daemon acpid
else
    msg "Skipping package installation (--only-config mode)"
fi

# Handle existing config
if [ -d "$CONFIG_DIR" ]; then
    clear
    read -p "Found existing suckless config. Backup? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv "$CONFIG_DIR" "$CONFIG_DIR.bak.$(date +%s)"
        msg "Backed up existing config"
    else
        clear
        read -p "Overwrite without backup? (y/n) " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] || die "Installation cancelled"
        rm -rf "$CONFIG_DIR"
    fi
fi

# Copy configs
msg "Setting up configuration..."
mkdir -p "$CONFIG_DIR"
cp -r "$SCRIPT_DIR"/suckless/* "$CONFIG_DIR"/ || die "Failed to copy configs"

# Build suckless tools
msg "Building suckless tools..."
for tool in dwm slstatus st tabbed; do
    cd "$CONFIG_DIR/$tool" || die "Cannot find $tool"
    make && sudo make install || die "Failed to build $tool"
done

# Setup directories
xdg-user-dirs-update
mkdir -p ~/Screenshots
cd ~/
# Scripts, dot_files
git clone https://github.com/arkadysmith/dot_files

# Install essential components
if [ "$ONLY_CONFIG" = false ]; then
    mkdir -p "$TEMP_DIR" && cd "$TEMP_DIR"

    msg "Installing picom..."
    sudo apt-get install -y picom || die "Failed to install picom"

    msg "Installing rofi..."
    sudo apt-get install -y rofi || die "Failed to install rofi"

    msg "Installing alacritty..."
    sudo apt-get install -y alacritty

    msg "Installing fonts..."
    bash ~/dot_files/install_nerdfonts.sh

    msg "Installing themes..."
    bash ~/dot_files/install_theme.sh
    
    fi

# Done
echo -e "\n${GREEN}Installation complete!${NC}"
echo "Now! Reboot!"

