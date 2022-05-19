-- a short popup for service info
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local helpers       = require("helpers")
local dpi           = beautiful.xresources.apply_dpi






-- the popup
-- ~~~~~~~~~


local first_time = true


local pop = awful.popup {
	type    = "tooltip",
    widget = wibox.container.background,
	screen  = screen.primary,
	height  = dpi(70),
    maximum_width = dpi(600),
	shape   = helpers.rrect(beautiful.rounded),
	bg      = beautiful.accent,
    ontop = true,
	visible = false,
    placement = function (c) awful.placement.top(c, {margins = {top = beautiful.useless_gap * 2}}) end
}


-- icon
local w_icon = wibox.widget({
	font 	= beautiful.icon_var .. "14",
	align 	= "center",
    markup  = helpers.colorize_text("E", beautiful.bg_color),
	valign 	= "center",
	widget 	= wibox.widget.textbox,
})

-- value
local w_txt = wibox.widget({
	font 	= beautiful.font_var .. "12",
	align 	= "left",
    markup  = helpers.colorize_text("task", beautiful.bg_color),
	valign 	= "center",
	widget 	= wibox.widget.textbox,
})


-- setup
pop:setup {
    {
        w_icon,
        w_txt,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(8)
    },
    margins = {top = dpi(10), bottom = dpi(10), right = dpi(25), left = dpi(25)},
    widget = wibox.container.margin
}

-- tuemout
local timeout = gears.timer({
	autostart   = true,
	call_now	= false,
	single_shot = true,
	timeout     = 2,
	callback    = function()
		        pop.visible = false
	end,
})

-- toggle function
local function toggle_pop()
	if pop.visible then
		timeout:again()
	else
		pop.visible = true
		timeout:start()
	end
end


-- return output
return function (icon, text)


	if first_time then
		first_time = false
	else
		w_icon.markup = helpers.colorize_text(icon, beautiful.bg_color)
		w_txt.markup = helpers.colorize_text(text, beautiful.bg_color)
		toggle_pop()
	end

end