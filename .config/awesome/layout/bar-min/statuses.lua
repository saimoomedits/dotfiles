-- minimal status indicators
----------------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi



-- widgets
----------

-- wifi icon
local wifi = wibox.widget{
    font = beautiful.icon_var .. "12",
    markup = helpers.colorize_text("", beautiful.fg_color),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "center"
}

-- volume icon
local volume = wibox.widget{
    font = beautiful.icon_var .. "12",
    markup = helpers.colorize_text("", beautiful.fg_color),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "center"
}

-- battery indicator
local battery = wibox.widget{
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 50,
    thickness = dpi(3),
    rounded_edge = true,
    bg = beautiful.green_color .. "4D",
    colors = { beautiful.green_color},
    start_angle = math.pi + math.pi / 2,
    forced_width = dpi(17),
    forced_height = dpi(17)
}





-- indicator for cc. (control center)
local indicator = wibox.widget{
    widget = wibox.container.background,
    bg = beautiful.fg_color .. "4D",
    forced_height = dpi(2),
    visible = false
}

-- make it more cool!
local kaka = require("helpers.widgets.create_button")(
    {
        {
            nil, nil, indicator,
            layout = wibox.layout.align.vertical
        },
        {
            {
                volume,
                battery,
                wifi,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(15)
            },
            margins = {left = dpi(12), right = dpi(12)},
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
  beautiful.bg_3,
  beautiful.fg_color .. "33",
  dpi(0),
  dpi(0),
  dpi(0),
  helpers.rrect(beautiful.rounded - 2)
)

-- the final wrapped box
local widget_box = wibox.widget{
    widget = kaka
}


-- update ind status
--------------------
awesome.connect_signal("control_center::visible", function(val) 
    if val then 
        indicator.visible = true
    else
        indicator.visible = false
    end
end)

-- toggle cc (control center) on press
widget_box:connect_signal(
    "button::press",
    function()
        cc_toggle()
end)




-- update widgets
-----------------

-- wifi
awesome.connect_signal("signal::wifi", function (value)
    if value then
        wifi.markup = helpers.colorize_text("", beautiful.fg_color)
    else 
        wifi.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
    end
end)

-- battery
awesome.connect_signal("signal::battery", function(value) 
    battery.value = value
end)


-- finalize
-----------
return widget_box

-- eof
------