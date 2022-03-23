
local awful = require("awful")
local naughty = require("naughty")

awesome.connect_signal("signal::battery", function(value)
local yes_sir = naughty.action {name = "shutdown"}
local no_sir = naughty.action {name = "ignore"}

yes_sir:connect_signal('invoked', function()
    awful.spawn("poweroff")
end)

if value < 10 then
    naughty.notify {
        title = "Uh, oh",
        app_name = "systemd",
        icon = os.getenv("HOME") .. "/.config/awesome/images/notifs/systemctl.png",
        text = "Your battery is low.",
        actions = {
            yes_sir,
            no_sir
        },
        timeout = 0
}
    end
end)