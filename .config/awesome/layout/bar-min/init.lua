-- bar taglist.
---------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi



-- widgets
----------
local statuses = require("layout.bar-min.statuses")
local time = require("layout.bar-min.time")
local music = require("layout.bar-min.music")
local search = require("layout.bar-min.search")
local tasks = require("layout.bar-min.tasklist")
local launcher = require("layout.bar-min.launcher")


-- connect to each screen
awful.screen.connect_for_each_screen(function(s)

local taglist = require("layout.bar-min.taglist")(s)

    -- screen width
    local screen_width = s.geometry.width


    -- wibar
    s.wibar_wid = awful.wibar({
        position    = "bottom",
        screen      = s,
        visible     = true,
        ontop       = true,
        type        = "tooltip",
        x           = 0,
        y           = 0,
        width       = screen_width,
        bg          =  beautiful.bg_color .. "00",
        height      = dpi(54)
    })

    -- set it up!
    s.wibar_wid:setup {
            {
                {
                    {
                        {
                            launcher,
                            taglist,
                            tasks,
                            spacing = dpi(15),
                            layout = wibox.layout.fixed.horizontal
                        },
                        nil,
                        {
                            time,
                            music,
                            statuses,
                            layout = wibox.layout.fixed.horizontal,
                            spacing = dpi(15)
                        },
                        layout = wibox.layout.align.horizontal,
                        expand = "none"
                    },
                    widget = wibox.container.margin,
                    margins = {left = dpi(15), right = dpi(15), top = dpi(8), bottom = dpi(8)}
                },
                widget = wibox.container.background,
                bg = beautiful.bg_color,
                forced_height = s.wibar_wid.height
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(0)
    }




    -- function to remove the bar in maxmized/fullscreen apps
    ------ Stolen from javacafe01 - https://github.com/javacafe01
    -------------------------------------------------------------

    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.wibar_wid.visible = false
        else
            c.screen.wibar_wid.visible = true
        end
    end

    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.wibar_wid.visible = true
        end
    end

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)

end)

-- EOF
------
