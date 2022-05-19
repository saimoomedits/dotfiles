-- redshift button/widget
-- ~~~~~~~~~~~~~~~~~~~~~~


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

local service_name = "Blue Light"
local service_icon = ""

-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget{
    font = beautiful.icon_var .. "18",
    markup = helpers.colorize_text(service_icon, beautiful.fg_color),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "center"
}

-- name
local name = wibox.widget{
    font = beautiful.font_var .. "11",
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(service_name, beautiful.fg_color),
    valign = "center",
    align = "center"
}

-- animation :love:
local circle_animate = wibox.widget{
	widget = wibox.container.background,
	shape = helpers.rrect(beautiful.rounded),
	bg = beautiful.accent,
	forced_width = 0,
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
                name,
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(10)
            },
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        layout = wibox.layout.stack
    },
    shape = helpers.rrect(beautiful.rounded),
    widget = wibox.container.background,
    border_color = beautiful.fg_color .. "33",
    forced_width = dpi(110),
    forced_height = dpi(110),
    bg = beautiful.bg_3 .. "BF"
}



  -- button press animation
  local animation_button = rubato.timed{
      pos = 0,
      rate = 60,
      intro = 0.02,
      duration = 0.14,
      awestore_compat = true,
      subscribed = function(pos)
		circle_animate.forced_width = pos
		circle_animate.forced_height = pos
      end
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

  -- kill every redshift process


  awful.spawn.easy_async_with_shell("cat $HOME/.config/awesome/misc/.information/blue_light_state", function (stdout)
        local output = string.lower(string.gsub(stdout, '^%s*(.-)%s*$', '%1'))

		if output:match("true") then
             icon.markup = helpers.colorize_text(service_icon, beautiful.bg_color)
             name.markup = helpers.colorize_text(service_name, beautiful.bg_color)
             animation_button:set(alright.forced_width)
             animation_button_opacity:set(1)
		else
             icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color)
             name.markup = helpers.colorize_text(service_name, beautiful.fg_color)
             animation_button:set(0)
             animation_button_opacity:set(0)
		end


  end)

  -- buttons
  alright:buttons(gears.table.join(awful.button({}, 1, nil, function()
	awful.spawn.easy_async_with_shell(
		[[
		if [ ! -z $(pgrep redshift) ];
		then
			redshift -x && pkill redshift && killall redshift
            echo "false\n" > $HOME/.config/awesome/misc/.information/blue_light_state
			echo 'OFF'
		else
			redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
            echo "true\n" > $HOME/.config/awesome/misc/.information/blue_light_state
			echo 'ON'
		fi
		]],
		function(stdout)
			if stdout:match("ON") then
                icon.markup = helpers.colorize_text(service_icon, beautiful.bg_color)
                name.markup = helpers.colorize_text(service_name, beautiful.bg_color)
                animation_button:set(alright.forced_width)
                animation_button_opacity:set(1)
                require("layout.ding.extra.short")("", "Night Light enabled")
			else
                icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color)
                name.markup = helpers.colorize_text(service_name, beautiful.fg_color)
                animation_button:set(0)
                animation_button_opacity:set(0)
                require("layout.ding.extra.short")("", "Night Light disabled")
			end
		end
	)
end)))



return alright