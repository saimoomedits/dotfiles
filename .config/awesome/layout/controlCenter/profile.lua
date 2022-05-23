-- profile widget
-- ~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")



-- widgets
-- ~~~~~~~

-- image
local profile_image = wibox.widget {
    {
        image = beautiful.images.profile,
        clip_shape = gears.shape.circle,
        widget = wibox.widget.imagebox
    },
    widget = wibox.container.background,
    border_width = dpi(1),
    forced_width = dpi(75),
    forced_height = dpi(75),
    shape = gears.shape.circle,
    border_color = beautiful.fg_color
}

-- username
local username = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(user_likes.username, beautiful.fg_color),
    font = beautiful.font_var .. "Medium 13",
    align = "left",
    valign = "center"
}

-- description/host
local desc = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(user_likes.userdesc, beautiful.fg_color .. "99"),
    font = beautiful.font_var .. "11",
    align = "left",
    valign = "center"
}


-- return
return wibox.widget{
    profile_image,
    {
        nil,
        {
            username,
            desc,
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(2)
        },
        layout = wibox.layout.align.vertical,
        expand = "none"
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(15)
}