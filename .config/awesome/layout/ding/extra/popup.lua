-- popup notif --
-- ~~~~~~~~~~~ --

-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local helpers       = require("helpers")
local dpi           = beautiful.xresources.apply_dpi


-- widgets themselves
-- ~~~~~~~~~~~~~~~~~~

-- icon
local icon = wibox.widget({
	font 	= beautiful.icon_var .. "16",
	align 	= "center",
	valign 	= "center",
	widget 	= wibox.widget.textbox,
})

-- progress bar
local bar = wibox.widget{
    bar_color           = beautiful.fg_color .. "33",
    handle_color        = beautiful.blue_color,
    handle_shape        = gears.shape.circle,
	bar_active_color    = beautiful.blue_color,
	bar_height			= dpi(4),
	bar_width			= dpi(10),
    value               = 25,
	minimum				= 0,
	maximum 			= 100,
    widget              = wibox.widget.slider,
}



-- actual popup
local pop = wibox({
	type    = "popup",
	screen  = screen.primary,
	height  = dpi(180),
	width   = dpi(55),
	shape   = helpers.rrect(beautiful.rounded_wids),
	bg      = beautiful.transparent,
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
	timeout     = 2.4,
	single_shot = true,
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
			{
				bar,
  	      		forced_height = dpi(100),
  		      	forced_width  = dpi(5),
  		      	direction     = 'east',
  	      		widget        = wibox.container.rotate,
			},
			margins = dpi(15),
			layout = wibox.container.margin
		},
		{
			icon,
			margins = {bottom = dpi(10)},
			widget = wibox.container.margin
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.vertical
})





-- update widgets accordingly
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- volume
local first_V = true
awesome.connect_signal("signal::volume", function(value, muted)
	if first_V or control_c.visible then
		first_V = false
	else
		icon.markup = "<span foreground='" .. beautiful.accent .. "'></span>"
		bar.value = value

		if muted or value == 0  then
			bar.handle_color = beautiful.red_color
			bar.bar_active_color = beautiful.red_color
			icon.markup = "<span foreground='" .. beautiful.red_color .. "'></span>"
		else
			bar.handle_color = beautiful.accent
			bar.bar_active_color = beautiful.accent
		end

		toggle_pop()
	end
end)


-- brightness
local first_B = true
awesome.connect_signal("signal::brightness", function(value)
	if first_B or control_c.visible then
		first_B = false
	else
		icon.markup = "<span foreground='" .. beautiful.accent .. "'></span>"
		bar.handle_color = beautiful.accent
		bar.bar_active_color = beautiful.accent
		bar.value = value
		toggle_pop()
	end
end)
