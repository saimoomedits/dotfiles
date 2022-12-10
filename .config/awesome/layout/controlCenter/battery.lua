-- sussy battery indicator
--------------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")


-- widgets
----------

-- percentage text
local battery_perc = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("90%", beautiful.fg_color .. "99"),
    font = beautiful.font_var .. "12",
    align = "left",
    valign = "bottom"
}

-- progress"bar" - more like arc
local progressbar = wibox.widget{
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 50,
    thickness = dpi(4),
    rounded_edge = true,
    bg = beautiful.green_color .. "26",
    colors = { beautiful.green_color},
    start_angle = math.pi + math.pi / 2,
    forced_width = dpi(32),
    forced_height = dpi(32)
}


-- update it
------------
awesome.connect_signal("signal::battery", function(value, state)
    progressbar.value = value
    battery_perc.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
end)


-- finalize
-----------
return wibox.widget{
    {
        {
            {
                {
                    widget = wibox.widget.textbox,
                    markup = helpers.colorize_text("Battery", beautiful.fg_color .. "4D"),
                    font = beautiful.font_var .. "11",
                    align = "left",
                    valign = "bottom"
                },
                nil,
                {
                    battery_perc,
                    spacing = dpi(2),
                    layout = wibox.layout.fixed.vertical
                },
                layout = wibox.layout.align.vertical,
                expand = "none"
            },
            nil,
            progressbar,
            layout = wibox.layout.align.horizontal,
            expand = "none"
        },
        margins = dpi(14),
        widget = wibox.container.margin
    },
    widget = wibox.container.background,
    bg = beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(70),
    forced_width = dpi(160),
}


-- eof
------