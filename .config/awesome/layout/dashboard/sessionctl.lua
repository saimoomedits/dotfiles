-- session buttons
-- ~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local button_creator = require("helpers.widgets.create_button")



-- widgets
-- ~~~~~~~

-- lockscreen button
local lock_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "14",
    align = "center",
    valign = "center"
}


-- exitscreen button
local power_button = wibox.widget{
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text("", beautiful.fg_color),
    font = beautiful.icon_var .. "14",
    align = "center",
    valign = "center"
}




-- add function to them
-- ~~~~~~~~~~~~~~~~~~~~
power_button:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        require("mods.exit-screen") 
        awesome.emit_signal('module::exit_screen:show')
    end)
))

lock_button:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        if control_c.visible then cc_toggle() end
        require("layout.lockscreen").init()
        lock_screen_show()
    end)
))




--~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~
return wibox.widget {
        {
            button_creator(lock_button, beautiful.bg_3, beautiful.green_color .. "33", dpi(15), 0, beautiful.green_color .. "1A", helpers.rrect(1)),
            button_creator(power_button, beautiful.bg_3, beautiful.accent .. "33", dpi(15), 0, beautiful.accent .. "1A", helpers.rrect(1)),
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(2)
        },
    widget = wibox.container.background,
    bg = beautiful.bg_2,
    shape = helpers.prrect(beautiful.rounded, false, true, true, false)
}
