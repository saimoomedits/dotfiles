-- notifs ig
-- ~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("mods.rubato")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")


-- Dashboard
-- ~~~~~~~~~

-- a random name
dashboard_llc = wibox({
    type = "dock",
    shape = helpers.rrect(beautiful.rounded),
    screen = 1,
    height = dpi(900) - beautiful.useless_gap * 4,
    width = dpi(420),
    bg = beautiful.bg_color,
    ontop = true,
    visible = false
})
awful.placement.right(dashboard_llc, {honor_workarea = true, margins = beautiful.useless_gap * 2 })



local hover_thing = wibox({
    type = "dnd",
    screen = 1,
    height = dpi(900) - beautiful.useless_gap * 4,
    width = dpi(7),
    opacity = 0,
    bg = beautiful.bg_color,
    ontop = true,
    visible = true
})

awful.placement.right(hover_thing)


-- Animations
-- ~~~~~~~~~~

local hidden_pos = awful.screen.focused().geometry.width
local visibl_pos = awful.screen.focused().geometry.width - (dashboard_llc.width + beautiful.useless_gap * 2)

local slide_right = rubato.timed{
    pos = hidden_pos,
    rate = 60,
    intro = 0.1,
    duration = 0.46,
    awestore_compat = true,
    subscribed = function(pos) dashboard_llc.x = pos end
}

local dash_status = false

slide_right.ended:subscribe(function()
    if dash_status then
        dashboard_llc.visible = false
    end
end)


-- toggler
local dash_show = function()
    slide_right:set(visibl_pos)
    dashboard_llc.visible = true
    dash_status = false
end

local dash_hide = function()
    slide_right:set(hidden_pos)
    dash_status = true
end

dash_toggle = function()
    if dashboard_llc.visible then
        dash_hide()
    else
        dash_show()
    end
end


local gtimer = require("gears").timer
hover_thing:connect_signal("mouse::enter", function ()
    gtimer {
        timeout   = 0.24,
        call_now  = false,
        autostart = true,
        single_shot = true,
        callback  = function()
                dash_show()
        end
    }
end)

hover_thing:connect_signal("mouse::leave", function ()
    local hide = gtimer {
        timeout   = 0.24,
        call_now  = false,
        autostart = true,
        single_shot = true,
        callback  = function()
                dash_hide()
        end
    }

    hide:start()

    dashboard_llc:connect_signal("mouse::enter", function ()
        hide:stop()
    end)
    dashboard_llc:connect_signal("mouse::leave", function ()
        hide:again()
    end)
end)


--~~~~~~~~~~~~~~~~~~~~~~~~ Eof animations


-- widgets
-- ~~~~~~~

local cal = require("layout.dashboard.calendar")
local notifs = require("layout.dashboard.notifs.build")


dashboard_llc:setup{
    {
        layout = wibox.layout.align.vertical,
        expand = "none",
        spacing = dpi(20),
        {
            nil,
            cal,
            layout = wibox.layout.align.horizontal,
            expand = "none"
        },
        nil,
        notifs
    },
    margins = dpi(20),
    widget = wibox.container.margin
}