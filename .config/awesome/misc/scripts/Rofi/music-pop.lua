-- Music Pop up
-----------------------------------------------
-- A rofi popup script for music! for awesomewm
-- use the dashboard instead...
-- please 🙏

local popup = {}

-- requirements
-- ~~~~~~~~~~~~
local awful = require "awful"

-- buttons
local buttons = { "", "", "" }
local buttons_box = buttons[1] .. '\n' .. buttons[2] .. '\n' .. buttons[3]

-- playerctl commands
local commands = {
    "playerctl previous",
    "playerctl play-pause",
    "playerctl next",
}

-- rofi command
local cmd = [[
    bash -c 'printf "]] .. buttons_box .. [[" | rofi -theme .config/awesome/misc/scripts/Rofi/three-vertical.rasi -dmenu -selected-row 1'
]]

-- execute
function popup.execute()

awful.spawn.easy_async (cmd, function (stdout)

    -- check what the output is with 'buttons' table
    for i, v in ipairs(buttons) do
        if v == stdout:gsub("%s+", "")  then
            awful.spawn.with_shell(commands[i], false)
        end
    end

end)

end

return popup