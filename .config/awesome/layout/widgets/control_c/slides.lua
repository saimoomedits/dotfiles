-- A slider widget for volume / brightness
-- Technically its not a slider, but pretty much the same


local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local bar_shape_num = helpers.rrect(4)

-- BARS --
local bright = wibox.widget{
        color = beautiful.yellow_color,
        bar_shape = bar_shape_num,
        background_color = beautiful.bg_alt_dark,
        shape = gears.shape.rounded_bar,
        value = 20,
        max_value = 100,
        forced_width = 100,
        forced_height = 10,
        widget = wibox.widget.progressbar,
}


local volume = wibox.widget{
        color = beautiful.blue_color,
        forced_width = 100,
        forced_height = 10,
        background_color = beautiful.bg_alt_dark,
        bar_shape = bar_shape_num,
        shape = gears.shape.rounded_bar,
        value = 50,
        max_value = 100,
        widget = wibox.widget.progressbar,
}


-- signals
awesome.connect_signal("signal::brightness", function (value)
    bright.value = value
end)

awesome.connect_signal("signal::volume", function (value)
    volume.value = value
end)

-- make the things actually work
volume:buttons(gears.table.join(
    awful.button({}, 4, function() awful.spawn.with_shell("amixer -D pulse set Master 5%+") end),
    awful.button({}, 5, function() awful.spawn.with_shell("amixer -D pulse set Master 5%-") end)
))


bright:buttons(gears.table.join(
    awful.button({}, 4, function() awful.spawn.with_shell("brightnessctl set 5%+") end),
    awful.button({}, 5, function() awful.spawn.with_shell("brightnessctl set 5%-") end)
))


-- initial
local ugh_pain = wibox.widget {
        {
                volume,
                bright,
                spacing = 12,
                layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin,
        margins = {top = 10, bottom = 13, left = 5, right = 10},
}

return ugh_pain