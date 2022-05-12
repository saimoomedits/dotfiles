-- services buttons
-- ~~~~~~~~~~~~~~~~
-- each button has a expand animation when activated


-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")


-- widgets
-- ~~~~~~~
local wifi = require("layout.dashboard.services.wifi")
local bluetooth = require("layout.dashboard.services.bluetooth")
local redshift = require("layout.dashboard.services.redshift")
local dnd = require("layout.dashboard.services.Dnd")
local record = require("layout.dashboard.services.record")
local mic = require("layout.dashboard.services.microphone")



-- return
-- ~~~~~~
return wibox.widget{
    {
        wifi,
        bluetooth,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(18)
    },
    {
        redshift,
        dnd,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(18)
    },
    {
        record,
        mic,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(18)
    },
    spacing = dpi(18),
    layout = wibox.layout.fixed.vertical
}