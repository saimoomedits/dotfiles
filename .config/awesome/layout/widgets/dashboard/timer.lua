-- timer? not really. counter widgets
--- displays how long the day will last


local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

-- text 
local txt = wibox.widget {
    widget = wibox.widget.textclock,
    format = "<b>%H</b><span foreground='" .. beautiful.fg_color .. "99" .. "'>/24</span>",
    font = beautiful.font_var .. "14",
    valign = "center",
    align = "center"
}

-- progress
local cal = wibox.widget {
    txt,
    padding = 2,
    thickness = 7,
    colors = {beautiful.blue_color},
    bg = beautiful.bg_color,
    rounded_edge = true,
    start_angle = math.pi / -2,
    value = os.date("%H"),
    max_value = 24,
    forced_width = 100,
    forced_height = 100,
    widget = wibox.container.arcchart
}

-- initial
local thing = wibox.widget {
    {
        {
            {
                    cal,
                layout = wibox.layout.fixed.vertical,
                spacing = 10
            },
            widget = wibox.container.margin,
            margins = 15
        },
        widget  = wibox.container.background,
        shape = helpers.rrect(6),
        bg = beautiful.bg_alt_dark,
    },
    widget = wibox.container.margin,
    margins = {top = 20, right = 20}
}

return thing
