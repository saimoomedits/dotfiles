-- Search bar
-- surf the web with google

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")

-- initial
local bar = wibox.widget {
    {
        {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = os.getenv("HOME") .. "/.config/awesome/images/google.png",
                        forced_height = 24,
                        forced_width = 24,
                        halign = "left",
                        valign = "center"
                    },
                    {
                        widget = wibox.widget.textbox,
                        markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>Search</span>",
                        align = "left",
                        valign = "center",
                        font = beautiful.font_var .. "12"
                    },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 10
                },
                {
                    widget = wibox.widget.textclock,
                    format = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>- %A, %B</span>",
                    align = "right",
                    valign = "center",
                    font = beautiful.font_var .. "11"
                },
                spacing = 10,
                layout = wibox.layout.align.horizontal,
            },
            margins = {left = 10, right = 10},
            widget = wibox.container.margin
        },
        widget = wibox.container.background,
        shape = helpers.rrect(7),
        forced_height = 40,
        bg = beautiful.bg_alt_dark,
    },
    margins = {top = 20, left = 20, right = 15},
    widget = wibox.container.margin
}

bar:buttons(gears.table.join(
    awful.button({}, 1, function() 
        awful.spawn.with_shell("firefox") 
        dash_toggle()
    end)
))

return bar
