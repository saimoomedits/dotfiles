-- system panel widget
-- for the control center

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

-- icon sizes
local the_size = "16"

-- the icons
local wifi_icon = wibox.widget{
    markup = "",
            font = "Feather " .. the_size,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center"
}

local vol_icon = wibox.widget {
            markup = "",
            font = "Feather " .. the_size,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center"
}

local blue_icon = wibox.widget {
            markup = "",
            font = "JetBrainsMono Nerd Font " .. the_size,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center"
}

local mpd_icon = wibox.widget {
            markup = "",
            font = "Feather " .. the_size,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center"
}



-- initial setup
local wifi = wibox.widget {
    {
        wifi_icon,
        margins = {top = 5, right = 15, bottom = 5, left = 15},
        widget = wibox.container.margin
    },
    bg = beautiful.bg_light,
    shape = helpers.rrect(8),
    widget = wibox.container.background
}

local bluez = wibox.widget {
    {
        blue_icon,
        margins = {top = 5, right = 18, bottom = 5, left = 18},
        widget = wibox.container.margin
    },
    bg = beautiful.bg_light,
    shape = helpers.rrect(8),
    widget = wibox.container.background
}

local music = wibox.widget {
    {
        mpd_icon,
        margins = {top = 5, right = 15, bottom = 5, left = 15},
        widget = wibox.container.margin
    },
    bg = beautiful.bg_light,
    shape = helpers.rrect(8),
    widget = wibox.container.background
}

local volume = wibox.widget {
    {
        vol_icon,
        margins = {top = 12, right = 15, bottom = 12, left = 15},
        widget = wibox.container.margin
    },
    bg = beautiful.bg_light,
    shape = helpers.rrect(8),
    widget = wibox.container.background
}


-- signals
awesome.connect_signal("signal::wifi", function(net_status) 
    if net_status then
        wifi_icon.markup = "<span foreground=\"" .. beautiful.bg_color .. "\"></span>"
        wifi.bg = beautiful.fg_color
    else
        wifi_icon.markup = "<span foreground=\"" .. beautiful.fg_color .. "\"></span>"
        wifi.bg = beautiful.bg_light
    end
end)

awesome.connect_signal("signal::mpd_server", function(mpd_server_status) 
    if mpd_server_status then
        mpd_icon.markup = "<span foreground=\"" .. beautiful.bg_color .. "\"></span>"
        music.bg = beautiful.yellow_color
        music:buttons(gears.table.join(
          awful.button({ }, 1, function ()
          awful.spawn.with_shell("killall mpd")
             end)
               ))
    else
        mpd_icon.markup = "<span foreground=\"" .. beautiful.fg_color .. "\"></span>"
        music.bg = beautiful.bg_light
        music:buttons(gears.table.join(
          awful.button({ }, 1, function ()
          awful.spawn.with_shell("mpd")
             end)
               ))
    end
end)


awesome.connect_signal("signal::volume", function(vol, muted)
    if muted or vol == 0 then
        vol_icon.markup = "<span foreground=\"" .. beautiful.fg_color .. "\"></span>"
        volume.bg = beautiful.bg_light
    else
        vol_icon.markup = "<span foreground=\"" .. beautiful.bg_color .. "\"></span>"
        volume.bg = beautiful.yellow_color
    end

        volume:buttons(gears.table.join(
          awful.button({ }, 1, function ()
          awful.spawn.with_shell("amixer -D pulse set Master toggle")
             end)
               ))
end)




-- initial
local return_the_thing = wibox.widget {
    nil,
    {
        wifi,
        music,
        bluez,
        volume,
        spacing = 15,
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.fixed.horizontal
}

return return_the_thing