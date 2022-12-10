-- Minimal Dashbaord
--------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")


-- widgets
----------
local notifs = require("layout.dashboard.notifs.build")
local ram = require("layout.dashboard.resour.ram")
local cpu = require("layout.dashboard.resour.cpu")
local hdd = require("layout.dashboard.resour.hdd")

awful.screen.connect_for_each_screen(function(s)

    local screen_height = s.geometry.height


    -- Mainbox
    ---------------------
    dashbaord_d = wibox({
        type = "dock",
        screen = s,
        width = dpi(430),
        height = screen_height - (s.wibar_wid.height + beautiful.useless_gap * 4),
        shape = helpers.rrect(beautiful.rounded),
        bg = beautiful.bg_color,
        ontop = true,
        visible = false
    })


    dd_toggle = function() 
        control_hide()
        if not dashbaord_d.visible then
            dashbaord_d.visible = true
            awesome.emit_signal("dashboard::visible", true)
        else
            dashbaord_d.visible = false
            awesome.emit_signal("dashboard::visible", false)
        end
    end
	awful.placement.bottom_right(dashbaord_d, {honor_workarea = true, margins = beautiful.useless_gap * 2})
    --~~~~~~~~~~~~~~~

    dashbaord_d:setup {
        {
            {
                {
                    {
                        ram,
                        cpu,
                        hdd,
                        spacing = dpi(30),
                        layout = wibox.layout.fixed.horizontal,
                    },
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                margins = dpi(25),
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            bg = beautiful.bg_color,
            forced_height = dpi(150),
        },
        {
            {
                notifs,
                widget = wibox.container.background,
                bg = beautiful.bg_color,
                shape = helpers.rrect(beautiful.rounded)
            },
            margins = dpi(15),
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.vertical
    }

end)

-- eof
------