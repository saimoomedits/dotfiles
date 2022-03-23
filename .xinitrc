#!/bin/sh
#############
#  XINITRC  #
#############
# I dont have many things going on here, since I use the window manager's
# config file to for startups and things

# initial Xresources merge
xrdb merge ${HOME}/.Xresources &

# polkit 
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &


###################
# window managers #
###################

# exec bspwm
# exec berry
exec awesome

