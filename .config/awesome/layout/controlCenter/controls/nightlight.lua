-- Dark button/widget
-- ~~~~~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local rubato = require("mods.rubato")


-- misc/vars
-- ~~~~~~~~~

local service_icon = ""


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
    widget = wibox.container.background,
    shape = gears.shape.circle,
    border_color = beautiful.fg_color .. "33",
    forced_width = dpi(55),
    forced_height = dpi(55),
    bg = beautiful.bg_3
}



  -- button press animation
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







  -- kill every redshift process


  local readwrite = require("misc.scripts.read_writer")

  local output = readwrite.readall("blue_light_state")

  if output:match("true") then
      icon.markup = helpers.colorize_text(service_icon, beautiful.accent)
      animation_button_opacity:set(0.09)
  else
      icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color .. "4D")
      animation_button_opacity:set(0)
  end

-- buttons
alright:buttons(gears.table.join(awful.button({}, 1, nil, function()
  awful.spawn.easy_async_with_shell(
      [[
      if [ ! -z $(pgrep redshift) ];
      then
          redshift -x && pkill redshift && killall redshift
          echo "false" > $HOME/.config/awesome/misc/.information/blue_light_state
          echo 'OFF'
      else
          redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
          echo "true" > $HOME/.config/awesome/misc/.information/blue_light_state
          echo 'ON'
      fi
      ]],
      function(stdout)
          if stdout:match("ON") then
              icon.markup = helpers.colorize_text(service_icon, beautiful.accent)
              animation_button_opacity:set(0.09)
              require("layout.ding.extra.short")("", "Night Light enabled")
          else
              icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color .. "4D")
              animation_button_opacity:set(0)
              require("layout.ding.extra.short")("", "Night Light disabled")
          end
      end
  )
end)))




return alright