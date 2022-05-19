-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")






-- widgets
-- ~~~~~~~

-- progressbar
local brightness = wibox.widget{
    widget = wibox.widget.slider,
    value = 50,
    maximum = 100,
    forced_width = dpi(260),
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    bar_color = beautiful.fg_color .. "33",
    bar_margins = {bottom = dpi(18) ,top = dpi(18)},
    bar_active_color = beautiful.accent,
    handle_width = dpi(14),
    handle_shape = gears.shape.circle,
    handle_color = beautiful.accent,
    handle_border_width = 3,
    handle_border_color = beautiful.bg_3
}

local brightness_icon = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "17",
    align = "center",
    valign = "center"
}

local brightness_text = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("10%", beautiful.fg_color),
    font = beautiful.font_var .. "13",
    align = "center",
    valign = "center"
}

local bright_init = wibox.widget{
    brightness_icon,
    brightness,
    brightness_text,
    layout = wibox.layout.fixed.horizontal,
    forced_height = dpi(42),
    spacing = dpi(17)
}

awful.spawn.easy_async_with_shell("brightnessctl | grep -i  'current' | awk '{ print $4}' | tr -d \"(%)\"", function (stdout)
    local value = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
    brightness.value = tonumber(value)
    brightness_text.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
end)

brightness:connect_signal("property::value", function(_, new_value)
    brightness_text.markup = helpers.colorize_text(new_value .. "%", beautiful.fg_color)
    brightness.value = new_value
    awful.spawn("brightnessctl set " .. new_value .."%", false)
end)





-- volume
local volume = wibox.widget{
    widget = wibox.widget.slider,
    value = 50,
    maximum = 100,
    forced_width = dpi(260),
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    bar_color = beautiful.fg_color .. "33",
    bar_margins = {bottom = dpi(18) ,top = dpi(18)},
    bar_active_color = beautiful.accent,
    handle_width = dpi(14),
    handle_shape = gears.shape.circle,
    handle_color = beautiful.accent,
    handle_border_width = 3,
    handle_border_color = beautiful.bg_3
}

local volume_icon = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "17",
    align = "center",
    valign = "center"
}

local volume_text = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("10%", beautiful.fg_color),
    font = beautiful.font_var .. "13",
    align = "center",
    valign = "center"
}

local volume_init = wibox.widget{
    volume_icon,
    volume,
    volume_text,
    layout = wibox.layout.fixed.horizontal,
    forced_height = dpi(42),
    spacing = dpi(17)
}

awful.spawn.easy_async_with_shell("amixer -D pulse get Master | tail -n 1 | awk '{print $5}' | tr -d '[%]'", function (stdout)
    local value = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
    volume.value = tonumber(value)
    volume_text.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
end)

volume:connect_signal("property::value", function(_, new_value)
    volume_text.markup = helpers.colorize_text(new_value .. "%", beautiful.fg_color)
    volume.value = new_value
    awful.spawn("amixer -D pulse set Master " .. new_value .."%", false)
end)


return wibox.widget{
    {
        {
            bright_init,
            volume_init,
            spacing = dpi(12),
            layout = wibox.layout.fixed.vertical,
        },
        margins = {top = dpi(12), bottom = dpi(12), left = dpi(18), right = dpi(12)},
        widget = wibox.container.margin
    },
    widget = wibox.container.background,
    forced_height = dpi(120),
    bg = beautiful.bg_3 .. "99",
    border_color = beautiful.fg_color .. "33",
    shape = helpers.rrect(beautiful.rounded)

}