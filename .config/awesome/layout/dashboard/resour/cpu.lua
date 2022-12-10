-- cpu haha
-----------
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

-- icon
local icon = wibox.widget({
    widget  = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.red_color),
    font = beautiful.icon_var .. "14",
    align = "left",
})

-- perc text
local text = wibox.widget({
    widget  = wibox.widget.textbox,
    markup = helpers.colorize_text("39%", beautiful.fg_color .. "99"),
    font = beautiful.font_var .. "13",
    align = "center",
})

-- progressbar
local prog = wibox.widget{
	max_value = 100,
	value = 30,
	background_color = beautiful.fg_color .. "26",
    bar_shape = gears.shape.rounded_bar,
    shape = gears.shape.rounded_bar,
	color = beautiful.red_color,
	forced_height = dpi(4),
	forced_width = dpi(105),
	widget = wibox.widget.progressbar,
}

awesome.connect_signal("signal::cpu", function (value)
    text.markup = helpers.colorize_text(value.."%", beautiful.fg_color .. "99")
    prog.value = value
end)

-- finalize
-----------
return wibox.widget {
    {
        {
            icon,
            margins = dpi(10),
            widget = wibox.container.margin
        },
        text,
        prog,
        layout = wibox.layout.align.vertical,
        expand = "none"
    },
    widget = wibox.container.background,
	forced_height = dpi(105),
    bg = beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded - 2)
}

-- eof
------