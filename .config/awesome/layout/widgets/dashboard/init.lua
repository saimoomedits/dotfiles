-- inital widgets setup.
-- sidebar

local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local rubato = require("mods.rubato")

local screen_height = awful.screen.focused().geometry.height


-- the thing that keeps everything under control
dash = wibox({
    type = "dnd",
    height = screen_height,
    screen = 1,
    width = dpi(400),
    margins = 20,
    ontop = true,
    visible = false
})
awful.placement.left(dash)

-- animations
local slide = rubato.timed{
    pos = dpi(-400),
    rate = 60,
    intro = 0.2,
    duration = 0.5,
    awestore_compat = true,
    subscribed = function(pos) dash.x = pos end
}

slide.ended:subscribe(function()
    if dash_status then
        dash.visible = false
    end
end)


-- toggler

dash_status = false

dash_show = function()
    if the_ctl_center_vis then
        toggle_control_c()
    end
    slide:set(0)
    dash.visible = true
    bar_move_true()
    dash_status = false
end

dash_hide = function()
    slide:set(dpi(-400))
    bar_move_false()
    dash_status = true
end

dash_toggle = function()
    if dash.visible then
        dash_hide()
    else
        dash_show()
    end
end


-- widgets themselves
local profile = require("layout.widgets.dashboard.profile")
local mpd = require("layout.widgets.dashboard.mpd")
local clock = require("layout.widgets.dashboard.time")
local sys_short = require("layout.widgets.dashboard.systen_stat_short")
local notifs = require("layout.widgets.dashboard.notification_center")
local msc_btns = require("layout.widgets.dashboard.msc_btn")
local timer = require("layout.widgets.dashboard.timer")
local search = require("layout.widgets.dashboard.search")


--[[
    not in use

    {
        {
            upt,
            socials,
            layout = wibox.layout.align.vertical,
        },
        sys,
        layout = wibox.layout.align.horizontal
    },

]]

-- widgets setup
dash:setup {
    {
        {
            search,
            {
                clock,
                timer,
                layout = wibox.layout.align.horizontal
            },
            {
                {
                    profile,
                    sys_short,
                    layout = wibox.layout.align.horizontal,
                },
                widget = wibox.container.background,
            },
            widget = wibox.container.background,
            layout = wibox.layout.fixed.vertical
        },
        {
            mpd,
            msc_btns,
            layout = wibox.layout.align.horizontal
        },
    notifs,
    layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.fixed.vertical,
    widget = wibox.container.background
}

-- Eof
