#!/bin/bash

# changes current color scheme to the dark theme

# gtk theme
GTKTHEME="Materia-dark"
sed -i "2s/.*/gtk-theme-name=${GTKTHEME}/g" ~/.config/gtk-3.0/settings.ini

# awesome ui
sed -i "28s/.*/local theme = themes[2]/g" ~/.config/awesome/rc.lua

# set ncmpcpp client color
sed -i "3s/.*/- ~\/.config\/alacritty\/colors-material.yml/g" ~/.config/alacritty/ncmpcpp.yml

# alacritty color
sed -i "3s/.*/- ~\/.config\/alacritty\/colors-material.yml/g" ~/.config/alacritty/alacritty.yml

