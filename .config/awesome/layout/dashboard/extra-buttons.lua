-- extra buttons
-- ~~~~~~~~~~~~~
-- screenshot, lockscreen, exit-menu


-- requirements
-- ~~~~~~~~~~~~
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local button_creator = require("helpers.widgets.create_button")




-- misc/vars
-- ~~~~~~~~~

-- button properties
local button_margins = {top = dpi(11), bottom = dpi(11), left = dpi(44), right = dpi(44)}
local button_border = {width = dpi(1), color = beautiful.fg_color}
local button_size = "14"


-- main function to create button
local function create_button(icon, op_font)

    -- main button icon
    local icon_w = wibox.widget{
        markup = icon,
        font = (op_font or beautiful.icon_var) .. button_size,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    }

    return button_creator(icon_w, beautiful.black_color, beautiful.fg_color .. "99", button_margins, button_border.width, button_border.color)

end

-- widgets
-- ~~~~~~~


local ssbutton      = create_button("", beautiful.icon_alt_var)
local exitbutton    = create_button("")
local lockbutton    = create_button("")



-- functional
-- ~~~~~~~~~~
ssbutton:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
        dash_toggle()
        gears.timer {
            timeout   = 1,
            autostart = true,
            single_shot = true,
            callback  = function()
                awful.spawn.with_shell("$HOME/.scripts/awesome/ss full")
            end
        }
end)))

lockbutton:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
        dash_toggle()
        lock_screen_show()
end)))

exitbutton:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
        require("mods.exit-screen")
        awesome.emit_signal('module::exit_screen:show')
        dash_toggle()
end)))




-- ~~~~~~~~~~~~~~~~~
return wibox.widget{
    ssbutton,
    lockbutton,
    exitbutton,
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(15)
}