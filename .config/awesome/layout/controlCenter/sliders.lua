-- sliders for different controls
-- messy as hell. D:
---------------------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")






-- widgets
----------


-- brightness
-------------

-- progressbar (brightness)
local brightness = wibox.widget{
    widget = wibox.widget.slider,
    value = 50,
    maximum = 100,
    forced_width = dpi(260),
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    bar_color = beautiful.fg_color .. "33",
    bar_margins = {bottom = dpi(8) ,top = dpi(8)},
    bar_active_color = beautiful.fg_color,
    handle_width = dpi(12),
    handle_shape = gears.shape.circle,
    handle_color = beautiful.fg_color,
    handle_border_width = 3,
    handle_border_color = beautiful.bg_color
}

-- "brightness"
local brightness_text = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("100%", beautiful.fg_color),
    font = beautiful.font_var .. "10",
    align = "center",
    valign = "center",
    forced_width = dpi(30)
}

-- brightness icon (sun)
local brightness_icon = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "14",
    align = "center",
    valign = "center"
}


-- initialize brightness slider
local bright_init = wibox.widget{
        brightness_icon,
        {
	        brightness,
		    widget = wibox.container.rotate,
            forced_height = dpi(15),
            forced_width = dpi(210)
        },
        brightness_text,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(20),
}


-- update brightness slider 
----------------------------
function update_value_of_brightness() 
    awful.spawn.easy_async_with_shell("brightnessctl | grep -i  'current' | awk '{ print $4}' | tr -d \"(%)\"", function (stdout)
        local value = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
        brightness.value = tonumber(value)
        brightness_text.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
    end)
end

update_value_of_brightness()
brightness:connect_signal("property::value", function(_, new_value)
    brightness_text.markup = helpers.colorize_text(new_value .. "%", beautiful.fg_color)
    brightness.value = new_value
    awful.spawn("brightnessctl set " .. new_value .."%", false)
end)

local function create_wee_b(egg) 
    egg:buttons(
        gears.table.join(
            awful.button({}, 5, function() 
                awful.spawn("brightnessctl set 5%-", false) 
                brightness.value = brightness.value - 5
            end),
            awful.button({}, 4, function() 
                awful.spawn("brightnessctl set 5%+", false) 
                brightness.value = brightness.value + 5
            end)
        )
    )
end

create_wee_b(brightness_icon)





-- volume
---------

-- progressbar (volume)
local volume = wibox.widget{
    widget = wibox.widget.slider,
    value = 50,
    maximum = 100,
    forced_width = dpi(260),
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    bar_color = beautiful.fg_color .. "33",
    bar_margins = {bottom = dpi(8) ,top = dpi(8)},
    bar_active_color = beautiful.fg_color,
    handle_width = dpi(12),
    handle_shape = gears.shape.circle,
    handle_color = beautiful.fg_color,
    handle_border_width = 3,
    handle_border_color = beautiful.bg_color
}

-- volume icon (volume_speaker)
local volume_icon = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "14",
    align = "center",
    valign = "center"
}

-- "volume"
local volume_text = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("100%", beautiful.fg_color),
    font = beautiful.font_var .. "10",
    align = "center",
    valign = "center",
    forced_width = dpi(30)
}

-- initialize volume slider
local volume_init = wibox.widget{
        volume_icon,
        {
	        volume,
		    widget = wibox.container.rotate,
            forced_height = dpi(10),
            forced_width = dpi(210)
        },
        volume_text,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(20),
}



-- update volume slider
-----------------------

local vol_muted = false

local function update_widget_according_to_vol_muted(object) 
    if not vol_muted then
        volume.opacity = 1
        volume_icon.markup = helpers.colorize_text("", beautiful.fg_color)
    else
        volume_icon.markup = helpers.colorize_text("", beautiful.fg_color .. "66")
        volume.opacity = 0.6
    end
end

awesome.connect_signal("volume::muted", function(muted)
    vol_muted = muted
    update_widget_according_to_vol_muted()
end)

local function toggle_mute() 
        if not vol_muted then
            awful.spawn("amixer -D pulse set Master mute", false) 
            vol_muted = true
            update_widget_according_to_vol_muted(vol_muted)
        else
            awful.spawn("amixer -D pulse set Master unmute", false) 
            vol_muted = false
            update_widget_according_to_vol_muted(vol_muted)
        end
end


awesome.connect_signal("volume::value", function(value)
    volume.value = tonumber(value)
    volume_text.markup = value .. "%"
end)

awesome.connect_signal("volume::changed", function(value)
    volume.value = volume.value + value
    volume_text.markup = volume.value .. "%"
end)

volume:connect_signal("property::value", function(_, new_value)
    volume_text.markup = helpers.colorize_text(new_value .. "%", beautiful.fg_color)
    volume.value = new_value
    awful.spawn("amixer -D pulse set Master " .. new_value .."%", false)
end)

volume_icon:buttons(
    gears.table.join(
        awful.button({}, 1, function() toggle_mute() end
    )))


-- finalize
-----------
return wibox.widget{
    {
        {
            {
                {
                    widget = wibox.widget.textbox,
                    markup = helpers.colorize_text("Controls", beautiful.fg_color .. "4D"),
                    font = beautiful.font_var .. "10",
                    align = "left",
                    valign = "center"
                },
                margins = {left = dpi(15)},
                widget = wibox.container.margin
            },
            {
                {
                    bright_init,
                    volume_init,
                    spacing = dpi(24),
                    layout = wibox.layout.fixed.vertical,
                },
                margins = {right = dpi(25), left = dpi(25)},
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(12)
        },
        widget = wibox.container.margin,
        margins = {top = dpi(10), bottom = dpi(15)},
    },
    shape = helpers.rrect(beautiful.rounded),
    bg = beautiful.bg_2,
    widget = wibox.container.background,

}


-- eof
------