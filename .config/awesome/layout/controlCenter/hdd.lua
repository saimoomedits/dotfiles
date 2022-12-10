-- hdd indicator
----------------
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

-- text - "important" stuff
local text = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Disk", beautiful.fg_color .. "4D"),
    font = beautiful.font_var .. "10",
    align = "center",
    valign = "center"
}

-- percentage text
local perc = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("50%", beautiful.fg_color),
    font = beautiful.font_var .. "11",
    align = "center",
    valign = "center"
}

-- progress"bar" - again, more like arc
local progressbar = wibox.widget{
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 50,
    thickness = dpi(4),
    rounded_edge = true,
    bg = beautiful.red_color .. "26",
    colors = { beautiful.red_color},
    start_angle = math.pi + math.pi / 2,
    forced_width = dpi(30),
    forced_height = dpi(30)
}

awful.widget.watch([[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]], 180, function(_, stdout)
    local val = stdout:match("(%d+)")
    perc.markup = helpers.colorize_text(val.."%", beautiful.fg_color .. "99")
    progressbar.value = tonumber(val)
    collectgarbage("collect")
end)

-- finalize
-----------
return wibox.widget{
    {
        {
            {
                text,
                perc,
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(3)
            },
            nil,
            progressbar,
            layout = wibox.layout.align.horizontal,
            expand = "none"
        },
        widget = wibox.container.margin,
        margins = dpi(12)
    },
    widget = wibox.container.background,
    bg = beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded),
    forced_width = dpi(160),

}


-- eof
------