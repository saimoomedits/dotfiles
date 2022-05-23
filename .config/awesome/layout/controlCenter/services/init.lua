-- services buttons
-- ~~~~~~~~~~~~~~~~
-- each button has a fade animation when activated



-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")


-- widgets
-- ~~~~~~~
local wifi = require("layout.controlCenter.services.wifi")
local bluetooth   = require("layout.controlCenter.services.bluetooth")
local dark = require("layout.controlCenter.services.dark")


-- extras
----------------------------------------------------------------
local n_light = require("layout.controlCenter.services.redshift")
local dnd = require("layout.controlCenter.services.Dnd")
-- local record = require("layout.controlCenter.services.Record")
local mic = require("layout.controlCenter.services.mic")

-- extras setup
local control_center_extra_conrols = wibox.widget{
        n_light,
        dnd,
        mic,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(22),
        visible = false
}
-- Eo extras
-----------------------------------------------



-- return
-- ~~~~~~
local returner =  wibox.widget{
    {
        wifi,
        bluetooth,
        dark,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(22)
    },
    control_center_extra_conrols,
    spacing = dpi(0),
    layout = wibox.layout.fixed.vertical
}


awesome.connect_signal("controlCenter::extras", function (value)
    control_center_extra_conrols.visible = value or false
    if not value then
        returner.spacing = dpi(0)
    else
        returner.spacing = dpi(22)
    end
end)


return returner