-- helper function to create buttons
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- uses rubato for smoooth animations


-- requirements
-- ~~~~~~~~~~~~
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local rubato = require("mods.rubato")
local dpi = beautiful.xresources.apply_dpi


return function (widget, normal_bg, press_color, margins, border_width, border_color, shape_spe)


    -- containers
    local circle_animate = wibox.widget{
    	widget = wibox.container.background,
    	shape = gears.shape.rounded_bar,
    	bg = press_color or beautiful.accent_3,
    }

    local mainbox = wibox.widget {
        {
            circle_animate,
            {
                widget,
                margins = margins or  dpi(15),
                widget = wibox.container.margin
            },
            layout = wibox.layout.stack
        },
      bg = (normal_bg) or beautiful.bg_3,
      shape = shape_spe or gears.shape.rounded_bar,
      border_width = border_width or dpi(0),
      border_color = border_color or press_color or "#00000000",
      widget = wibox.container.background,
    }


    local animation_button_opacity = rubato.timed{
        pos = 0,
        rate = 60,
        intro = 0.06,
        duration = 0.2,
        awestore_compat = true,
        subscribed = function(pos)
		    circle_animate.opacity = pos
        end
    }


    mainbox:connect_signal("mouse::enter", function()
        animation_button_opacity:set(0.4)
	end)

	mainbox:connect_signal("mouse::leave", function()
        animation_button_opacity:set(0.0)
	end)



    -- add buttons and commands
    mainbox:connect_signal("button::press", function()
            animation_button_opacity:set(1)
	end)

    mainbox:connect_signal("button::release", function()
            gears.timer {
                timeout   = 0.1,
                autostart = true,
                single_shot = true,
                callback  = function()
                    animation_button_opacity:set(0.4)
                end
            }
	end)




    return mainbox

end