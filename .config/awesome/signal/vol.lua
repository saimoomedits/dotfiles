-- i know this is the worst thing ever.
-- but i couldn't think of any other way for now :skull:
-- it should work... right...?
--------------------------------------------------------
-- Copyleft © 2022 Saimoomedits

local awful = require("awful")

volume_muted = false

function update_value_of_volume_mute()
    awful.spawn.easy_async_with_shell("amixer -D pulse get Master | tail -n 1 | awk '{print $6}' | tr -d '[%]'", function (stdout)
        stdout = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
        if stdout == "on" then
            volume_muted = false
        elseif stdout == "off" then
            volume_muted = true
        end
        awesome.emit_signal("volume::muted", volume_muted)
    end)
end

function update_value_of_volume()
    awful.spawn.easy_async_with_shell("amixer -D pulse get Master | tail -n 1 | awk '{print $5}' | tr -d '[%]'", function (stdout)
        local value = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
        awesome.emit_signal("volume::value", value)
    end)
end

update_value_of_volume()
update_value_of_volume_mute()


function updateAllVolumeSignals() 
    update_value_of_volume()
    update_value_of_volume_mute()
end