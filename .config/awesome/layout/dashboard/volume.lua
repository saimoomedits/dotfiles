-- a singular volume bar
-- ~~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local gears         = require("gears")
local wibox         = require("wibox")
local awful			= require("awful")
local beautiful     = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local helpers 		= require("helpers")
local rubato		= require("mods.rubato")



-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget({
	font 	= beautiful.icon_var .. "16",
	markup = helpers.colorize_text("", beautiful.ext_light_fg or beautiful.accent_3),
	align 	= "left",
	valign 	= "center",
	widget 	= wibox.widget.textbox,
})

-- progress bar
local bar = wibox.widget{
	color				= beautiful.accent,
	bar_shape			= gears.shape.rounded_bar,
	background_color	= beautiful.bg_color .. "00",
	shape				= gears.shape.rounded_bar,
    value               = 25,
    forced_height       = dpi(6),
    forced_width        = dpi(310),
	max_value 			= 100,
    widget              = wibox.widget.progressbar,
}

local bar_bg = wibox.widget{
	nil,
	{
		{
	   		forced_height  = dpi(6),
            forced_width   = dpi(310),
			bg 			= beautiful.ext_light_bg_3 or beautiful.bg_2,
			shape		= gears.shape.rounded_bar,
    		widget        = wibox.container.background,
		},
		margins = dpi(16),
		widget = wibox.container.margin
	},
	layout = wibox.layout.align.horizontal,
	expand = "none"
}

  local animation = rubato.timed{
      pos = 25,
      rate = 60,
      intro = 0.02,
      duration = 0.08,
      awestore_compat = true,
      subscribed = function(pos)
		bar.value = pos
      end
  }


awesome.connect_signal("signal::volume", function(value, muted)
		animation:set(value)

		if muted then
			bar.color = beautiful.red_color
			icon.markup = helpers.colorize_text("", beautiful.bg_color .. "66")
		else
			bar.color = beautiful.accent
			icon.markup = helpers.colorize_text("", beautiful.ext_light_fg or beautiful.accent_3)
		end

		if value <= 10 then
			icon.visible = false
		else
			icon.visible = true
		end

end)


bar:buttons(gears.table.join(
    	awful.button( {}, 4, function () 
			awful.spawn.with_shell("amixer -D pulse sset Master 5%+", false)
		end),

    	awful.button( {}, 5, function () 
			awful.spawn.with_shell("amixer -D pulse sset Master 5%-", false)
		end)
	)
)

return wibox.widget{
		bar_bg,
        bar,
		{
			icon,
			left = dpi(16),
			widget = wibox.container.margin
		},
		layout = wibox.layout.stack
}