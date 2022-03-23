-- Screenshot widget (draft)

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")


-- screenshot directory
local ss_dirs = os.getenv("HOME") .. "/Pictures/Screenshots"

-- fullscreen screenshot with widgets
local ss_full = wibox.widget {
    image = os.getenv("HOME") .. "/.config/awesome/images/screenshot/ss_full.png",
    align = "center",
    valign = "center",
    shape = helpers.rrect(10),
    widget = wibox.widget.imagebox
}

-- selection only screenshot (no widgets)
local ss_sel = wibox.widget {
    image = os.getenv("HOME") .. "/.config/awesome/images/screenshot/ss_sel.png",
    align = "center",
    valign = "center",
    shape = helpers.rrect(10),
    widget = wibox.widget.imagebox
}

-- timed screenshots (for plain desktop)
local ss_time = wibox.widget {
    image = os.getenv("HOME") .. "/.config/awesome/images/screenshot/ss_timed.png",
    align = "center",
    valign = "center",
    shape = helpers.rrect(10),
    widget = wibox.widget.imagebox
}

-- setup
local ss_btns = wibox.widget {
    {
        ss_sel,
        ss_full,
        ss_time,
        spacing = 14,
        layout = wibox.layout.flex.horizontal
    },
    margins = 16,
    widget = wibox.container.margin
}

-- make the buttons actually do their thing
ss_full:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("scrot " .. ss_dirs .. "/Screenshot_%Y-%m-%d-%S.png" ..  "&& dunstify -i \"/home/saimoom/.config/awesome/images/screenshot/ss_full.png\" \"Screenshot\" \"saved!\"")
        dash_toggle()
    end)
))


ss_sel:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        dash_toggle()
        awful.spawn.with_shell("sleep 1; rm /tmp/tmp_ss.png; scrot -s -e 'xclip -selection clipboard -t image/png -i $f' /tmp/tmp_ss.png" ..  "&& dunstify -a \"screenshot\" -i \"/tmp/tmp_ss.png\" \"Screenshot\" \"copied to clipboard!\"")
    end)
))


ss_time:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("scrot  -d 3" .. ss_dirs .. "/Screenshot_%Y-%m-%d-%S.png" ..  "&& dunstify -i \"/home/saimoom/.config/awesome/images/screenshot/ss_timed.png\" \"Screenshot\" \"saved!\"")
        dash_toggle()
    end)
))