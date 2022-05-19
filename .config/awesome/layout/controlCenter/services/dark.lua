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

local service_name = "Dark"
local service_icon = ""

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
                spacing = dpi(8)
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






awful.spawn.easy_async_with_shell("sed -n 16p $HOME/.config/awesome/theme/ui_vars.lua | awk '{print $3}' | tr -d '\",' ", function (stdout)
    local output = string.gsub(stdout, '^%s*(.-)%s*$', '%1')


    local dark_enabled = false

    local update_things = function ()
        if dark_enabled then
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

    if output == "dark" then
        dark_enabled =  true
    else
        dark_enabled = false
    end

    update_things()


    alright:buttons(gears.table.join(
            awful.button( {}, 1, function ()
                   if dark_enabled then
                       awful.spawn.with_shell("sed -i '16s/.*/color_scheme        = \"light\",/g' $HOME/.config/awesome/theme/ui_vars.lua", false)
                       awesome.restart()
                   else
                       awful.spawn.with_shell("sed -i '16s/.*/color_scheme        = \"dark\",/g' $HOME/.config/awesome/theme/ui_vars.lua", false)
                       awesome.restart()
                   end
               end)
    	)
    )


end)





return alright