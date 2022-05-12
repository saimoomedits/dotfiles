
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

local service_name = "Microphone"
local service_icon = ""

-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget{
    font = beautiful.icon_var .. "13",
    markup = helpers.colorize_text(service_icon, beautiful.fg_color),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "left"
}

-- name
local name = wibox.widget{
    font = beautiful.font_var .. "12",
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(service_name, beautiful.fg_color),
    valign = "center",
    align = "left"
}

-- animation :love:
local circle_animate = wibox.widget{
	widget = wibox.container.background,
	shape = gears.shape.rounded_bar,
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
            {
                icon,
                name,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(8)
            },
            margins = {left = dpi(20)},
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
    forced_width = dpi(167),
    forced_height = dpi(58),
    bg = beautiful.bg_2
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

  -- update information
  local function update_server()
	awful.spawn.easy_async_with_shell(
		[[
        amixer -D pulse get Capture toggle | tail -n 1 | awk '{print $6}' | tr -d '[]'
		]],
		function(stdout)
			if stdout:match("on") then
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
		end
	)
end

-- run once every startup/reload
update_server()

  -- buttons
  alright:buttons(gears.table.join(awful.button({}, 1, nil, function()
    awful.spawn("amixer -D pulse set Capture toggle", false)
    update_server()
end)))



return alright