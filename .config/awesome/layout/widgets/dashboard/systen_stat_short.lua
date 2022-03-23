-- system_status widget
-- but simplified

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")

-- bar shape
local bar_shape_num = helpers.rrect(6)

-- bar sizes
local bar_height = 90
local bar_width = 5


-- BARS --
local bright = wibox.widget{
        color = beautiful.yellow_color,
        bar_shape = bar_shape_num,
        background_color = beautiful.bg_alt_dark,
        shape = bar_shape_num,
        value = 20,
        max_value = 100,
        widget = wibox.widget.progressbar,
}


local volume = wibox.widget{
        color = beautiful.blue_color,
        background_color = beautiful.bg_alt_dark,
        bar_shape = bar_shape_num,
        shape = bar_shape_num,
        value = 50,
        max_value = 100,
        widget = wibox.widget.progressbar,
}

local battery = wibox.widget{
        color = beautiful.green_color,
        background_color = beautiful.bg_alt_dark,
        shape = bar_shape_num,
        bar_shape = bar_shape_num,
        value = 90,
        max_value = 100,
        widget = wibox.widget.progressbar,
}

local ram = wibox.widget{
        color = beautiful.magenta_color,
        bar_shape = bar_shape_num,
        background_color = beautiful.bg_alt_dark,
        shape = bar_shape_num,
        value = 1503,
        max_value = 3796,
        widget = wibox.widget.progressbar,
}


local cpu = wibox.widget{
        color = beautiful.red_color,
        bar_shape = bar_shape_num,
        background_color = beautiful.bg_alt_dark,
        shape = bar_shape_num,
        value = 30,
        max_value = 100,
        widget = wibox.widget.progressbar,
}




-- signals
awesome.connect_signal("signal::brightness", function (value)
    bright.value = value
end)


awesome.connect_signal("signal::cpu", function (value)
    cpu.value = value
end)

awesome.connect_signal("signal::volume", function (value)
    volume.value = value
end)


awesome.connect_signal("signal::ram", function (value)
    ram.value = value
end)


awesome.connect_signal("signal::battery", function (value)
    battery.value = value
end)

-- change volume / brightness
volume:buttons(gears.table.join(
    awful.button({}, 4, function() awful.spawn.with_shell("amixer -D pulse set Master 5%+") end),
    awful.button({}, 5, function() awful.spawn.with_shell("amixer -D pulse set Master 5%-") end)
))


bright:buttons(gears.table.join(
    awful.button({}, 4, function() awful.spawn.with_shell("brightnessctl set 5%+") end),
    awful.button({}, 5, function() awful.spawn.with_shell("brightnessctl set 5%-") end)
))




-- initial
local core = wibox.widget {
{
{
{
    {
         bright,
        forced_height = bar_height,
        forced_width  = bar_width,
        direction     = 'east',
        layout        = wibox.container.rotate,
        widget = wibox.container.background,
    },
    {
         battery,
        forced_height = bar_height,
        forced_width  = bar_width,
        direction     = 'east',
        layout        = wibox.container.rotate,
        widget = wibox.container.background,
    },
    {
         ram,
        forced_height = bar_height,
        forced_width  = bar_width,
        direction     = 'east',
        layout        = wibox.container.rotate,
        widget = wibox.container.background,
    },
    {
         cpu,
        forced_height = bar_height,
        forced_width  = bar_width,
        direction     = 'east',
        layout        = wibox.container.rotate,
        widget = wibox.container.background,
    },
    widget = wibox.container.background,
    valign = "center",
    halign = "center",
    foced_height = dpi(200),
    spacing = 11,
    layout = wibox.layout.fixed.horizontal
    },
    top = dpi(18),
    bottom = dpi(10),
    right = dpi(10),
    left = dpi(16),
    widget = wibox.container.margin,
    valign = "center",
    halign = "center",
},
    bg = beautiful.bg_alt_dark,
    shape = helpers.rrect(5),
    widget = wibox.container.background
    },
    widget = wibox.container.margin,
    margins = {left = 4, right = 20, top = 15, bottom = 5}

}


return core