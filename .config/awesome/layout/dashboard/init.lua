-- sidebar
-- ~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local rubato = require("mods.rubato")



-- dashboard
-- ~~~~~~~~~
dash = wibox({
    type = "dnd",
    height = dpi(700),
    shape = helpers.rrect(beautiful.rounded),
    screen = 1,
    width = dpi(810),
    bg = beautiful.black_color,
    margins = 20,
    ontop = true,
    visible = false
})
awful.placement.centered(dash, {honor_workarea = true, margins = beautiful.useless_gap * 2 })



-- animations
-- ~~~~~~~~~~
local slide = rubato.timed{
    pos = dpi(-dash.height),
    rate = 60,
    intro = 0.1,
    duration = 0.46,
    awestore_compat = true,
    subscribed = function(pos) dash.y = pos end
}


local dash_status = false

slide.ended:subscribe(function()
    if dash_status then
        dash.visible = false
    end
end)


-- toggler

local dash_show = function()
    slide:set(dpi(44) + beautiful.useless_gap * 2)
    dash.visible = true
    dash_status = false
end

local dash_hide = function()
    slide:set(dpi(-dash.height))
    dash_status = true
end

dash_toggle = function()
    if dash.visible then
        dash_hide()
    else
        dash_show()
    end
end



-- widgets
-- ~~~~~~~
local music = require("layout.dashboard.music")
local notifs = require("layout.dashboard.notif_center")
local slider_volume = require("layout.dashboard.volume")
local services = require("layout.dashboard.services")
local extra_btns = require("layout.dashboard.extra-buttons")



-- widget setup
-- ~~~~~~~~~~~~
dash:setup {
    {
        {
            {
                {
                    slider_volume,
                    music,
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(30)
                },
                services,
                spacing = dpi(80),
                layout = wibox.layout.fixed.vertical
            },
            nil,
            extra_btns,
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        notifs,
        spacing = dpi(25),
        layout = wibox.layout.fixed.horizontal
    },
    margins = dpi(25),
    widget = wibox.container.margin

}