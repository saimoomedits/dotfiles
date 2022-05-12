-- titlebar
-- ~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local wibox     = require("wibox")
local helpers   = require("helpers")
local gears     = require("gears")





-- misc/vars
-- ~~~~~~~~~~

-- function to create those buttons
local function create_button(shape, color, command, c)

  -- the widget
  local w = wibox.widget{
    widget = wibox.container.background,
    bg = color or beautiful.accent,
    shape = shape or helpers.prrect(beautiful.rounded, true, true, false, true),
    forced_width = dpi(15),
    forced_height = dpi(15)
  }


  -- hover effect
  w:connect_signal('mouse::enter', function ()
    w.bg = beautiful.accent
  end)

  w:connect_signal('mouse::leave', function ()
    w.bg = beautiful.ext_light_fg or beautiful.fg_color
  end)

  -- press effect
  w:connect_signal('button::press', function ()
    w.bg = beautiful.fg_color .. "99"
  end)

  w:connect_signal('button::release', function ()
    w.bg = beautiful.accent
  end)
                

  -- dynamic color
  local function dyna()
    if client.focus == c then
      w.bg = beautiful.ext_light_fg or beautiful.fg_color
    else
      w.bg = beautiful.ext_light_bg_2 or beautiful.bg_3
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
    awful.titlebar(c, { position = "left", size = dpi(48), font = beautiful.font_var .. "12",
                        fg = beautiful.fg_color .. "99", bg = beautiful.ext_light_bg or beautiful.bg_color }): setup {

      layout = wibox.layout.align.vertical,
      expand = "none",
      {
          wibox.widget.textbox(""),
          widget = wibox.container.background,
          buttons = buttons,
          forced_height = dpi(360)
      },
      {
        {
          nil,
          {
              create_button(function(cr, width, height) 
                gears.shape.transform(gears.shape.isosceles_triangle)
                :rotate_at(width / 2, height / 2, math.pi*2)
                (cr, width, height)
              end,
                beautiful.fg_color,
              function ()
                c:kill()
              end,
              c),

              create_button(gears.shape.circle, beautiful.fg_color, function ()
                c.maximized = not c.maximized c:raise()
              end, c),

              create_button(helpers.rrect(3), beautiful.fg_color, function ()
                awful.client.floating.toggle(c)
              end, c),

              layout  = wibox.layout.fixed.vertical,
              spacing = dpi(35)
          },
              layout = wibox.layout.align.horizontal,
              expand = "none"
        },
        widget = wibox.container.background,
        buttons = nil,
      },
      {
          wibox.widget.textbox(""),
          widget = wibox.container.background,
          buttons = buttons,
          forced_height = dpi(360)
      }
    }



end)


-- exra
-- ~~~~
require("layout.decorations.music")