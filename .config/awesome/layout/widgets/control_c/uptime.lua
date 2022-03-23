-- Uptime widget
-- format : {hour}h {minute}m

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")


-- "uptime" text
local upt = wibox.widget {
    {
        widget = wibox.widget.textbox,
        markup = "<span foreground='" .. beautiful.fg_color .. "99" .. "'>Uptime</span>",
        align = "left",
        valign = "top",
        font = beautiful.font_var .. "11",
    },
    margins = {top = 10, left = 10},
    widget = wibox.container.margin
}


-- simple decoration (not in use)
local deco = wibox.widget {
    {
        orientation = "vertical",
        span_ratio = 1,
        forced_width = 5,
        color = beautiful.magenta_color,
        thickness = 4,
        widget = wibox.widget.separator,
    },
    margins = {left = 10, top = 5, bottom = 5},
    widget = wibox.container.margin
}

-- the actual thing
local time = wibox.widget {
        widget = wibox.widget.textbox,
        align = "left",
        valign = "top",
        markup = "3h 10m",
        font = beautiful.font_var .. "16",
}


-- update time var to match the uptime
local upt_cmd = [[
    bash -c "

    if [ \"$(uptime -p | grep 'hour')\" ]; then
        echo \"$(uptime -p | sed 's/^...//' | awk '{print $1 \"h \" $3 \"m \"}')\"
    else
        echo \"0h $(uptime -p | sed 's/^...//' | awk '{print $1 \"m \"}')\"
    fi
    "]]

awful.widget.watch(upt_cmd, 200, function(_, stdout)
    time.markup = stdout
end)

-- box it
local time_boxed = wibox.widget {
    time,
    margins = {top = 10, left = 10,},
    widget = wibox.container.margin
}

-- inital
local core = wibox.widget {
    {
        {
            {
                upt,
                {
                    -- deco,
                    time_boxed,
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            nil,
            layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.background,
        shape = helpers.rrect(6),
        forced_height = 70,
        bg = beautiful.bg_alt_dark
    },
    margins = {right = 10, top = 13, left = 5, bottom = 10},
    forced_width = 200,
    forced_height = 95,
    widget = wibox.container.margin
}

return core
