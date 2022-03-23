-- Time widget
-- shows time and day

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("helpers")


-- time
local time_hour = wibox.widget{
    font = "Roboto Regular 50",
    format = "<span foreground=\"" .. beautiful.fg_color .. "\">" .. "%I</span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

local time_min = wibox.widget{
    font = "Roboto Light 50",
    format = "<span foreground=\"" .. beautiful.fg_color .. "90" .. "\">" .. "%M</span>",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

local time_deco = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>Time</span>",
    font = beautiful.font_var .. "11",
    align = "left",
    valign = "top"
}


local date_day_name = wibox.widget{
    font = beautiful.font_var .. "18",
    color = beautiful.fg_color .. "20" ,
    format = "<span foreground=\"" .. beautiful.fg_color .. "80" .. "\">" .. "%A, %B</span>",
    align = "left",
    valign = "left",
    widget = wibox.widget.textclock
}

local sky_img = wibox.widget {
    widget = wibox.widget.imagebox,
    image = os.getenv("HOME") .. "/.config/awesome/images/day_icons/day.png",
    forced_width = 24,
    forced_height = 24,
}

-- dynamic icon?
local store_time = os.date("%H")
if tonumber(store_time) < 12 then
    sky_img.image = os.getenv("HOME") .. "/.config/awesome/images/day_icons/night.png"
else
    sky_img.image = os.getenv("HOME") .. "/.config/awesome/images/day_icons/day.png"
end

-- initial
local time = wibox.widget {
    {
        {
            {
                time_deco,
                {
                   time_hour,
                   time_min,
                   spacing = dpi(20),
                   widget = wibox.layout.fixed.horizontal
                },
                widget = wibox.layout.fixed.vertical,
                spacing = dpi(5)
            },
            margins = {top = 15, bottom = 15, left = 15, right = 20},
            widget = wibox.container.margin
        },
        widget = wibox.container.background,
        shape = helpers.rrect(7),
        bg = beautiful.bg_alt_dark
    },
    margins = {top = 20, left = 20, right = 15},
    widget = wibox.container.margin
}

return time