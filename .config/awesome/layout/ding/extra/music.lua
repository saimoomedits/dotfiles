-- music notification
-- ~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local naughty   = require("naughty")
local playerctl = require("mods.bling").signal.playerctl.lib()
local beautiful = require("beautiful")


-- misc/vars
-- ~~~~~~~~~

local notif

-- buttons
local previous_button   = naughty.action {name = "previous"}
local next_button       = naughty.action {name = "next"}

-- actual buttons
previous_button:connect_signal('invoked', function()
    playerctl:previous()
end)

next_button:connect_signal('invoked', function()
    playerctl:next()
end)



-- init
-- ~~~~

-- notification
playerctl:connect_signal("metadata", function(_, title, artist, album_path, __, new, ___)


    -- destroy notif when not needed
    -- if dash.visible or (client.focus and (client.focus.instance == "music" or client.focus.class == "music")) then
    if control_c.visible or (client.focus and (client.focus.instance == "music" or client.focus.class == "music")) then
        if notif then
            notif:destroy()
        end

        else

        -- if album art is not found, fallback to default
        if album_path == "" then
            album_path = beautiful.music_art_fallback
        end

        -- send notification when a new song is played
    	if new then
    		naughty.notify({
    			app_name    = "Music",
    			title       = title or "Song",
    			text        = "~ " .. artist,
                actions     = {
                    previous_button,
                    next_button
                },
    			image       = album_path,
    		},
        notif)
    	end
    end

end)