#!/bin/bash

# changes current color scheme to the light theme

# GTK theme
GTKTHEME="Materia-light"
sed -i "2s/.*/gtk-theme-name=${GTKTHEME}/g" ~/.config/gtk-3.0/settings.ini

# awesome ui
sed -i "28s/.*/local theme = themes[1]/g" ~/.config/awesome/rc.lua

# set ncmpcpp client color
sed -i "3s/.*/- ~\/.config\/alacritty\/colors-light.yml/g" ~/.config/alacritty/ncmpcpp.yml

# alacritty color
sed -i "3s/.*/- ~\/.config\/alacritty\/colors-light.yml/g" ~/.config/alacritty/alacritty.yml

