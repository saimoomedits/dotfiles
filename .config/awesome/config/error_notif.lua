
local naughty = require("naughty")

-- error notification
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Ugh, an error just occurred :("..(startup and " during startup!" or "!"),
        message = message
    }
end)