-- requirements
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")


-- clear button
return require("helpers.widgets.create_button")(
  {
    markup = helpers.colorize_text("Clear All", (beautiful.ext_light_fg or beautiful.fg_color .. "99")),
    font = beautiful.font_var .. "10",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  },
  beautiful.bg_3,
  beautiful.fg_color .. "33",
  {top = dpi(6), bottom = dpi(6), left = dpi(14), right = dpi(14)},
  dpi(0),
  dpi(0),
  helpers.rrect(beautiful.rounded)
)
