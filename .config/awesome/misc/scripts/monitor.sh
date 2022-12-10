#!/bin/bash

INTERNAL_MONITOR="LVDS1"
EXTERNAL_MONITOR="VGA1"

if [[ $(xrandr -q | grep "${EXTERNAL_MONITOR} connected") ]]; then
			xrandr --output $INTERNAL_MONITOR --off
else
			xrandr --auto
fi
