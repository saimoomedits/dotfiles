

-- requirements
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")


-- clear button
return require("helpers.widgets.create_button")(
  {
    markup = helpers.colorize_text("Clear All", (beautiful.ext_light_fg or beautiful.fg_color)),
    font = beautiful.font_var .. "11",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  },
    beautiful.bg_3,
  beautiful.fg_color .. "33",
  {top = dpi(10), bottom = dpi(10), left = dpi(20), right = dpi(20)}
)
