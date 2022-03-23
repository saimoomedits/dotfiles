-- emits wifi status
-- with nmcli 

local awful = require("awful")

local update_interval = 5
local net_cmd = [[
  bash -c "
  nmcli g | tail -n 1 | awk '{ print $1 }'
  "]]

  awful.widget.watch(net_cmd, update_interval, function(_, stdout)
    local net_ssid = stdout
    net_ssid = string.gsub(net_ssid, '^%s*(.-)%s*$', '%1')
    local net_status = true

    if net_ssid == "disconnected" then
        net_status = false
    end

    awesome.emit_signal("signal::wifi", net_status)
end)

