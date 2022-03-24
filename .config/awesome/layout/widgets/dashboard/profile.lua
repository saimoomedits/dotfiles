-- profile widget
-- with session buttons

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("helpers")

-- image properties
local profile_pic_img = wibox.widget {
        image = os.getenv("HOME") .. "/.config/awesome/images/profile.png",
        clip_shape = helpers.rrect(6),
        halign = "center",
        valign = "center",
        widget = wibox.widget.imagebox
}

local profile_pic_container = wibox.widget {
    shape = helpers.rrect(6),
    forced_height = dpi(70),
    forced_width = dpi(70),
    widget = wibox.container.background
}


local welcome = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<b>Welcome</b>",
    font = beautiful.font_var .. "14",
    align = "left",
    valign = "center"
}

local usname = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. beautiful.fg_color .. "BF" .. "'>" .. os.getenv("USER") ..  "</span>",
    font = beautiful.font_var .. "12",
    align = "left",
    valign = "center"
}


local uptime = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>5h 10m</span>",
    font = beautiful.font_var .. "11",
    align = "left",
    valign = "center"
}

local upt_cmd = [[
    bash -c "
    if [ \"$(uptime -p | grep 'hour')\" ]; then
        echo \"$(uptime -p | sed 's/^...//' | awk '{print $1 \"h \" $3 \"m \"}')\"
    else
        echo \"0h $(uptime -p | sed 's/^...//' | awk '{print $1 \"m \"}')\"
    fi
    "]]

awful.widget.watch(upt_cmd, 200, function(_, stdout)
    local output = stdout
    output = string.gsub(output, '^%s*(.-)%s*$', '%1')
    uptime.markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>" .. output .. "</span>"
end)


-- initial
local profile = wibox.widget{
    {
        {
            {
                {
                        uptime,
                        {
                            welcome,
                            usname,
                            layout = wibox.layout.fixed.vertical,
                        },
                        spacing = 15,
                        layout = wibox.layout.fixed.vertical
                },
                nil,
                {
                    {
                        profile_pic_img,
                        widget = profile_pic_container
                    },
                    margins = {right = 5},
                    widget = wibox.container.margin
                },
                layout = wibox.layout.align.horizontal,
                expand = "none",
                spacing = 42,
            },
            margins = 15,
            widget = wibox.container.margin
        },
        widget = wibox.container.background,
        forced_height = 120,
        forced_width = 260,
        shape = helpers.rrect(7),
        bg = beautiful.bg_alt_dark,
        },
    top = dpi(15),
    bottom = dpi(5),
    right = dpi(10),
    left = dpi(20),
    widget = wibox.container.margin
}

return profile