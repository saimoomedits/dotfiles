-- minimal music widget
-- ~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")



-- widgets
-- ~~~~~~~


-- Song info
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- album art
local album_art = wibox.widget{
    widget = wibox.widget.imagebox,
    clip_shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(85),
    forced_width = dpi(85),
    image = beautiful.images.album_art,
    border_color = beautiful.fg_color .. "33",
    border_width = dpi(1)
}


-- song artist
local song_artist = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Unknown", beautiful.fg_color),
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

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EOF Song info



-- buttons
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- toggle button
local toggle_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "22",
    align = "right",
    valign = "center"
}

-- next button
local next_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "18",
    align = "right",
    valign = "center"
}

-- prev button
local prev_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "18",
    align = "right",
    valign = "center"
}

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EOF buttons


-- update widgets
-- ~~~~~~~~~~~~~~

local playerctl = require("mods.bling").signal.playerctl.lib()


local toggle_command = function() playerctl:play_pause() end
local prev_command = function() playerctl:previous() end
local next_command = function() playerctl:next() end

toggle_button:buttons(gears.table.join(
    awful.button({}, 1, function() toggle_command() end)))

next_button:buttons(gears.table.join(
    awful.button({}, 1, function() next_command() end)))

prev_button:buttons(gears.table.join(
    awful.button({}, 1, function() prev_command() end)))


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

playerctl:connect_signal("playback_status", function(_, playing, __)
	if playing then
        toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	else
        toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	end
end)









-- ~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~
return wibox.widget {
    {
        {
            album_art,
            {
                {
                    nil,
                    {
                        {
                            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                            widget = wibox.container.scroll.horizontal,
                            forced_width = dpi(158),
                            speed = 30,
                            song_name,
                        },
                        {
                            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                            widget = wibox.container.scroll.horizontal,
                            forced_width = dpi(158),
                            speed = 30,
                            song_artist,
                        },
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical,
                    },
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                {
                    prev_button,
                    toggle_button,
                    next_button,
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(6)
                },
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10)
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(10)
        },
        margins = dpi(12),
        widget = wibox.container.margin
    },
    widget = wibox.container.background,
    forced_height = dpi(110),
    bg = beautiful.bg_3 .. "99",
    border_color = beautiful.fg_color .. "33",
    shape = helpers.rrect(beautiful.rounded)
}
-- ~~~~~~~~~~~~~~~~~~