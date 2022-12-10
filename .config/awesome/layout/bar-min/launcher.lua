-- launcher icon
----------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


-- widgets
----------

local icon = wibox.widget {
    markup = "",
    font = beautiful.icon_var .. "12",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

-- indicator for launcher
local indicator = wibox.widget{
    widget = wibox.container.background,
    bg = beautiful.fg_color .. "4D",
    forced_height = dpi(2),
    visible = false
}
awesome.connect_signal("bling::app_launcher::visibility", function(val) 
    if val then
        indicator.visible = true
    else
        indicator.visible = false
    end
end)



-- make it more cool!
local kaka = require("helpers.widgets.create_button")(
    {
        {
            nil, nil, indicator,
            layout = wibox.layout.align.vertical
        },
        {
            {
                icon,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(15)
            },
            margins = {left = dpi(12), right = dpi(12)},
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
  beautiful.bg_3,
  beautiful.fg_color .. "33",
  dpi(0),
  dpi(0),
  dpi(0),
  helpers.rrect(beautiful.rounded - 2)
)

kaka:connect_signal(
    "button::press",
    function()
        app_launcher:toggle()
end)

return kaka