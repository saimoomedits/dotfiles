-- Mic button/widget
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

local service_name = "Mic"
local service_icon = ""

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
    font = beautiful.font_var .. "12",
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
	forced_width = 110,
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
  local function update_server(send_notif)
	awful.spawn.easy_async_with_shell(
		[[
        amixer -D pulse get Capture toggle | tail -n 1 | awk '{print $6}' | tr -d '[]'
		]],
		function(stdout)
			if stdout:match("on") then
                icon.markup = helpers.colorize_text(service_icon, beautiful.bg_color)
                name.markup = helpers.colorize_text(service_name, beautiful.bg_color)
                animation_button_opacity:set(1)

                if send_notif then
                    require("layout.ding.extra.short")("","Microphone enabled")
                end
			else
                icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color)
                name.markup = helpers.colorize_text(service_name, beautiful.fg_color)
                animation_button_opacity:set(0)

                if send_notif then
                    require("layout.ding.extra.short")("","Microphone disabled")
                end
			end
		end
	)
end

-- run once every startup/reload
update_server()

  -- buttons
  alright:buttons(gears.table.join(awful.button({}, 1, nil, function()
    awful.spawn("amixer -D pulse set Capture toggle", false)
    update_server(true)
end)))



return alright