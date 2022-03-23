-- adding custom titlebar to alacritty
-- dont ask why

local awful = require("awful")
local helpers = require("helpers")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local ruled = require("ruled")

local titlebar_init = function (c)

    awful.titlebar.hide(c)

    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }


    awful.titlebar(c, { position = "top", size = 50, font = beautiful.font_var .. "12"}) : setup {
        { -- Left
          {
              {
                  widget = wibox.widget.imagebox,
                  image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/alacritty.png", beautiful.fg_color),
                  forced_width = 28,
                  forced_height = 28,
                  valign = "center",
                  halign = "center"
              },
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
          },
            margins = {left = 18, top = 16, bottom = 16},
            widget = wibox.container.margin
         },
          { -- Middle
              {
                  widget = wibox.widget.textbox,
                  markup = "<span foreground='" .. beautiful.fg_color .. "99" .. "'>Terminal</span>",
                  valign = "center",
                  align = "center"
              },
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
    
end

-- Add the titlebar
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id = "Alacritty",
        rule = {instance = "Alacritty"},
        callback = titlebar_init
    }
end)