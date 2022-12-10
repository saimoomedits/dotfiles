-- profile widget
-----------------
-- Copyleft © 2022 Saimoomedits


-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")



-- widgets
----------

-- mask overlay
local overlayed = wibox.widget({
	{
		bg = beautiful.bg_3 .. 'ef',
		forced_height = dpi(100),
		forced_width = dpi(100),
		widget = wibox.container.background,
	},
	direction = "east",
	widget = wibox.container.rotate,
})

-- image
local profile_image = wibox.widget {
    {
        image = beautiful.images.profile,
    	shape = helpers.rrect(beautiful.rounded),
        widget = wibox.widget.imagebox
    },
    widget = wibox.container.background,
    forced_width = dpi(100),
    forced_height = dpi(100),
    shape = helpers.rrect(beautiful.rounded),
}

-- username
local username = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(user_likes.username, beautiful.fg_color),
    font = beautiful.font_var .. "Medium 13",
    align = "left",
    valign = "center"
}

-- description/host
local desc = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(user_likes.userdesc, beautiful.fg_color .. "99"),
    font = beautiful.font_var .. "10",
    align = "left",
    valign = "center"
}


-- finalize
-----------
return wibox.widget{
	{
		{
				profile_image,
				overlayed,
				layout = wibox.layout.stack
		},
		{
    	{
			{
    			widget = wibox.widget.textbox,
    			markup = helpers.colorize_text("Howdy!", beautiful.fg_color .. "33"),
    			font = beautiful.font_var .. "11",
    			align = "left",
    			valign = "center"
			},
			nil,
        	{
          	  	username,
				desc,
           		layout = wibox.layout.fixed.vertical,
            	spacing = dpi(2)
        	},
        	layout = wibox.layout.align.vertical,
        	expand = "none"
		},
		widget = wibox.container.margin,
		margins = dpi(16)
    	},
		layout = wibox.layout.stack,
	},
	widget = wibox.container.background,
	shape = helpers.rrect(dpi(beautiful.rounded)),
	forced_width = dpi(160),
	forced_height = dpi(160)
}

-- eof
------