-- Minimal control center
-- ~~~~~~~~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local rubato = require("mods.rubato")
local readwrite = require("misc.scripts.read_writer")



--[[ few stuffs to note

-- sidebar height (extras disabled)
-- height = dpi(580),

-- sidebar new height (extras enabled)
-- height = dpi(715),

]]



awful.screen.connect_for_each_screen(function(s)

    -- Mainbox
    --~~~~~~~~~~~~~~~~~
    control_c = wibox({
        type = "dock",
        shape = helpers.rrect(beautiful.rounded),
        screen = s,
        width = dpi(420),
        bg = beautiful.bg_color,
        margins = 20,
        ontop = true,
        visible = false
    })
    --~~~~~~~~~~~~~~~



    -- widgets
    --~~~~~~~~
    local profile = require("layout.controlCenter.profile")
    local sessions = require("layout.controlCenter.sessionctl")
    local sliders = require("layout.controlCenter.sliders")
    local song = require("layout.controlCenter.music")
    local services = require("layout.controlCenter.services")
    local statusline = require("layout.controlCenter.statusbar")



    -- animations
    --------------
    local slide_right = rubato.timed{
        pos = s.geometry.height,
        rate = 60,
        intro = 0.14,
        duration = 0.33,
        subscribed = function(pos) control_c.y = s.geometry.y + pos end
    }


    local slide_end = gears.timer({
        single_shot = true,
        timeout = 0.33 + 0.08,
        callback = function()
            control_c.visible = false
        end,
    })


    -- toggler script
    --~~~~~~~~~~~~~~~
    local screen_backup = 1

    cc_toggle = function(screen)

        -- set screen to default, if none were found
        if not screen then
            screen = s
        end

        -- control center x position
        control_c.x = screen.geometry.x + (dpi(48) + beautiful.useless_gap * 4)

        -- toggle visibility
        if control_c.visible then

            -- check if screen is different or the same
            if screen_backup ~= screen.index then
                control_c.visible = true
            else
                slide_end:again()
                slide_right.target = s.geometry.height
            end

        elseif not control_c.visible then

            slide_right.target = s.geometry.height - (control_c.height + beautiful.useless_gap * 2)
            control_c.visible = true

        end

        -- set screen_backup to new screen
        screen_backup = screen.index
    end
    -- Eof toggler script
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




    -- function to show/hide extra buttons
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    function show_extra_control_stuff(input)
        if input then
            awesome.emit_signal("controlCenter::extras", true)
            control_c.height = dpi(715)
            readwrite.write("cc_state", "open")
        else
            awesome.emit_signal("controlCenter::extras", false)
            control_c.height = dpi(580)
            readwrite.write("cc_state", "closed")
        end
        slide_right.target = s.geometry.height - (control_c.height + beautiful.useless_gap * 2)
    end



    -- Initial setup
    control_c:setup {
        {
            {
                {
                    profile,
                    nil,
                    sessions,
                    layout = wibox.layout.align.horizontal
                },
                sliders,
                song,
                services,
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(24)
            },
            widget = wibox.container.margin,
            margins = dpi(20)
        },
        {
            statusline,
            margins = {left = dpi(20), right = dpi(20), bottom = dpi(0)},
            widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.vertical,
    }



    -- reload cc state on reload or startup
    ---------------------------------------
    local output = readwrite.readall("cc_state")

    if output:match("open") then
        awesome.emit_signal("controlCenter::extras", true)
        control_c.height = dpi(715)
    else
        awesome.emit_signal("controlCenter::extras", false)
        control_c.height = dpi(580)
    end
    --------------------------------------------------------
        

end)