#!/usr/bin/env bash

# Rofi mpd menu

# checks weather mpd is running, if not. then it'll start it
mpc status &> /dev/null
if test $? -eq 1
then
	notify-send -t 700 -u normal "mpd is not running" "starting mpd.." && mpd
	exit
fi       


# var for music status
status="$(mpc status | grep "playing")"

ROFI="rofi -theme $HOME/.config/awesome/misc/scripts/Rofi/themes/four-horizontal.rasi"

# setup
A='' B='' C='' D='' 

if  $status ; then
    B=''
else
    B=''
fi

isloop="$(mpc status | grep -o "repeat: on")"

if $isloop ; then
	LOOP_STAT="loop enabled!"
else
	LOOP_STAT="loop disbled!"
fi


MENU="$(printf "${A}\n${B}\n${C}\n${D}\n" | ${ROFI} -p "??" -dmenu -selected-row 1)"

case "$MENU" in
    "$A") mpc -q prev

    ;;
    "$B") mpc -q toggle

    ;;
    "$C") mpc -q next

    ;;
    "$D") mpc -q loop && notify-send -t 950 "Hey!" "$LOOP_STAT"
    ;;
esac 

exit ${?}
