-- tags  / layouts
-- aka workspaces

local awful = require("awful")


awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
}

screen.connect_signal("request::desktop_decoration", function(s)
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}

    local names = { "1", "2", "3", "4", "5", "6" }
    local l = awful.layout.suit
    local layouts = { l.tile, l.tile, l.tile, l.tile, l.fair,
    l.floating }
    awful.tag(names, s, layouts)

end)