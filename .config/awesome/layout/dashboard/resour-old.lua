--[[

    DEPRECATED - old-styled resources widget
    not in use anymore, but its still here because... well idk

    Copyleft © 2022 Saimoomedits

]]


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")


local perc_ram = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("90%", "#86AAEC" .. "80"),
    font = beautiful.font_var .. "11",
    align = "center",
    valign = "center"
}

local perc_cpu = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("90%", beautiful.red_color .. "80"),
    font = beautiful.font_var .. "12",
    align = "center",
    valign = "center"
}

local stats_ram = wibox.widget{
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 50,
    thickness = dpi(4),
    rounded_edge = true,
    bg = beautiful.bg_3,
    colors = { "#86AAEC" .. "66" },
    start_angle = math.pi + math.pi / 2,
    forced_width = dpi(30),
    forced_height = dpi(30)
}

local stats_cpu = wibox.widget{
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = 50,
    thickness = dpi(4),
    rounded_edge = true,
    bg = beautiful.bg_3,
    colors = { beautiful.red_color .. "66"},
    start_angle = math.pi + math.pi / 2,
    forced_width = dpi(30),
    forced_height = dpi(30)
}



-- update widgets
-----------------
awesome.connect_signal("signal::ram", function (value, total)
    perc_ram.markup = helpers.colorize_text(value.."mb", "#86AAEC")
    stats_ram.value = value
    stats_ram.max_value = total
end)

awesome.connect_signal("signal::cpu", function (value)
    stats_cpu.value = value
    perc_cpu.markup = helpers.colorize_text(value.."%", beautiful.red_color)
end)





-- update it
------------
return wibox.widget{
    {
        {
            {
                widget = wibox.widget.textbox,
                markup = helpers.colorize_text("Stats", beautiful.fg_color .. "33"),
                font = beautiful.font_var .. "11",
                align = "left",
                valign = "center"
            },
            margins = {top = dpi(10), left = dpi(14)},
            widget = wibox.container.margin,
        },
        {
            {
                {
                    {
                        {
                            widget = wibox.widget.textbox,
                            markup = helpers.colorize_text("Cpu", beautiful.fg_color .. "4D"),
                            font = beautiful.font_var .. "10",
                            align = "left",
                            valign = "center"
                        },
                        perc_cpu,
                        layout = wibox.layout.fixed.vertical,
                        spacing = dpi(1)
                    },
                    nil,
                    {
                        nil,
                        nil,
                        stats_cpu,
                        layout = wibox.layout.align.vertical,
                        expand = "none"
                    },
                    layout = wibox.layout.align.horizontal,
                    expand = "none"
                },
                {
                    {
                        {
                            widget = wibox.widget.textbox,
                            markup = helpers.colorize_text("Ram", beautiful.fg_color .. "4D"),
                            font = beautiful.font_var .. "10",
                            align = "left",
                            valign = "center"
                        },
                        perc_ram,
                        layout = wibox.layout.fixed.vertical,
                        spacing = dpi(1)
                    },
                    nil,
                    {
                        nil,
                        nil,
                        stats_ram,
                        layout = wibox.layout.align.vertical,
                        expand = "none"
                    },
                    layout = wibox.layout.align.horizontal,
                    expand = "none"
                },
                spacing = dpi(16),
                layout = wibox.layout.fixed.vertical,
            },
            margins = dpi(14),
            widget = wibox.container.margin
        },
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.background,
    bg = beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(160),
    forced_width = dpi(160),
}