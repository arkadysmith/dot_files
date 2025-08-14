
# Autostart applications
#/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
lxpolkit > /dev/null 2>&1 &
# bar start
#~/.config/i3/polybar-i3 &

# compositor and notifications
picom --animations -b &
# numlockx on &
dunst &
# blueman-applet &

# sxhkd
sxhkd -c ~/.config/i3/sxhkdrc &
