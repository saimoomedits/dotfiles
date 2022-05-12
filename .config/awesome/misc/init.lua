-- misc stuff
-- ~~~~~~~~~~
-- includes startup apps, theme changing and more

-- requirements
-- ~~~~~~~~~~~~
local awful = require "awful"
local beautiful = require "beautiful"
local gfs = require "gears".filesystem.get_configuration_dir()


-- autostart
-- ~~~~~~~~~

-- startup apps runner
local function run(command, pidof)
    -- emended from manilarome
    local findme = command
    local firstspace = command:find(' ')
    if firstspace then
        findme = command:sub(0, firstspace - 1)
    end

    awful.spawn.easy_async_with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', pidof or findme, command))
end


local applications = {
    "picom --config $HOME/.config/awesome/misc/picom/panthom.conf &",
}

for _, prc in ipairs(applications) do
    run(prc)
end

-- only-one-time process (mpdris2)
awful.spawn.easy_async_with_shell("pidof python3", function (stdout)
    if not stdout or stdout == "" then
        awful.spawn.easy_async_with_shell("mpDris2")
    end
end)





-- apply light/dark theme
-- ~~~~~~~~~~~~~~~~~~~~~~
if beautiful.ext_light_fg then
    awful.spawn.easy_async_with_shell("sed -n 3p $HOME/.config/alacritty/alacritty.yml | awk '{ print $2 }'", function (stdout)

        if string.gsub(stdout, '^%s*(.-)%s*$', '%1') == "~/.config/alacritty/colors-light.yml" then
            return
        else
            awful.spawn.easy_async_with_shell([[

            # gtk theme
            sed -i '2s/.*/gtk-theme-name=Materia-Light/g' ~/.config/gtk-3.0/settings.ini

            # alacritty color
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-light.yml/g' ~/.config/alacritty/alacritty.yml
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-light.yml/g' ~/.config/alacritty/ncmpcpp.yml


            # rofi color
            sed -i '17s/.*/    background:                     #FFF4FEff;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '19s/.*/    background-bar:                 #10101215;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '20s/.*/    foreground:                     #101012EE;/g' ~/.config/awesome/misc/rofi/theme.rasi

            # zsh-prompt
            sed -i '4s/.*/ZSH_THEME="m3-round-light"/g' ~/.zshrc

            ]], function ()
                require("naughty").notify({
                    app_name = "Set Theme",
                    title = "Theme",
                    message = "Succesfully applied <b><u>Light theme</u></b>",
                    icon = beautiful.images.extra.theme_icon
                })
            end)
        end
        end)
else
    awful.spawn.easy_async_with_shell("sed -n 3p $HOME/.config/alacritty/alacritty.yml | awk '{ print $2 }'", function (stdout)

        if string.gsub(stdout, '^%s*(.-)%s*$', '%1') == "~/.config/alacritty/colors-material.yml" then
            return
        else
            awful.spawn.easy_async_with_shell([[
            # gtk theme
            sed -i '2s/.*/gtk-theme-name=Materia-dark/g' ~/.config/gtk-3.0/settings.ini

            # alacritty color
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-material.yml/g' ~/.config/alacritty/alacritty.yml
            sed -i '3s/.*/- ~\/.config\/alacritty\/colors-material.yml/g' ~/.config/alacritty/ncmpcpp.yml
            
            # rofi color
            sed -i '17s/.*/    background:                     #101012ff;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '19s/.*/    background-bar:                 #f2f2f215;/g' ~/.config/awesome/misc/rofi/theme.rasi
            sed -i '20s/.*/    foreground:                     #f2f2f2EE;/g' ~/.config/awesome/misc/rofi/theme.rasi

            # zsh-prompt
            sed -i '4s/.*/ZSH_THEME="m3-round"/g' ~/.zshrc

            ]], function ()
                require("naughty").notify({
                    app_name = "Set Theme",
                    title = "Theme",
                    message = "Succesfully applied <b><u>Dark theme</u></b>",
                    icon = beautiful.images.extra.theme_icon
                })
            end)
        end
    end)
end




-- launchers
-- ~~~~~~~~~

return {
    rofiCommand = "rofi -show drun -theme " .. gfs .. "/misc/rofi/theme.rasi",
    musicMenu   = function() require("misc.scripts.Rofi.music-pop").execute() end
}

