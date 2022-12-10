-- misc stuff
-- includes startup apps, theme changing and more
--------------------------------------------------
-- Copyleft © 2022 Saimoomedits

-- requirements
-- ~~~~~~~~~~~~
local awful = require "awful"
local gfs = require "gears".filesystem.get_configuration_dir()


-- autostart
-- ~~~~~~~~~

-- startup apps runner
local function run(command, pidof)
    -- emended from manilarome
    local findme = command
    local firstspace = command:find(' ')
    if firstspace then
        findme = command:sub(0, firstspace - 1)
    end

    awful.spawn.easy_async_with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', pidof or findme, command))
end


local applications = {
    "picom --config $HOME/.config/awesome/misc/picom/panthom.conf &",
}

for _, prc in ipairs(applications) do
    run(prc)
end

-- only-one-time process (mpdris2)
-- awful.spawn.easy_async_with_shell("pidof python3", function (stdout)
--     if not stdout or stdout == "" then
--         awful.spawn.easy_async_with_shell("mpDris2")
--     end
-- end)




-- launchers
-- ~~~~~~~~~

return {
    rofiCommand = "rofi -show drun -theme " .. gfs .. "/misc/rofi/theme.rasi",
    musicMenu   = function() require("misc.scripts.Rofi.music-pop").execute() end
}

