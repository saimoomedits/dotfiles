-- wallpaper
-- to change a wallpaper replace the *wall.jpg* or *wall-light.jpg* for light theme

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)