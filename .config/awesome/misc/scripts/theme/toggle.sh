#!/bin/bash

# toggles between dark and light theme

# theme file with current theme
THEME_FILE="$HOME/.config/awesome/misc/scripts/theme/current_theme"

# output of theme file
CMD=$(source $THEME_FILE && echo $THEME)

# compare and execute
if [ "$CMD" = "dark" ]; then
    $HOME/.config/awesome/misc/scripts/theme/light.sh
    sed -i "1s/.*/THEME=light/g" ~/.config/awesome/misc/scripts/theme/current_theme
else
    $HOME/.config/awesome/misc/scripts/theme/dark.sh
    sed -i "1s/.*/THEME=dark/g" ~/.config/awesome/misc/scripts/theme/current_theme

fi