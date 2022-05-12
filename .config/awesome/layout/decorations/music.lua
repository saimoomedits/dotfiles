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
local rubato = require("mods.rubato")


-- widgets
-- ~~~~~~~

-- album art
local album_art = wibox.widget{
    widget = wibox.widget.imagebox,
    clip_shape = helpers.rrect(beautiful.rounded),
    forced_height = dpi(220),
    forced_width = dpi(220),
    halign = "center",
    valign = "center",
    image = beautiful.images.album_art
}

-- song artist
local song_artist = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("Unknown", beautiful.ext_light_fg or beautiful.fg_color),
    font = beautiful.font_var .. "13",
    align = "center",
    valign = "center"
}

-- song name
local song_name = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("None", beautiful.ext_light_fg or beautiful.fg_color),
    font = beautiful.font_var .. "Bold 13",
    align = "center",
    valign = "center"
}



-- buttons --

-- toggle button
local toggle_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.black_color),
    font = beautiful.icon_var .. "22",
    align = "center",
    valign = "center"
}

-- next button
local next_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.ext_light_fg or beautiful.fg_color),
    font = beautiful.icon_var .. "20",
    align = "center",
    valign = "center"
}

-- prev button
local prev_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.ext_light_fg or beautiful.fg_color),
    font = beautiful.icon_var .. "20",
    align = "center",
    valign = "center"
}


local button_creator = require("helpers.widgets.create_button")
local create_toggle_button = button_creator(toggle_button, beautiful.accent, beautiful.accent_3,
    {top = dpi(6), bottom = dpi(6), left = dpi(40), right = dpi(40) }, 0, nil)



-- progressbar
local pbar = wibox.widget {
    widget = wibox.widget.progressbar,
    bar_shape = gears.shape.rounded_bar,
    forced_height = dpi(6),
    color = beautiful.accent,
    background_color = beautiful.accent .. "4D",
    value = 50,
    max_value = 100,
    halign = "left",
    valign = "center",
}



-- window buttons --
local close_btn = wibox.widget{
    widget = wibox.container.background,
    bg = beautiful.accent_3,
    forced_height = dpi(8),
    shape = gears.shape.rounded_bar
}


-- close button animations
local animation_button_opacity = rubato.timed{
    pos = 1,
    rate = 60,
    intro = 0.06,
    duration = 0.2,
    awestore_compat = true,
    subscribed = function(pos)
		  close_btn.opacity = pos
    end
}


-- animations for hover
close_btn:connect_signal("mouse::enter", function()
    animation_button_opacity:set(0.7)
end)

close_btn:connect_signal("mouse::leave", function()
    animation_button_opacity:set(1)
end)



-- animations for press
close_btn:connect_signal("button::press", function()
        animation_button_opacity:set(0.3)
end)

close_btn:connect_signal("button::release", function()
        animation_button_opacity:set(0.7)
end)





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
        toggle_button.markup = helpers.colorize_text("", beautiful.black_color)
	else
        toggle_button.markup = helpers.colorize_text("", beautiful.black_color)
	end
end)

playerctl:connect_signal("position", function(_, current_pos, total_pos, player_name)
    pbar.value = (current_pos / total_pos) * 100

end)





local music_init = function (c)

    -- Hide default titlebar
    awful.titlebar.hide(c)



    -- close button
    close_btn:buttons(gears.table.join(
    awful.button({ }, 1, function () c:kill() end),
    awful.button({ }, 3, function () awful.client.floating.toggle(c) end)
    ))


    -- movement
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
    }

        -- bottom
        awful.titlebar(c, { position = "left", size = dpi(300), bg = beautiful.ext_light_bg_2 or beautiful.bg_2 }):setup {
            {
                helpers.vertical_pad(dpi(60)),
                {
                    album_art,
                    {
                        {
                            {
                                song_name,
                                song_artist,
                                spacing = dpi(5),
                                layout = wibox.layout.fixed.vertical
                            },
                            {
                                pbar,
                                margins = {left = dpi(15), right = dpi(15)},
                                widget = wibox.container.margin
                            },
                            spacing = dpi(22),
                            layout = wibox.layout.fixed.vertical
                        },
                        margins = {left = dpi(15), right = dpi(10)},
                        widget = wibox.container.margin
                    },
                    spacing = dpi(30),
                    layout = wibox.layout.fixed.vertical
                },
                layout = wibox.layout.fixed.vertical
            },
            nil,
            {
                {
                    {
                        nil,
                        {
                            prev_button,
                            create_toggle_button,
                            next_button,
                            layout = wibox.layout.fixed.horizontal,
                            spacing = dpi(14)
                        },
                        layout = wibox.layout.align.horizontal,
                        expand = "none"
                    },
                    bg = "alpha",
                    widget = wibox.container.background,
                    forced_width = dpi(300),
                    forced_height = dpi(60),
                },
                helpers.vertical_pad(dpi(20)),
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(0)
            },
            layout = wibox.layout.align.vertical,
            expand = "none",
            buttons = buttons
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

