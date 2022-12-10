-- requirements
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

return wibox.widget {
    -- {
    --     {
    --         widget = wibox.widget.textbox,
    --         markup = helpers.colorize_text("No Notifications :(", (beautiful.fg_color .. "4D")),
    --         font = beautiful.font_var .. "14",
    --         valign = "center",
    --         align = "center"
    --     },
    --     margins = {top = dpi(15)},
    --     widget = wibox.container.margin
    -- },
    nil,
    {
        nil,
        {
            {
                widget = wibox.widget.textbox,
                markup = helpers.colorize_text("", (beautiful.fg_color .. "33")),
                font = beautiful.font_var .. "40",
                valign = "center",
                align = "center"
            },
            {
                widget = wibox.widget.textbox,
                markup = helpers.colorize_text("This place feels empty", (beautiful.fg_color .. "33")),
                font = beautiful.font_var .. "14",
                valign = "center",
                align = "center"
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(15)
        },
        layout = wibox.layout.align.horizontal,
        expand = "none"
    },
    layout = wibox.layout.align.vertical,
    forced_height = awful.screen.focused().geometry.height - (dpi(150) + dpi(50) + dpi(190)),
    expand = "none",
}
