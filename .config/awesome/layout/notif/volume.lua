-- volume indicator
-- volume

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- notif transforms
local width = dpi(350)
local height = dpi(350)


-- volumme icon
local volume_icon = wibox.widget {
    align = 'center',
    valign = 'center',
    font = "Iosevka Nerd Font 22",
    widget = wibox.widget.textbox
}

-- the thing
local volume_notif = awful.popup({
    type = "notification",
    maximum_width = width,
    maximum_height = height,
    visible = false,
    ontop = true,
    widget = wibox.container.background,
    bg = "#00000000",
    placement = function(c)
        awful.placement
            .bottom_right(c, {margins = {right = 10, bottom = 10}})
    end
})

local volume_txt = wibox.widget {
                widget = wibox.widget.textbox,
                markup = "100%",
                font = beautiful.font_var .. " 17",
                align = "left",
                valign = "center"
}


local volume_bar = wibox.widget {
    {
      {
        volume_icon,
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
    colors = {beautiful.blue_color},
    paddings = 0,
    widget = wibox.container.arcchart
}

local volume_setup = wibox.widget {
    {
        {
            helpers.vertical_pad(2),
            {
                widget = wibox.widget.textbox,
                markup = "<span foreground=\"" .. beautiful.fg_color .. "80" .. "\">Volume</span>",
                font = beautiful.font_var .. " 10",
                align = "left",
                valign = "center",
            },
            volume_txt,
            layout = wibox.layout.fixed.vertical,
            forced_width = dpi(100),
            spacing = 3
        },
        widget = wibox.container.margin,
        margins = 15.
    },
    {
        {
            volume_bar,
            widget = wibox.container.margin,
            margins = 10,
        },
        bg = beautiful.bg_alt_dark,
        widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal,
}



volume_notif.widget = wibox.widget {
    volume_setup,
    shape = helpers.rrect(6),
    bg = beautiful.bg_color,
    widget = wibox.container.background
}

-- timer
local hide_volume_adjust = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        volume_notif.visible = false
        volume_bar.mouse_enter = false
    end
}

local first_time = true

awesome.connect_signal("signal::volume", function(vol, muted)
    volume_bar.value = vol
    volume_txt.markup = vol .. "%"


    if muted or vol == 0 then
        volume_icon.markup = "<span foreground='" .. beautiful.red_color ..
                                 "'><b>婢</b></span>"
    else
        volume_icon.markup = "<span foreground='" .. beautiful.blue_color ..
                                 "'><b>墳</b></span>"
    end

    if first_time then 
        first_time = false
    elseif dash.visible then
        volume_notif.visible = false
    elseif volume_notif.visible then
        hide_volume_adjust:again()
    else
        volume_notif.visible = true
        hide_volume_adjust:start()
    end

end)