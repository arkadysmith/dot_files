waybar -c ~/.config/mango/config.jsonc -s ~/.config/mango/style.css >/dev/null 2>&1 &
swaybg -i ~/dot_files/.config/wallpaper.jpg >/dev/null 2>&1 &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &
pipewire &
pipewire-pulse &
wireplumber &
pgrep -x xdg-desktop-portal >/dev/null || xdg-desktop-portal &
/usr/lib/xdg-desktop-portal-wlr 2>&1 &
pactl set-sink-volume @DEFAULT_SINK@ 100% &
bash cifs.sh &
