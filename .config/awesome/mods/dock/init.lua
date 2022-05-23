-- A dock for the Awesome Window Manager
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- source: https://github.com/saimoomedits/dotfiles


local dock = require(... .. ".dock" )
local icon_handler = require(... .. ".icon_handler")
local beautiful = require("beautiful")
local awful = require("awful")

-- usage:
-- {"command to launch", "icon name" }
-- you  can leave an empty array for no pinned apps
local pinned_defaults = {
    {"xterm"},
    {"firefox"},
}


-- dock properties
-- ~~~~~~~~~~~~~~~
local dock_size = beautiful.awesome_dock_size or 80
local offset = beautiful.awesome_dock_offset or beautiful.useless_gap or 0
local pinned_apps = beautiful.awesome_dock_pinned or pinned_defaults
local active_color = beautiful.awesome_dock_color_active or beautiful.fg_focus or "#ffffff"
local inactive_color = beautiful.awesome_dock_color_inactive or beautiful.fg_normal or "#ffffff99"
local minimized_color = beautiful.awesome_dock_color_minimized or beautiful.fg_minimize or "#ffffff33"
local background_color = beautiful.awesome_dock_color_bg or beautiful.bg_normal or "#000000"
local modules_spacing = beautiful.awesome_dock_spacing or 12
local hover_color = beautiful.awesome_dock_color_hover or "#f9f9f9"
local timeout = beautiful.awesome_dock_timeout or 1


if beautiful.awesome_dock_disabled == true then
    return
else

    awful.screen.connect_for_each_screen(function(s)
        for s in screen do
            -- require("naughty").notify({title = tostring(s.index)})
            dock(s, pinned_apps, dock_size, offset, modules_spacing, active_color, inactive_color, minimized_color, background_color, hover_color, icon_handler, timeout)
        end

    end)
end
