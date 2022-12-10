-- minimal music widget
-- inspired by r/unixporn posts
-------------------------------
-- Copyleft © 2022 Saimoomedits



-- requirements
---------------
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")



-- widgets
----------


-- gradientee music album art
-- - - - - - - - - - - - - - 
local music_art_filter = wibox.widget({
	{
		bg = {
				type = "linear",
				from = { 0, 0 },
				to = { 0, 85},
				stops = { 
					{ 0, beautiful.bg_2 .. "b3" }, 
					{ 1, beautiful.bg_2 } 
				},
			},
		forced_height = dpi(85),
		forced_width = dpi(85),
		widget = wibox.container.background,
	},
	direction = "east",
	widget = wibox.container.rotate,
})



-- the different music elements
-- - - - - - - - - - - - - - - 

-- album art
local album_art = wibox.widget{
    widget = wibox.widget.imagebox,
 --   clip_shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(85),
    forced_width = dpi(85),
    image = beautiful.images.album_art,
    border_color = beautiful.fg_color .. "33",
    border_width = dpi(1)
}

-- playing yeah?
local playing_or = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Now playing", beautiful.fg_color .. "99"),
    font = beautiful.font_var .. "10",
    align = "left",
    valign = "center"
}

-- song artist
local song_artist = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Unknown", beautiful.fg_color .. "99"),
    font = beautiful.font_var .. "11",
    align = "left",
    valign = "center"
}

-- song name
local song_name = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("None", beautiful.fg_color),
    font = beautiful.font_var .. "Bold 12",
    align = "left",
    valign = "center"
}

---------------------------------------- eo.Widgets



-- buttons
----------

-- toggle button
local toggle_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "16",
    align = "right",
    valign = "center"
}

-- next button
local next_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "16",
    align = "right",
    valign = "center"
}

-- prev button
local prev_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "16",
    align = "right",
    valign = "center"
}

local music_bar = wibox.widget({
	max_value = 100,
	value = 0,
	background_color = beautiful.fg_color .. "26",
	-- shape = gears.shape.rounded_bar,
	color = beautiful.fg_color,
	forced_height = dpi(6),
	forced_width = dpi(100),
	widget = wibox.widget.progressbar,
})


--------------------------------- eo.buttons


-- update widgets
-----------------

-- playerctl module - bling
local playerctl = require("mods.bling").signal.playerctl.lib()


-- commands for different actions
local toggle_command = function() playerctl:play_pause() end
local prev_command = function() playerctl:previous() end
local next_command = function() playerctl:next() end


-- make it functional!
toggle_button:buttons(gears.table.join(
    awful.button({}, 1, function() toggle_command() end)))

next_button:buttons(gears.table.join(
    awful.button({}, 1, function() next_command() end)))

prev_button:buttons(gears.table.join(
    awful.button({}, 1, function() prev_command() end)))



-- update widgets
-----------------

-- title, artist, album art
playerctl:connect_signal("metadata", function(_, title, artist, album_path, __, ___, ____)
	if title == "" then
		title = "None"
	end
	if artist == "" then
		artist = "Unknown"
	end
	if album_path == "" then
		album_path = beautiful.images.album_art
	end

	album_art:set_image(gears.surface.load_uncached(album_path))
    song_name:set_markup_silently(helpers.colorize_text(title, beautiful.fg_color))
	song_artist:set_markup_silently(helpers.colorize_text(artist, beautiful.fg_color))


end)

-- playing/paused/{N/A}
playerctl:connect_signal("playback_status", function(_, playing, __)
	if playing then
        toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	else
        toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	end
end)

-- time elapsed
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
		music_bar.value = (interval_sec / length_sec) * 100
		music_length = length_sec
end)









-- mainbox
-- too messy
------------
local music_box =  wibox.widget {
	{
				{
					album_art,
					music_art_filter,
					layout = wibox.layout.stack,
				},
				{
					{
						{
							playing_or,
							nil,
                    		{	
                     	 	  	{
                     	   			step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                     	     		widget = wibox.container.scroll.horizontal,
                     	       		forced_width = dpi(250),
                     	      		speed = 30,
	                    	    	song_name,
  	                  	    	},
    	                	    {
      	              	        	step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        	            	        widget = wibox.container.scroll.horizontal,
          	          	        	forced_width = dpi(250),
            	        	        speed = 30,
              	      	        	song_artist,
                	    	    },
                  	  	    	spacing = dpi(2),
                    		    layout = wibox.layout.fixed.vertical,
	                    	},
  	               	   		layout = wibox.layout.align.vertical,
    	            		expand = "none"
      	          		},
  	              layout = wibox.layout.fixed.horizontal,
    	            spacing = dpi(10)
									},
									widget = wibox.container.margin,
									margins = {
										left = 20,
										right = 20,
										bottom = 20,
										top = 20
									}
      	      },
        layout = wibox.layout.stack,
    },
    widget = wibox.container.background,
    forced_height = dpi(150),
    bg = beautiful.bg_3 .. "99",
    border_color = beautiful.fg_color .. "33",
    shape = helpers.rrect(beautiful.rounded)
}


-- finalize
-----------
return wibox.widget {
	{
		music_box,
		{
        	{
        	    music_bar,
        	    direction = "east",
		    	widget = wibox.container.rotate,
        	    forced_width = dpi(2)
        	},
        	layout = wibox.layout.fixed.horizontal,
        	spacing = dpi(20),
		},
		{
			{
				{
					nil,
 	  			     {
 	    		       	prev_button,
 	     		     	toggle_button,
 	      		  		next_button,
 	       		    layout = wibox.layout.fixed.vertical,
 	        			spacing = dpi(22)
		    		},	
					layout = wibox.layout.align.vertical,
					expand = "none"
				},
				left = 18, right = 18,
				widget = wibox.container.margin
			},
			bg = beautiful.bg_2,
			widget = wibox.container.background,
		},
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(0)
	},
	widget = wibox.container.background,
	bg = beautiful.bg_2,
	shape = helpers.rrect(beautiful.rounded)
}


-- eof
------


