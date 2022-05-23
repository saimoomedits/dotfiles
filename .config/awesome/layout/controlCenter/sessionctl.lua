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
    nil,
    {
        {
            button_creator(lock_button, beautiful.bg_3 .."B3", beautiful.fg_color .. "33", dpi(13), 0, beautiful.fg_color .. "33"),
            button_creator(power_button, beautiful.bg_3 .. "B3", beautiful.fg_color .. "33", dpi(13), 0, beautiful.fg_color .. "33"),
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(10)
        },
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.align.vertical,
    expand = "none"
}
