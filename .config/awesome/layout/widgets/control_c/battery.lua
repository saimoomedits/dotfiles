-- battery widget for small control center
-- with expressions :)

local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- state icon
local state_ic = wibox.widget {
    markup = "69",
    font = beautiful.font_var .. "20",
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center"
}

-- the circular prgress widget
local battery_haha = wibox.widget {
    {
      state_ic,
    margins = 10,
    widget = wibox.container.margin
    },
    max_value = 100,
    min_value = 0,
    value = 10,
    thickness = 8,
    start_angle = 1.4,
    forced_height = 32,
    forced_width = 32,
    rounded_edge = true,
    bg = beautiful.bg_color,
    colors = {beautiful.fg_color},
    paddings = 0,
    widget = wibox.container.arcchart
}

-- connect to battery daemon and change vlues accordingly
awesome.connect_signal("signal::battery", function(value) 
    local dyn_col = beautiful.blue_color

    if value < 15 then
      dyn_col = beautiful.red_color
    elseif value < 25 then
      dyn_col = beautiful.yellow_color
    else
      dyn_col = beautiful.green_color
    end
    battery_haha.value = value
    state_ic.markup = "<span foreground='" .. beautiful.fg_color .. "'>" .. value .. "</span>"


  battery_haha.colors = {dyn_col} 
  
end)


-- initial
local the_thing = wibox.widget {
    {
        battery_haha,
        layout = wibox.layout.flex.horizontal,
        forced_height = 80,
    },
    margins = 5,
    widget = wibox.container.margin
}

return the_thing
