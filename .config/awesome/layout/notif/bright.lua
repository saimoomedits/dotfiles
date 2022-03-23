-- brightness indicator
-- brightness 

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- popup transforms
local width = dpi(350)
local height = dpi(350)


-- icon
local bright_icon = wibox.widget {
    markup = "<span foreground='" .. beautiful.yellow_color .. "'></span>",
    align = 'center',
    valign = 'center',
    font = 'Material Icons 18',
    widget = wibox.widget.textbox
}

-- the thing
local bright_notif = awful.popup({
    type = "notification",
    maximum_width = width,
    maximum_height = height,
    shape = gears.shape.rectangle,
    visible = false,
    ontop = true,
    widget = wibox.container.background,
    bg = "#00000000",
    placement = function(c)
        awful.placement
            .bottom_right(c, {margins = {right = 10, bottom = 10}})
    end
})

-- bar
local bright_bar = wibox.widget {
    {
      {
        bright_icon,
        shape = gears.shape.circle,
        widget = wibox.container.background
      },
    margins = 12,
    widget = wibox.container.margin
    },
    max_value = 100,
    min_value = 0,
    value = 0.75,
    thickness = 6,
    start_angle = 1.4,
    forced_height = 66,
    forced_width = 66,
    rounded_edge = true,
    bg = beautiful.fg_color .. "15",
    colors = {beautiful.yellow_color},
    paddings = 0,
    widget = wibox.container.arcchart
}


local bright_txt = wibox.widget {
                widget = wibox.widget.textbox,
                markup = "100%",
                font = beautiful.font_var .. " 17",
                align = "left",
                valign = "center"
}


-- setup
local bright_setup = wibox.widget {
    {
        {
            helpers.vertical_pad(2),
            {
                widget = wibox.widget.textbox,
                markup = "<span foreground=\"" .. beautiful.fg_color .. "80" .. "\">Brightness</span>",
                font = beautiful.font_var .. " 10",
                align = "left",
                valign = "center",
            },
            bright_txt,
            layout = wibox.layout.fixed.vertical,
            forced_width = dpi(100),
            spacing = 3
        },
        widget = wibox.container.margin,
        margins = 15.
    },
    {
        {
            bright_bar,
            widget = wibox.container.margin,
            margins = 10,
        },
        bg = beautiful.bg_alt_dark,
        widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal,
}

bright_notif.widget = wibox.widget {
    bright_setup,
    shape = helpers.rrect(6),
    bg = beautiful.bg_color,
    widget = wibox.container.background
}

-- timer
local hide_bright_adjust = gears.timer {
    timeout = 3,
    autostart = true,
    callback = function() bright_notif.visible = false end
}

local first_time = true
awesome.connect_signal("signal::brightness", function(value)
    bright_bar.value = value
    bright_txt.markup = value .. "%"

    if first_time then
        first_time = false
    elseif dash.visible then
        bright_notif.visible = false
    elseif bright_notif.visible then
        hide_bright_adjust:again()
    else
        bright_notif.visible = true
        hide_bright_adjust:start()
    end
end)