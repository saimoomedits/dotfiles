-- emits bluetooth status
-- listen, i know this is dumb but.. yeah.
------------------------------------------

-- ("signal::bluetooth"), function(status(bool), service_status(bool))


-- requirements
local awful = require("awful")

-- update interval
local update_interval = 10


--  import bluetooth info
local cmd = [[
  bash -c "
  bluetoothctl show | grep "Powered:" | awk '{ print $2 }'
  "
]]

  awful.widget.watch(cmd, update_interval, function(_, stdout)
    local output = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
    local bluetooth_active = true
    local bluetooth_runnding_service

    -- lets see if bluetooth.service is enabled
    awful.spawn.easy_async_with_shell("bash -c 'pgrep bluetooth'", function (lets_see)
        if lets_see == "" then
            bluetooth_runnding_service = false
        else
            bluetooth_runnding_service = true
        end
    end)

    -- set output as above info
    if output == "no" then 
        bluetooth_active = bluetooth_runnding_service
    end

    -- emit (powered on?) , (is the proceess running?)
    awesome.emit_signal("signal::bluetooth", bluetooth_active, bluetooth_runnding_service)
end)

