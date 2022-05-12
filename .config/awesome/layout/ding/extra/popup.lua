-- popup notif
-- ~~~~~~~~~~~
-- uses rubato for smooth animations

-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local rubato		= require("mods.rubato")
local dpi           = beautiful.xresources.apply_dpi


-- widgets themselves
-- ~~~~~~~~~~~~~~~~~~

-- icon
local icon = wibox.widget({
	font 	= beautiful.icon_var .. "16",
	align 	= "center",
	valign 	= "bottom",
	widget 	= wibox.widget.textbox,
})


-- progress bar
local bar = wibox.widget{
	color				= beautiful.accent,
	bar_shape			= gears.shape.rounded_bar,
	background_color	= beautiful.bg_color .. "00",
	shape				= gears.shape.rounded_bar,
    value               = 25,
	max_value 			= 100,
    widget              = wibox.widget.progressbar,
}

local bar_bg = wibox.widget{
	nil,
	{
		{
	   		forced_width  = dpi(6),
			bg 			= beautiful.accent_2,
			shape		= gears.shape.rounded_bar,
    		widget        = wibox.container.background,
		},
		margins = dpi(16),
		widget = wibox.container.margin
	},
	layout = wibox.layout.align.horizontal,
	expand = "none"
}




-- button
local button = wibox.widget{
	widget = wibox.widget.textbox,
	markup = "S",
	font = beautiful.icon_var .. "15",
	align = "center",
	valign = "center"
}

local circle_animate = wibox.widget{
	widget = wibox.container.background,
	shape = gears.shape.circle,
	bg = beautiful.accent,
	forced_width = 0,
	forced_height = 0,
}

local button_final = wibox.widget{
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
			button,
			widget = wibox.container.margin,
			margins = dpi(10)
		},
		layout = wibox.layout.stack
	},
	widget = wibox.container.background,
	shape = gears.shape.circle,
	bg = beautiful.ext_light_bg_2 or beautiful.bg_3,
}

button_final:buttons(gears.table.join(
    	awful.button( {}, 1, function () awful.spawn.with_shell("amixer -D pulse sset Master toggle", false) end)
	)
)



-- actual popup
local pop = wibox({
	type    = "popup_menu",
	screen  = screen.primary,
	height  = dpi(220),
	width   = dpi(55),
	shape   = gears.shape.rounded_bar,
	bg      = beautiful.ext_light_bg or beautiful.bg_color,
	halign  = "center",
	valign  = "center",
	ontop   = true,
	visible = false,
})

-- placement
awful.placement.right(pop, {margins = {right = beautiful.useless_gap * 2}})

-- tuemout
local timeout = gears.timer({
	autostart   = true,
	timeout     = 2,
	callback    = function()
		        pop.visible = false
	end,
})

local function toggle_pop()
	if pop.visible then
		timeout:again()
	else
		pop.visible = true
		timeout:start()
	end
end

pop:setup({
	{
		button_final,
		margins = dpi(6),
		widget = wibox.container.margin
	},
	{
		bar_bg,
		{
			{
				bar,
  	      		forced_height = dpi(145),
  		      	forced_width  = dpi(50),
  		      	direction     = 'east',
  	      		widget        = wibox.container.rotate,
			},
			margins = dpi(6),
			layout = wibox.container.margin
		},
		{
			icon,
			bottom = dpi(16),
			widget = wibox.container.margin
		},
		layout = wibox.layout.stack
	},
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(8)
})



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

  local animation_button = rubato.timed{
      pos = 0,
      rate = 60,
      intro = 0.02,
      duration = 0.08,
      awestore_compat = true,
      subscribed = function(pos)
		circle_animate.forced_width = pos
		circle_animate.forced_height = pos
      end
  }





-- update widgets accordingly
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- volume
local first_V = true
awesome.connect_signal("signal::volume", function(value, muted)
	if first_V or dash.visible then
		first_V = false
	else
		button.markup = "<span foreground='" .. (beautiful.ext_light_fg or beautiful.accent) .. "'></span>"
		icon.markup = "<span foreground='" .. beautiful.accent_3 .. "'></span>"
		animation:set(value)

		if muted   then
			button.markup = "<span foreground='" .. beautiful.bg_color .. "'></span>"
			animation_button:set(dpi(40))
		else
			animation_button:set(dpi(0))
			bar.handle_color = beautiful.accent
			bar.bar_active_color = beautiful.accent
		end

		if value <= 25 then
			icon.visible = false
		else
			icon.visible = true
		end

		toggle_pop()
	end
end)


-- brightness
local first_B = true
awesome.connect_signal("signal::brightness", function(value)
	if first_B then
		first_B = false
	else
		icon.markup = "<span foreground='" .. beautiful.accent_3 .. "'></span>"
		animation:set(value)
		toggle_pop()

		button.markup = "<span foreground='" .. (beautiful.ext_light_fg or beautiful.accent) .. "'></span>"
		button_final.bg =  beautiful.ext_light_bg_2 or beautiful.bg_3

		if value <= 25 then
			icon.visible = false
		else
			icon.visible = true
		end
	end

end)