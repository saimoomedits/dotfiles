-- emits wifi status (with nmcli)
-- well, it works for me. so yeah
---------------------------------

-- ("signal::wifi"), function(net_status(bool))


-- rquirements
local awful = require("awful")

-- interval (in seconds)
local update_interval = 6

-- import network info
local net_cmd = [[
  bash -c "
  nmcli g | tail -n 1 | awk '{ print $1 }'
  "
]]

  awful.widget.watch(net_cmd, update_interval, function(_, stdout)
    local net_ssid = stdout
    net_ssid = string.gsub(net_ssid, '^%s*(.-)%s*$', '%1')
    local net_status = true

    -- update networks status
    if net_ssid == "disconnected" then
        net_status = false
    end

    -- emit (true or false)
    awesome.emit_signal("signal::wifi", net_status)
end)

