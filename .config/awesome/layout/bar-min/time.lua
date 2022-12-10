-- time
--------
-- Copyleft © 2022 Saimoomedits

-- requirments
---------------
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("helpers")



-- widgets
----------

-- hour text
local time_hour = wibox.widget{
    font = beautiful.font_var .. "Bold 13",
    format = helpers.colorize_text("%I : ", beautiful.fg_color),
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

-- minute text
local time_min = wibox.widget{
    font = beautiful.font_var .. "Bold 13",
    format = helpers.colorize_text("%M", beautiful.fg_color),
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

-- month text
local time_mon = wibox.widget{
    font = beautiful.font_var .. "11",
    format = helpers.colorize_text("%B", beautiful.fg_color .. "99"),
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

-- day text
local time_day = wibox.widget{
    font = beautiful.font_var .. "11",
    format = helpers.colorize_text("%A, ", beautiful.fg_color .. "99"),
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

-- indicator for dashbaord
local indicator = wibox.widget{
    widget = wibox.container.background,
    bg = beautiful.fg_color .. "4D",
    forced_height = dpi(2),
    visible = false
}

-- mainbox
local widget_box = wibox.widget{
    {
        {
            nil, nil, indicator,
            layout = wibox.layout.align.vertical
        },
        {
            {
                {
                    time_hour,
                    time_min,
                    spacing = dpi(0),
                    layout = wibox.layout.fixed.horizontal,
                },
                {
                    time_day,
                    time_mon,
                    spacing = dpi(0),
                    layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(25)
            },
            margins = {left = dpi(12), right = dpi(12)},
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
    widget = wibox.container.background,
    shape = helpers.rrect(beautiful.rounded - 2),
    bg = beautiful.bg_3 .. "cc"
}


-- effects
----------

-- hover 
widget_box:connect_signal("mouse::enter", function ()
    widget_box.bg = beautiful.fg_color .. "26"
end)
widget_box:connect_signal("mouse::leave", function ()
    widget_box.bg = beautiful.bg_3
end)

-- press
widget_box:connect_signal(
    "button::press",
    function()
        widget_box.opacity = 0.6
        dd_toggle()
    end)
widget_box:connect_signal(
    "button::release",
    function()
        widget_box.opacity = 1
    end)



-- update ind status
--------------------
awesome.connect_signal("dashboard::visible", function(val) 
    if val then 
        indicator.visible = true
    else
        indicator.visible = false
    end
end)


-- finalize
-----------
return widget_box

-- eof
------