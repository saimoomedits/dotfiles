-- titlebar 
-- with 3 objects

local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("helpers")

client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }


    local beautiful = require("beautiful")
  
    awful.titlebar(c, { position = "top", size = 50, font = beautiful.font_var .. "12", fg = beautiful.fg_color .. "99" }) : setup {
        { -- Left
          {
            awful.titlebar.widget.iconwidget(c, {clip_shape = helpers.rrect(10)}),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
          },
            margins = {left = 18, top = 13, bottom = 13},
            widget = wibox.container.margin
         },
          { -- Middle
          awful.titlebar.widget.titlewidget(c, {color = beautiful.bg_light}),
          buttons = buttons,
          layout  = wibox.layout.flex.horizontal
      },
      { -- Right
        {
            {
                  -- awful.titlebar.widget.maximizedbutton(c),
                  awful.titlebar.widget.closebutton    (c),
                  layout = wibox.layout.fixed.horizontal,
                  spacing = 20
            },
              margins = {right = 18, top = 16, bottom = 16},
            spacing = 8,
              widget = wibox.container.margin
        },
          layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal,
      expand = "none"
}

end)