-- Control Center
-- a small awful.widget.popup for system info

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

-- box widgets function
local function box_em(thingy_i)
local b = wibox.widget {
    {
        {
            thingy_i,
            widget = wibox.container.margin,
            margins = 10
        },
        widget = wibox.container.background,
        shape = helpers.rrect(10),
        bg = beautiful.bg_alt_dark
    },
    widget = wibox.container.margin,
    margins = 10,
}

return b

end


-- import widgets
local batt = require("layout.widgets.control_c.battery")
local sysy = require("layout.widgets.control_c.c_panel")
local sliders = require("layout.widgets.control_c.slides")
local uptime = require("layout.widgets.control_c.uptime")
   

-- initial setup
local real_stuff = awful.popup {
    widget = {
        {
            {
              {
                  box_em(batt),
                  {
                    uptime,
                    sliders,
                    layout = wibox.layout.fixed.vertical
                  },
                  spacing = 3,
                  layout = wibox.layout.flex.horizontal,
              },
              box_em(sysy),
              layout = wibox.layout.fixed.vertical
            },
            bg = beautiful.bg_color,
            widget = wibox.container.background
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    border_width = 0,
    placement = function(c)
        (awful.placement.bottom_left)(c, { margins = { left = 65, bottom = 10 } })
      end,
    shape        = gears.shape.rounded_rect,
    ontop        = true,
    visible      = false,
}

-- toggler
function toggle_control_c()
    if dash.visible then       -- if dash is visible then the popup wont show
        real_stuff.visible = false
    elseif real_stuff.visible then
        real_stuff.visible = false
        the_ctl_center_vis = false
    else
        real_stuff.visible = true
        the_ctl_center_vis = true
    end
end