#!/bin/bash

# autostart file for my Awesome-WM setup

# first checks weather the process is already is present.
# this is a handy feature since, you might need to restart awesome.

# compositor (picom)
if [ ! $(pidof picom) ]; then
    picom --config $HOME/.config/awesome/misc/picom/picom.conf
fi

# mpd
if [ ! $(pidof mpd) ]; then
    amixer -D pulse set Master 20%          # set volume to a default amount
    mpd 
fi