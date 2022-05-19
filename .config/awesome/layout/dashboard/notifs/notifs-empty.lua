-- requirements
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

return wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("No Notifications :(", (beautiful.fg_color .. "4D")),
            font = beautiful.font_var .. "14",
            valign = "center",
            align = "center"
        },
        margins = {top = dpi(15)},
        widget = wibox.container.margin
    },
    {
        widget = wibox.widget.textbox,
        markup = helpers.colorize_text("", (beautiful.fg_color .. "33")),
        font = beautiful.font_var .. "74",
        valign = "center",
        align = "center"
    },
    layout = wibox.layout.align.vertical,
    expand = "none",
    forced_height = dpi(350),
}
