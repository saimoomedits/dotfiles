-- notification theme
-- by me the idiot


local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")

local menubar = require("menubar")

naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar.utils.lookup_icon(hints.app_icon) or
                     menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then n.icon = path end

end)

naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = ""
naughty.config.defaults.position = "bottom_right"

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.low = {
    font = beautiful.font_var .. "10",
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.critical = {
    font = beautiful.font_var .. "12",
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    timeout = 0
}


naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule {
        rule = {},
        properties = {screen = awful.screen.preferred, implicit_timeout = 6}
    }
end)

naughty.connect_signal("request::display", function(n)

    local def_icon = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/notifs/notification.png", beautiful.fg_color .. "99")

    if n.icon == nil then
        n.icon = def_icon
    end

    local action_widget = {
        {
            {
                {
                    id = "text_role",
                    align = "center",
                    valign = "center",
                    font = beautiful.font_var .. "10",
                    widget = wibox.widget.textbox
                },
                left = dpi(6),
                right = dpi(6),
                widget = wibox.container.margin
            },
            bg = beautiful.bg_alt_dark,
            forced_height = dpi(25),
            forced_width = dpi(40),
            shape = helpers.rrect(dpi(4)),
            widget = wibox.container.background
        },
        margins = {top = 5, bottom = 10,},
        widget = wibox.container.margin
    }

    local actions = wibox.widget {
        {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style = {underline_normal = false, underline_selected = true},
        widget = naughty.list.actions
    },
    widget = wibox.container.margin,
    margins = {left = 10, right = 10,}
    }

    naughty.layout.box {
        notification = n,
        type = "notification",
        bg = "#00000000",
        widget_template = {
            {
                {
                    {
                        {
                            {
                                widget = wibox.widget.textbox,
                                markup = "<span foreground='" .. beautiful.fg_color .. "61" .. "'>- " .. n.app_name .. " -</span>",
                                font = beautiful.font_var .. "10"
                            },
                            margins = {left = 10},
                            widget = wibox.container.margin
                        },
                        nil,
                        {
                            {
                                widget = wibox.widget.textbox,
                                markup = "<span foreground='" .. beautiful.fg_color .. "61" .. "'></span>",
                                font = beautiful.font_var .. "18",
                                valign = "center",
                                align = "center"
                            },
                            widget = wibox.container.margin,
                            margins = {right = 10}
                        },
                        layout = wibox.layout.align.horizontal,
                        expand = "none",
                    },
                    margins = 1,
                    widget = wibox.container.margin
                },
            {
                {
                    {
                        {
                            widget = wibox.widget.imagebox,
                            resize = true,
                            image = n.icon,
                            forced_width = 52,
                            forced_height = 52,
                            clip_shape = helpers.rrect(6),
                            valign = "center",
                            halign = "center",
                        },
                        margins = {left = 15, right = 8, top = 10, bottom = 10},
                        widget = wibox.container.margin
                    },
                    bg = beautiful.bg_color,
                    widget = wibox.container.background
                },
                    {
                        {
                            helpers.vertical_pad(10),
                            {
                        {
                            step_function = wibox.container.scroll
                                .step_functions.waiting_nonlinear_back_and_forth,
                            speed = 50,
                            {
                                markup = "<span weight='normal'>" .. n.title .. "</span>",
                                font = beautiful.font_var .. " 13",
                                align = "left",
                                valign = "center",
                                widget = wibox.widget.textbox
                            },
                            forced_width = dpi(200),
                            widget = wibox.container.scroll.horizontal
                        },
                        {
                            markup = "<span foreground='" .. beautiful.fg_color .. "BF" .. "'>" .. n.message .. "</span>",
                            font = beautiful.font_var .. " 10",
                                valign = "center",
                            align = "left",
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.vertical,
                        spacing = 5
                    },
                    nil,
                        spacing = 10,
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = {left = 5, bottom = 10, right = 20},
                    widget = wibox.container.margin
                },
                layout = wibox.layout.align.horizontal
            },
                        actions,
            spacing = 0,
            layout = wibox.layout.fixed.vertical
        },  
        bg = beautiful.bg_color,
        shape = helpers.rrect(6),
        widget = wibox.container.background,
    },
    }
end)