-- titlebar
-----------
-- Copyleft © 2022 Saimoomedits



-- requirements
---------------
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local wibox     = require("wibox")
local helpers   = require("helpers")
local gears     = require("gears")





-- variables
------------

-- function to create those buttons
local function create_button(shape, color, command, c)

  -- the widget
  local w = wibox.widget{
    widget = wibox.container.background,
    bg = color .. "99" or beautiful.accent,
    shape = shape,
    forced_width = dpi(12),
    forced_height = dpi(12)
  }


  -- hover effect
  w:connect_signal('mouse::enter', function ()
    w.bg = color
  end)

  w:connect_signal('mouse::leave', function ()
    w.bg = color .. "99"
  end)

  -- press effect
  w:connect_signal('button::press', function ()
    w.bg = beautiful.accent
  end)

  w:connect_signal('button::release', function ()
    w.bg = color .. "99"
  end)
                

  -- dynamic color
  local function dyna()
    if client.focus == c then
      w.bg = color .. "99"
    else
      w.bg = color .. "33"
    end
  end

  -- apply dynamic color
  c:connect_signal("focus",dyna)

  c:connect_signal("unfocus", dyna)


  -- button action
  w:buttons(gears.table.join(
  awful.button({ }, 1, command)))

  return w

end







-- init
-- ~~~~

-- connect to titlebar signal
client.connect_signal("request::titlebars", function(c)


    -- buttons for the actual titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
    }



    -- the titlebar
    awful.titlebar(c, { position = "top", size = dpi(44), font = beautiful.font_var .. "12",
                        fg = beautiful.fg_color .. "99", bg = beautiful.bg_color }): setup {

      layout = wibox.layout.align.horizontal,
      {
        {
          {
            nil,
            {
                {
                  {

                    create_button(gears.shape.circle, beautiful.red_color, function ()
                      c:kill()
                    end, c),

                    create_button(gears.shape.circle, beautiful.accent, function ()
                      c.maximized = not c.maximized c:raise()
                    end, c),

                    create_button(gears.shape.circle, beautiful.green_color, function ()
                      c.minimize = true
                    end, c),

                    layout  = wibox.layout.fixed.horizontal,
                    spacing = dpi(18)
                  },
                  margins = dpi(10),
                  widget = wibox.container.margin
                },
                bg = beautiful.bg_3,
                shape = helpers.rrect(beautiful.rounded - 2),
                widget = wibox.container.background
            },
                layout = wibox.layout.align.vertical,
                expand = "none"
          },
          margins = {left = dpi(8)},
          widget = wibox.container.margin
        },
        widget = wibox.container.background,
        buttons = nil,
      },
      {
        widget = wibox.widget.background,
        buttons = buttons,
      },
      {
        {
          {
                awful.titlebar.widget.iconwidget(c),
                margins = dpi(8),
                widget = wibox.container.margin
          },
              bg = beautiful.bg_3,
              shape = helpers.rrect(beautiful.rounded - 2),
              widget = wibox.container.background
          },
          widget = wibox.container.margin,
          margins = {right = dpi(10), top = dpi(5), bottom = dpi(5)}
      },
      {
        wibox.widget.textbox,
        layout = wibox.layout.flex.horizontal,
        buttons = buttons
      }
    }



end)


-- exras
--------
-- require("layout.decorations.music")


-- eof
------