-- wifi button/widget
-- ~~~~~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local readwrite = require("misc.scripts.read_writer")
local rubato = require("mods.rubato")


-- misc/vars
-- ~~~~~~~~~

local service_icon = ""

-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget{
    font = beautiful.icon_var .. "16",
    markup = helpers.colorize_text(service_icon, beautiful.fg_color),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "center"
}

-- animation :love:
local circle_animate = wibox.widget{
	widget = wibox.container.background,
	shape = helpers.rrect(beautiful.rounded - 3),
	bg = beautiful.accent,
	forced_width = 65,
	forced_height = 0,
}

-- mix those
local alright = wibox.widget{
    {
		{
			nil,
			{
				circle_animate,
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal,
			expand = "none"
		},
        {
            nil,
            {
                icon,
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(10)
            },
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        layout = wibox.layout.stack
    },
    shape = gears.shape.circle,
    widget = wibox.container.background,
    border_color = beautiful.fg_color .. "33",
    forced_width = dpi(55),
    forced_height = dpi(55),
    bg = beautiful.bg_3
}




  local animation_button_opacity = rubato.timed{
      pos = 0,
      rate = 60,
      intro = 0.08,
      duration = 0.3,
      awestore_compat = true,
      subscribed = function(pos)
		circle_animate.opacity = pos
      end
  }


  _G.awesome_dnd_state = false


  local update_things = function ()
      if _G.awesome_dnd_state then
          icon.markup = helpers.colorize_text(service_icon, beautiful.accent)
          animation_button_opacity:set(.09)
          require("layout.ding.extra.short")("", "Notifs disabled")
      else
          icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color .. "4D")
          animation_button_opacity:set(0)
          require("layout.ding.extra.short")("", "Notifs enabled")
      end
      
  end



  -- reload old state
  --~~~~~~~~~~~~~~~~~

    local output = readwrite.readall("dnd_state")

    local boolconverter={
        ["true"]  =   true,
        ["false"] =   false
    }

    awesome_dnd_state = boolconverter[output]
    update_things()
    --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  alright:buttons(gears.table.join(
              awful.button( {}, 1, function () 
                  awesome_dnd_state = not awesome_dnd_state
                  readwrite.write("dnd_state", tostring(_G.awesome_dnd_state))
                  update_things()
              end)
      )
  )
  
  return alright