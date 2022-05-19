-- bright info
--------------

-- ("signal::brightness"), function(value(int))



local awful = require("awful")

local brightness_subscribe_script = [[
   bash -c "
   while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq) do echo; done
"]]

local brightness_script = [[
   sh -c "
   brightnessctl i | grep -oP '\(\K[^%\)]+'
"]]

local emit_brightness_info = function()
    awful.spawn.with_line_callback(brightness_script, {
        stdout = function(line)
            percentage = math.floor(tonumber(line))
            awesome.emit_signal("signal::brightness", percentage)
        end
    })
end

emit_brightness_info()

awful.spawn.easy_async_with_shell("ps x | grep \"inotifywait -e modify /sys/class/backlight\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    awful.spawn.with_line_callback(brightness_subscribe_script, {
        stdout = function(_)
            emit_brightness_info()
        end
    })
end)