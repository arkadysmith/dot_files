#!/bin/bash
# mangowc setup
set -e

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

die() { echo -e "${RED}ERROR: $*${NC}" >&2; exit 1; }
msg() { echo -e "${CYAN}$*${NC}"; }

# enable AUR
sudo pacman -S --needed base-devel git &
clone https://aur.archlinux.org/yay.git &
makepkg -si &

# packages
PACKAGES_CORE=(
    glibc meson ninja cmake curl pkgconf
)

PACKAGES_MINIMAL=(
    alacritty foot rofi wl-clipboard grim slurp swaybg librewolf ttf-jetbrains-mono-nerd
)

PACKAGES_ESSENTIALS=(
    thunar thunar-archive-plugin thunar-volman gvfs dialog mtools smbclient cifs-utils unzip pavucontrol alsa-utils pipewire pipewire-pulse wireplumber xdg-user-dirs-gtk eza ttf-font-awesome terminus-font polkit-gnome
)
#
#git clone -b 0.19.3 https://gitlab.freedesktop.org/wlroots/wlroots.git &&
#cd wlroots &&
#meson build -Dprefix=/usr &&
#sudo ninja -C build install &&

#git clone -b 0.4.1 https://github.com/wlrfx/scenefx.git &&
#dd scenefx &&
#meson build -Dprefix=/usr &&
#sudo ninja -C build install &&

#git clone https://github.com/mangowm/mango.git &&
#cd mangowm &&
#meson build -Dprefix=/usr &&
#sudo ninja -C build install &&


# Install packages by group
    msg "installing core packages..."
    sudo pacman -S "${PACKAGES_CORE[@]}" || die "Failed to install core packages"

    msg "installing minimal..."
    sudo pacman -S "${PACKAGES_MINIMAL[@]}" || die "Failed"

    msgg "installing essentials..."
    sudo pacman -S "${PACKAGES_ESSENTIALS[@]}" || die "Failed"


#installing mango
msg "Cloning mango..."
yay -S mangowc-git &&
cd ~/ &&
git clone https://github.com/arkadysmith/dot_files &&
cd ~/dot_files/.config &&
bash dotlink.sh &&

echo -e "\n${GREEN}Installation complete!${NC}"
