waybar -c ~/.config/mango/config.jsonc -s ~/.config/mango/style.css >/dev/null 2>&1 &
swaybg -i ~/dot_files/.config/wallpaper.jpg >/dev/null 2>&1 &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &
/usr/lib/xdg-desktop-portal-wlr &
pactl set-sink-volume @DEFAULT_SINK@ 100% &
bash cifs.sh &
