-- mpd song notification
-- yes sir

local notifications = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

notifications.mpd = {}

local notif
local first_time = true
local timeout = 2

local old_artist, old_song
local send_mpd_notif = function (artist, song, paused)
    if first_time then
        first_time = false
    else
        if  paused or (dash and dash.visible)
            or (client.focus and (client.focus.instance == "music" or client.focus.class == "music")) then
            if notif then
                notif:destroy()
            end
        else
            if artist ~= old_artist and song ~=old_song then
                notif = notifications.notify(
                    {
                        title = "Now playing",
                        message = "<b>"..song.."</b> by <b>"..artist.."</b>",
                        icon = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/music.png", beautiful.fg_color .. "61"),
                        timeout = timeout,
                        app_name = "mpd"
                    },
                    notif)
            end
        end
        old_artist = artist
        old_song = song
    end
end

-- Allow dynamically toggling mpd notifications
notifications.mpd.enable = function()
    awesome.connect_signal("signal::mpd", send_mpd_notif)
    notifications.mpd.enabled = true
end
notifications.mpd.disable = function()
    awesome.disconnect_signal("signal::mpd", send_mpd_notif)
    notifications.mpd.enabled = false
end
notifications.mpd.toggle = function()
    if notifications.mpd.enabled then
        notifications.mpd.disable()
    else
        notifications.mpd.enable()
    end
end

-- Start with mpd notifications enabled
notifications.mpd.enable()
