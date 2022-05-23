-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local helpers       = require("helpers")
local dpi           = beautiful.xresources.apply_dpi


-- widgets
-- ~~~~~~~

-- battery widget
--------------------

-- battery icon
local bat_icon = wibox.widget{
    markup = helpers.colorize_text("", beautiful.green_color),
    font = beautiful.icon_var .. "11",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

-- battery progressbar
local battery_progress = wibox.widget{
	color				= beautiful.green_color,
	background_color	= "#00000000",
    forced_width        = dpi(30),
    border_width        = dpi(1),
    border_color        = beautiful.fg_color .. "A6",
    paddings             = dpi(2),
    bar_shape           = helpers.rrect(dpi(2)),
	shape				= helpers.rrect(dpi(5)),
    value               = 70,
	max_value 			= 100,
    widget              = wibox.widget.progressbar,
}

-- battery half circle thing
local battery_border_thing = wibox.widget{
    {
        wibox.widget.textbox,
        widget = wibox.container.background,
        bg = beautiful.fg_color .. "A6",
        forced_width = dpi(8.2),
        forced_height = dpi(8.2),
        shape = function(cr, width, height)
            gears.shape.pie(cr,width, height, 0, math.pi)
        end
    },
    direction = "east",
    widget = wibox.container.rotate()
}

-- percentage
local bat_txt = wibox.widget{
    widget = wibox.widget.textbox,
    markup = "100%",
    font = beautiful.font_var .. "Medium 11",
    valign = "center",
    align = "center"
}

-- init battery
local battery = wibox.widget{
    {
        {
            bat_icon,
            {
                battery_progress,
                battery_border_thing,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(-1.6)
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(1)
        },
        widget = wibox.container.margin,
        margins = {top = dpi(11),bottom = dpi(11)}
    },
    bat_txt,
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(12)
}


awesome.connect_signal("signal::battery", function(value, state)
    battery_progress.value = value
    bat_txt.markup = value .. "%"

    if state == 1 then
        bat_icon.visible = true
    else
        bat_icon.visible = false
    end
end)

---------------------------------------------------------- EOF Battery



-- clock
local clock = wibox.widget{
    widget = wibox.widget.textclock,
    format = "%a, %d %b",
    font = beautiful.font_var .. "Medium 13",
    valign = "center",
    align = "center"
}


-- extra control icon
local extras = wibox.widget{
    widget = wibox.widget.textbox,
    markup = "",
    font = beautiful.icon_var .. "Bold 16",
    valign = "center",
    align = "center"
}


local extra_shown = false


awesome.connect_signal("controlCenter::extras", function (update)
    extra_shown = update
    if update then extras.markup = "" end
end)


extras:buttons{gears.table.join(
    awful.button({ }, 1, function ()
        if extra_shown then
            show_extra_control_stuff()
            extra_shown = false
            extras.markup = ""
        else
            extras.markup = ""
            extra_shown = true
            show_extra_control_stuff(true)
        end
    end)
)}

return wibox.widget{
    {
        {
            clock,
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(15)
        },
        extras,
        battery,
        layout = wibox.layout.align.horizontal
    },
    layout = wibox.layout.fixed.vertical,
    forced_height = dpi(40)
}