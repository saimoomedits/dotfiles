
local awful = require("awful")
local naughty = require("naughty")

awesome.connect_signal("signal::battery", function(value)
local yes_sir = naughty.action {name = "shutdown"}
local no_sir = naughty.action {name = "ignore"}

yes_sir:connect_signal('invoked', function()
    awful.spawn("poweroff")
end)

-- fixes issue #6
-- run only once
local inform_bat = true

if value < 10 then

    if inform_bat then
        naughty.notify {
            title = "Uh, oh",
            app_name = "systemd",
            icon = os.getenv("HOME") .. "/.config/awesome/images/awedroid/notifs/systemctl.png",
            text = "Your battery is low.",
            actions = {
                yes_sir,
                no_sir
            },
            timeout = 0
        }
    end

    inform_bat = false
    end
end)
