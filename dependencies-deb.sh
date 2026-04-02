#!/bin/bash
sudo apt update &&
	sudo apt install -y xorg xorg-dev xbacklight xbindkeys xvkbd xinput build-essentials sxhkd xdotool dbus-x11 libnotify-bin libnotify-dev libusb-0.1-4 &
# UI
sudo apt update &
sudo apt install -y dunst feh lxappearance network-manager-gnome lxpolkit &
# FILE MANAGER
sudo apt install -y thunar thunar-archive-plugin thunar-volman gvfs-backends dialog mtools smbclient cifs-utils unzip &
# AUDIO
sudo apt install -y pavucontrol pulsemixer pamixer piperwire-audio &
# UTILITIES
sudo apt install -y avahi-daemon acpi acpid xfce4-power-manager flameshot qimgv xdg-user-dirs-gtk fd-find &
# TERMINAL
sudo apt install -y suckless-tools &
# FONTS
sudo apt install -y fonts-recommended fonts-font-awesome fonts-terminus &
# BUILD
sudo apt install -y cmake meson ninja-build curl pkg-config wget
