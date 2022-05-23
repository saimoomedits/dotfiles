-- a lua script that changes theme based on variable
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- source: https://github.com/saimoomedits/dotfiles
-- idk.
-- this will be improved later, maybe.
-- for now it works fine. :/


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local readwrite = require("misc.scripts.read_writer")



-- misc/vars
-- ~~~~~~~~~

-- current theme state file
local output =  readwrite.readall("theme_state")

-- apply light/dark theme
-- ~~~~~~~~~~~~~~~~~~~~~~
if require("theme.ui_vars").color_scheme == "light" then

        if output == "light" then
            return
        else
            readwrite.write("theme_state", "light")
            awful.spawn.easy_async_with_shell([[

            # gtk theme / icon theme
            sed -i '2s/.*/gtk-theme-name=Cutefish-light/g' ~/.config/gtk-3.0/settings.ini
            sed -i '3s/.*/gtk-icon-theme-name=Crule/g' ~/.config/gtk-3.0/settings.ini

            # alacritty color
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-light.yml/g' ~/.config/alacritty/alacritty.yml
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-light.yml/g' ~/.config/alacritty/ncmpcpp.yml


            # rofi color
            sed -i '17s/.*/    background:                     #FFF4FEBF;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '19s/.*/    background-bar:                 #10101215;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '20s/.*/    foreground:                     #101012EE;/g' ~/.config/awesome/misc/rofi/theme.rasi

            # zsh-prompt
            sed -i '4s/.*/ZSH_THEME="m3-round-light"/g' ~/.zshrc

            # Zathura
            local ZATHURA_PATH="$HOME/.config/zathura"
            mv ${ZATHURA_PATH}/zathurarc ${ZATHURA_PATH}/.zathura-dark
            mv ${ZATHURA_PATH}/.zathura-light ${ZATHURA_PATH}/zathurarc

            ]], function ()
                require("layout.ding.extra.short")("", "Dark mode disabled")
            end)
        end
else

        if output == "dark" then
            return
        else
            readwrite.write("theme_state", "dark")
            awful.spawn.easy_async_with_shell([[

            # gtk theme / icon theme
            sed -i '2s/.*/gtk-theme-name=Awesthetic-dark/g' ~/.config/gtk-3.0/settings.ini
            sed -i '3s/.*/gtk-icon-theme-name=Crule-dark/g' ~/.config/gtk-3.0/settings.ini

            # alacritty color
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-material.yml/g' ~/.config/alacritty/alacritty.yml
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-material.yml/g' ~/.config/alacritty/ncmpcpp.yml
            
            # rofi color
            sed -i '17s/.*/    background:                     #101012BF;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '19s/.*/    background-bar:                 #f2f2f215;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '20s/.*/    foreground:                     #f2f2f2EE;/g' ~/.config/awesome/misc/rofi/theme.rasi

            # zsh-prompt
            sed -i '4s/.*/ZSH_THEME="m3-round"/g' ~/.zshrc

            # Zathura
            local ZATHURA_PATH="$HOME/.config/zathura"
            mv ${ZATHURA_PATH}/zathurarc ${ZATHURA_PATH}/.zathura-light
            mv ${ZATHURA_PATH}/.zathura-dark ${ZATHURA_PATH}/zathurarc

            ]], function ()
                require("layout.ding.extra.short")("", "Dark mode enabled")
            end)
        end
end
