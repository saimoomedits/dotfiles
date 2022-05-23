-- exit screen module
-- ~~~~~~~~~~~~~~~~~~
-- orginial: https://github.com/manilarome/the-glorius-dotfiles
-- edited: https://github.com/saimoomedits/dotfiles


-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local dpi           = beautiful.xresources.apply_dpi
local helpers       = require("helpers")

-- misc/vars
-- ~~~~~~~~~

-- button size
local button_size = dpi(110)

-- icons
local icons = {
    poweroff = "",
    suspend  = "",
    reboot   = "",
    exit     = ""
}

-- Commands
local poweroff_command = function()
	awful.spawn.with_shell("systemctl poweroff")
	awesome.emit_signal('module::exit_screen:hide')
end

local reboot_command = function() 
	awful.spawn.with_shell("systemctl reboot")
	awesome.emit_signal('module::exit_screen:hide')
end

local suspend_command = function()
	awesome.emit_signal('module::exit_screen:hide')
    awful.spawn.with_shell("systemctl suspend")
end

local exit_command = function() awesome.quit() end


-- helper function for buttons
local cr_btn = function (text_cc, icon_cc, color, command)
    local i = wibox.widget{
        align = "center",
        valign = "center",
        font = beautiful.icon_var .. "30",
        markup = helpers.colorize_text(icon_cc, beautiful.ext_light_fg or beautiful.fg_color),
        widget = wibox.widget.textbox()
    }

    local text = wibox.widget{
        align = "center",
        valign = "center",
        font = beautiful.font_var .. "13",
        markup = helpers.colorize_text(text_cc, beautiful.ext_light_fg or beautiful.fg_color),
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        {
            nil,
            i,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_height   = button_size,
        forced_width    = button_size,
        shape           = gears.shape.circle,
		border_color	= "#00000000",
		border_width	= dpi(3),
        bg              = beautiful.bg_2,
        widget          = wibox.container.background
    }

	local mainbox_button = wibox.widget{
		button,
		text,
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(12)
	}

    button:buttons(gears.table.join( awful.button({}, 1, function() command() end)))


    button:connect_signal("mouse::enter", function()
        i.markup = helpers.colorize_text(icon_cc, beautiful.red_2)
        text.markup = helpers.colorize_text(text_cc, beautiful.red_2)
        button.border_color = beautiful.red_2
    end)
    button:connect_signal("mouse::leave", function()
        i.markup = helpers.colorize_text(icon_cc, beautiful.fg_color)
        text.markup = helpers.colorize_text(text_cc, beautiful.fg_color)
        button.border_color = beautiful.bg_2
    end)

    helpers.add_hover_cursor(button, "hand2")

    return mainbox_button
    
end


-- Widgets themselves
-- ~~~~~~~~~~~~~~~~~~

-- Create the buttons
local poweroff  = cr_btn("poweroff", icons.poweroff, beautiful.accent, poweroff_command)
local reboot    = cr_btn("reboot", icons.reboot,   beautiful.accent, reboot_command)
local suspend   = cr_btn("suspend", icons.suspend,  beautiful.accent, suspend_command)
local exit      = cr_btn("exit", icons.exit,     beautiful.accent, exit_command)

-- exit screen
local exit_screen_f = function(s)
	s.exit_screen = wibox{
		screen 	= s,
		type 	= 'splash',
		visible = false,
		ontop 	= true,
		bg 		= beautiful.black_color .. "80",
		fg 		= beautiful.fg_color,
		height 	= s.geometry.height,
		width 	= s.geometry.width,
		x 		= s.geometry.x,
		y 		= s.geometry.y
	}

    s.exit_screen:buttons(gears.table.join(awful.button(
				{}, 2, function()
					awesome.emit_signal('module::exit_screen:hide')
				end),

			awful.button(
				{}, 3, function()
					awesome.emit_signal('module::exit_screen:hide')
				end
			),

			awful.button(
				{}, 1, function()
					awesome.emit_signal('module::exit_screen:hide')
				end
			)
		)
	)





    s.exit_screen:setup {
		nil,
		{
			nil,
			nil,
			{
				{
					{
						{
							suspend,
							exit,
							spacing = dpi(45),
							layout = wibox.layout.fixed.horizontal
						},
						{
							poweroff,
							reboot,
							spacing = dpi(45),
							layout = wibox.layout.fixed.horizontal
						},
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(45)
					},
					widget = wibox.container.margin,
					margins = dpi(35)
				},
				widget = wibox.container.background,
				bg =beautiful.bg_color,
				shape = helpers.prrect(beautiful.rounded, true, true, false, false)
			},
			layout = wibox.layout.align.vertical,
			expand = "none"
		},
		expand = "none",
		layout = wibox.layout.align.horizontal
	}

end


screen.connect_signal('request::desktop_decoration',
	function(s)
		exit_screen_f(s)
	end
)

screen.connect_signal('removed',
	function(s)
		exit_screen_f(s)
	end
)

local exit_screen_grabber = awful.keygrabber {
	auto_start = true,
	stop_event = 'release',
	keypressed_callback = function(self, mod, key, command)
		if key == 's' then
			suspend_command()

		elseif key == 'e' then
			exit_command()

		elseif key == 'p' then
			poweroff_command()

		elseif key == 'r' then
			reboot_command()

		elseif key == 'Escape' or key == 'q' or key == 'v' then
			awesome.emit_signal('module::exit_screen:hide')
		end
	end
}

awesome.connect_signal(
	'module::exit_screen:show',
	function()
		for s in screen do
			s.exit_screen.visible = false
		end
		awful.screen.focused().exit_screen.visible = true
		exit_screen_grabber:start()
	end
)

awesome.connect_signal(
	'module::exit_screen:hide',
	function()
		exit_screen_grabber:stop()
		for s in screen do
			s.exit_screen.visible = false
		end
	end
)