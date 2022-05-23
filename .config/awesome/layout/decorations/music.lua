-- titlebar decorations for ncmpcpp
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local ruled = require("ruled")
local dpi = beautiful.xresources.apply_dpi


-- widgets
-- ~~~~~~~

-- album art
local album_art = wibox.widget{
    widget = wibox.widget.imagebox,
    clip_shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(60),
    forced_width = dpi(60),
    halign = "center",
    valign = "center",
    image = beautiful.images.album_art
}

-- song artist
local song_artist = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Unknown", beautiful.ext_light_fg or beautiful.fg_color),
    font = beautiful.font_var .. "10",
    align = "center",
    valign = "bottom"
}

-- song name
local song_name = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("None", beautiful.ext_light_fg or beautiful.fg_color),
    font = beautiful.font_var .. "Bold 11",
    align = "center",
    valign = "bottom"
}



-- buttons --

-- toggle button
local toggle_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "22",
    align = "center",
    valign = "center"
}

-- next button
local next_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.ext_light_fg or beautiful.fg_color .. "99"),
    font = beautiful.icon_var .. "20",
    align = "center",
    valign = "center"
}

-- prev button
local prev_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.ext_light_fg or beautiful.fg_color .. "99"),
    font = beautiful.icon_var .. "20",
    align = "center",
    valign = "center"
}



-- progressbar
local pbar = wibox.widget {
    widget = wibox.widget.progressbar,
    forced_height = dpi(4),
    color = beautiful.accent,
    background_color = beautiful.accent .. "4D",
    value = 50,
    max_value = 100,
    halign = "left",
    valign = "center",
}










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


playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, __, ___)
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
    song_name:set_markup_silently(helpers.colorize_text(title, beautiful.ext_light_fg or beautiful.fg_color))
	song_artist:set_markup_silently(helpers.colorize_text(artist, beautiful.ext_light_fg or beautiful.fg_color))
end)


playerctl:connect_signal("playback_status", function(_, playing, _)
	if playing then
        toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	else
        toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	end
end)

playerctl:connect_signal("position", function(_, current_pos, total_pos, player_name)
    pbar.value = (current_pos / total_pos) * 100

end)






-- effects
--~~~~~~~~

prev_button:connect_signal("mouse::enter", function ()
    prev_button.markup = helpers.colorize_text("", beautiful.accent)
end)
prev_button:connect_signal("mouse::leave", function ()
    prev_button.opacity = 1
    prev_button.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
end)

prev_button:connect_signal("button::press", function ()
    prev_button.markup = helpers.colorize_text("", beautiful.accent_2)
end)
prev_button:connect_signal("button::release", function ()
    prev_button.markup = helpers.colorize_text("", beautiful.accent)
end)


next_button:connect_signal("mouse::enter", function ()
    next_button.markup = helpers.colorize_text("", beautiful.accent)
end)
next_button:connect_signal("mouse::leave", function ()
    next_button.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
end)

next_button:connect_signal("button::press", function ()
    next_button.markup = helpers.colorize_text("", beautiful.accent_2)
end)
next_button:connect_signal("button::release", function ()
    next_button.markup = helpers.colorize_text("", beautiful.accent)
end)







local music_init = function (c)

    -- Hide default titlebar
    -- awful.titlebar.hide(c)



        -- bottom
        awful.titlebar(c, { position = "bottom", size = dpi(80), bg = beautiful.ext_light_bg_2 or beautiful.bg_2 }):setup {
            pbar,
            {
                {
                    {
                        album_art,
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        nil,
                        {
                            song_name,
                            song_artist,
                            layout = wibox.layout.fixed.vertical,
                            spacing = dpi(2)
                        },
                        expand = "none",
                        layout = wibox.layout.align.vertical
                    },
                    {
                        prev_button,
                        toggle_button,
                        next_button,
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(8)
                    },
                    layout = wibox.layout.align.horizontal,
                    expand = "none"
                },
                margins = dpi(12),
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(0)
        }




    c.custom_decoration = { top = true, left = true, bottom = true }



end

-- Add the titlebar whenever a new music client is spawned
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id = "music",
        rule = {instance = "music"},
        callback = music_init
    }
end)

