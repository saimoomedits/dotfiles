-- mpd info
-- emits mpd info

local awful = require("awful")

local function emit_info()
    awful.spawn.easy_async_with_shell("sh -c 'mpc -f ARTIST@%artist%@TITLE@%title%@FILE@%file%@'",
        function(stdout)
            local artist = stdout:match('^ARTIST@(.*)@TITLE')
            local title = stdout:match('@TITLE@(.*)@FILE')
            local status = stdout:match('\n%[(.*)%]')

            if not artist or artist == "" then
              artist = "Artist"
            end
            if not title or title == "" then
              title = stdout:match('@FILE@(.*)@')
              if not title or title == "" then
                  title = "Song"
              end
            end

            local paused
            if status == "playing" then
                paused = false
            else
                paused = true
            end


            awesome.emit_signal("signal::mpd", artist, title, paused)
        end
    )
end

-- Run once to initialize widgets
emit_info()

-- Sleeps until mpd changes state (pause/play/next/prev)
local mpd_script = [[
  sh -c '
    mpc idleloop player
  ']]

-- Kill old mpc idleloop player process
awful.spawn.easy_async_with_shell("ps x | grep \"mpc idleloop player\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Emit song info with each line printed
    awful.spawn.with_line_callback(mpd_script, {
        stdout = function()
            emit_info()
        end
    })
end)


local function mpd_is_run()
    local update_interval = 5
    local the_cmd = [[
      bash -c "
      pidof mpd
      "]]

      awful.widget.watch(the_cmd, update_interval, function(_, stdout)
        local output = stdout
        local mpd_server_status = true

        if output == "" then
            mpd_server_status = false
        end

        awesome.emit_signal("signal::mpd_server", mpd_server_status)
    end)
end

mpd_is_run()
----------------------------------------------------------