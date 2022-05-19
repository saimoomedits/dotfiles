-- Ram info
-----------

-- ("signal::ram"), functuin(used(int), total(int))

local awful = require("awful")

local update_interval = 20
local ram_script = [[
  sh -c "
  free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
  "]]

awful.widget.watch(ram_script, update_interval, function(widget, stdout)
    local available = stdout:match('(.*)@@')
    local total = stdout:match('@@(.*)@')
    local used = tonumber(total) - tonumber(available)
    awesome.emit_signal("signal::ram", used, tonumber(total))
end)