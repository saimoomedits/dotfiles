-- Minimal control center
-- ~~~~~~~~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")




--[[ few stuffs to note

-- sidebar height (extras disabled)
-- height = dpi(580),

-- sidebar new height (extras enabled)
-- height = dpi(715),

]]




-- Control center
-- ~~~~~~~~~~~~~~
control_c = wibox({
    type = "normal",
    shape = helpers.rrect(beautiful.rounded),
    screen = 1,
    width = dpi(420),
    bg = beautiful.bg_color,
    margins = 20,
    ontop = true,
    visible = false
})
--~~~~~~~~~~~~~~~



-- widgets
-- ~~~~~~~
local profile = require("layout.controlCenter.profile")
local sessions = require("layout.controlCenter.sessionctl")
local sliders = require("layout.controlCenter.sliders")
local song = require("layout.controlCenter.music")
local services = require("layout.controlCenter.services")
local statusline = require("layout.controlCenter.statusbar")



-- Animations
-- extra items`  slide animations
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local rubato = require("mods.rubato")
local slide = rubato.timed{
    pos = dpi(580),
    rate = 60,
    intro = 0.02,
    duration = 0.1,
    awestore_compat = true,
    subscribed = function(pos)
        control_c.height = pos
        awful.placement.bottom_left(control_c, {honor_workarea = true, margins = beautiful.useless_gap * 2 })
    end
}




-- function to show/hide extra buttons
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function show_extra_control_stuff(input)
    if input then
        awesome.emit_signal("controlCenter::extras", true)
        slide:set(715)
        awful.spawn.with_shell("echo \"open\n\" > $HOME/.config/awesome/misc/.information/cc_state")
    else
        awesome.emit_signal("controlCenter::extras", false)
        slide:set(580)
        awful.spawn.with_shell("echo \"closed\n\" > $HOME/.config/awesome/misc/.information/cc_state")
    end
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



awful.spawn.easy_async_with_shell("cat $HOME/.config/awesome/misc/.information/cc_state", function (stdout)
        local output = string.gsub(stdout, '^%s*(.-)%s*$', '%1')

        if output:match("open") then
            show_extra_control_stuff(true)
        else
            show_extra_control_stuff(false)
        end
    
end)
