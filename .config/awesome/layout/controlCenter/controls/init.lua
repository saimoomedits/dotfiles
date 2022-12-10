-- services buttons
-- ~~~~~~~~~~~~~~~~
-- each button has a fade animation when activated



-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")


-- widgets
-- ~~~~~~~
local wifi = require("layout.controlCenter.controls.wifi")
local bluetooth   = require("layout.controlCenter.controls.bluetooth")
local dnd = require("layout.controlCenter.controls.Dnd")
local nl = require("layout.controlCenter.controls.nightlight")



-- old dprecated widgets
--- doesn't work anymore
-- extras
----------------------------------------------------------------
-- local n_light = require("layout.controlCenter.services.redshift")
-- local dnd = require("layout.controlCenter.services.Dnd")
-- local record = require("layout.controlCenter.services.Record")
-- local mic = require("layout.controlCenter.services.mic")

-- extras setup
-- local control_center_extra_conrols = wibox.widget{
--         n_light,
--         dnd,
--         mic,
--         layout = wibox.layout.fixed.horizontal,
--         spacing = dpi(22),
--         visible = false
-- }
-- Eo extras
-----------------------------------------------



-- return
-- ~~~~~~
local returner =  wibox.widget{
    {
        {
            {
                wifi,
                bluetooth,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(20)
            },
            {
                dnd,
                nl,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(20)
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(20)
        },
        margins = dpi(16),
        widget = wibox.container.margin
    },
    bg = beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(160),
    widget = wibox.container.background
}

return returner