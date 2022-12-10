-- Minimal control center
-------------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local readwrite = require("misc.scripts.read_writer")



-- add to each screen that is connected and is occupied
awful.screen.connect_for_each_screen(function(s)

    -- variables
    ------------
    local screen_width = s.geometry.width

    -- Mainbox
    ----------
    control_c = wibox({
        type = "dock",
        shape = helpers.rrect(beautiful.rounded),
        screen = s,
        width = dpi(410),
        height = dpi(640),
        bg = beautiful.bg_color,
        ontop = true,
        visible = false
    })



    -- widgets
    ----------
    local battery = require("layout.controlCenter.battery")
    local profile = require("layout.controlCenter.profile")
    local music = require("layout.controlCenter.music")
    local controls = require("layout.controlCenter.controls")
    local sliders = require("layout.controlCenter.sliders")
    local disk = require("layout.controlCenter.hdd")





    -- toggler script
    -----------------
    function control_hide()
        control_c.visible = false
        awesome.emit_signal("control_center::visible", false)
    end

    local function control_show()
        control_c.visible = true
        awesome.emit_signal("control_center::visible", true)
    end

    local screen_backup = 1

    cc_toggle = function(screen)

        if dashbaord_d.visible then
            dd_toggle()
        end

        -- control center placement
		awful.placement.bottom_right(control_c, {honor_workarea = true, margins = beautiful.useless_gap * 2})

        -- set screen to default, if none were found
        if not screen then
            screen = s
        end


        -- toggle visibility
        if control_c.visible then

            -- check if screen is different or the same
            if screen_backup ~= screen.index then
                control_show()
            else
				control_hide()
            end

        elseif not control_c.visible then
            control_show()
        end

        -- set screen_backup to new screen
        screen_backup = screen.index
    end
    -- Eof toggler script
    ---------------------



    -- Initial setup
    ----------------
    control_c:setup {
        {
            {
                {
                    battery,
                    disk,
                    spacing = dpi(28),
                    layout = wibox.layout.fixed.horizontal
                },
                {
                    profile,
                    controls,
                    spacing = dpi(28),
                    layout = wibox.layout.fixed.horizontal
                },
                {
                    sliders,
                    spacing = dpi(28),
                    layout = wibox.layout.fixed.horizontal
                },
                music,
                spacing = dpi(28),
                layout = wibox.layout.fixed.vertical
            },
            spacing = dpi(28),
            layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(28),
        widget = wibox.container.margin

    }



end)


-- eof
------