-- ding - notification
----------------------
-- Copyleft © 2022 Saimoomedits

-- requirements
---------------
local naughty = require("naughty")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")
local menubar = require("menubar")
local gears = require("gears")
local kasper_animation = require("mods.animation")


-- extras
---------

require("layout.ding.extra.music")
require("layout.ding.extra.popup")
require("layout.ding.extra.battery")



-- configuration
----------------

-- icon
naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then n.icon = path end

end)

local function get_oldest_notification()
	for _, notification in ipairs(naughty.active) do
		if notification and notification.timeout > 0 then
			return notification
		end
	end

	--- Fallback to first one.
	return naughty.active[1]
end


-- naughty config
naughty.config.defaults.ontop       = true
naughty.config.defaults.screen      = awful.screen.focused()
naughty.config.defaults.timeout     = 3
naughty.config.defaults.title       = "Ding!"
naughty.config.defaults.position    = "bottom_right"

awesome.connect_signal("control_center::visible", function(val) 
    if val then
        naughty.config.defaults.position    = "top_right"
    else
        naughty.config.defaults.position    = "bottom_right"
    end
end)

-- Timeouts
naughty.config.presets.low.timeout      = 3
naughty.config.presets.critical.timeout = 0

-- ruled notification
ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule {
        rule = {},
        properties = {screen = awful.screen.preferred, implicit_timeout = 6}
    }
end)



-- connect to each display
--------------------------
naughty.connect_signal("request::display", function(n)


    -- action widget
    local action_widget = {
        {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                font = beautiful.font_var .. "10",
                widget = wibox.widget.textbox
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin
        },
        bg = beautiful.bg_2,
        forced_height = dpi(30),
        shape = helpers.rrect(beautiful.rounded - 4),
        widget = wibox.container.background
    }


    -- actions
    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style = {underline_normal = false, underline_selected = true},
        widget = naughty.list.actions
    }



    local filter_color = {
    	type = "linear",
    	from = { 0, 0 },
    	to = { 0, 158},
    	stops = { { 0, beautiful.bg_color .. "99" }, { 1, beautiful.bg_color } },
    }

    local image_filter = wibox.widget({
    	{
    		bg = filter_color,
    		forced_height = dpi(150),
    		forced_width = dpi(150),
    		widget = wibox.container.background,
    	},
    	direction = "west",
    	widget = wibox.container.rotate,
    })

    -- image
    local image_n = wibox.widget {
    {
        image = n.icon,
        resize = true,
        halign = "center",
        valign = "center",
        widget = wibox.widget.imagebox,
    },
    strategy = "exact",
    height = dpi(50),
    width = dpi(50),
    widget = wibox.container.constraint,
    }


    -- title
    local title_n = wibox.widget{
        {
            {
                markup      = n.title,
                font        = beautiful.font_var .. "Bold 11",
                align       = "left",
                valign      = "center",
                widget      = wibox.widget.textbox
            },
            forced_width    = dpi(240),
            widget          = wibox.container.scroll.horizontal,
            step_function   = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed           = 50
        },
        margins     = {right = 15},
        widget      = wibox.container.margin
    }


    local message_n = wibox.widget{
        {
            {
                markup      = helpers.colorize_text("<span weight='normal'>" .. n.message .. "</span>", beautiful.fg_color .. "BF"),
                font        = beautiful.font_var .. " 11",
                align       = "left",
                valign      = "center",
                wrap        = "char",
                widget      = wibox.widget.textbox
            },
            forced_width    = dpi(240),
            layout = wibox.layout.fixed.horizontal
        },
        margins     = {right = 15},
        widget      = wibox.container.margin
    }


    -- app name
    local app_name_n = wibox.widget{
            markup      = helpers.colorize_text(n.app_name, beautiful.fg_color .. "BF"),
            font        = beautiful.font_var .. " 10",
            align       = "left",
            valign      = "center",
            widget      = wibox.widget.textbox
    }

    local time_n = wibox.widget{
        {
            markup      = helpers.colorize_text("now", beautiful.fg_color .. "BF"),
            font        = beautiful.font_var .. " 10",
            align       = "right",
            valign      = "center",
            widget      = wibox.widget.textbox
        },
        margins = {right = 20},
        widget  = wibox.container.margin
    }

    local close = wibox.widget {
        markup      = helpers.colorize_text("", beautiful.red_color),
        font        = beautiful.icon_var .. " 12",
        align       = "ceneter",
        valign      = "center",
        widget      = wibox.widget.textbox
    }

    close:buttons(gears.table.join(
    awful.button({}, 1, function() n:destroy(naughty.notification_closed_reason.dismissed_by_user) end)))


    -- extra info
    local notif_info = wibox.widget{
        app_name_n,
        {
            widget = wibox.widget.separator,
            shape = gears.shape.circle,
            forced_height = dpi(4),
            forced_width = dpi(4),
            color = beautiful.fg_color .."BF"
        },
        time_n,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(7)
    }



	local timeout_bar = wibox.widget({
		widget = wibox.widget.progressbar,
		forced_height = dpi(3),
        forced_width = dpi(1),
		max_value = 100,
		min_value = 0,
		value = 0,
		background_color = beautiful.bg_3,
		color = beautiful.fg_color .. "4D",
	})

    -- init
    local widget = naughty.layout.box {
        notification = n,
        type    = "notification",
        bg      = beautiful.bg_color,
        shape   = helpers.rrect(beautiful.rounded),
        widget_template = {
            {

                { -- top bit
                    timeout_bar,
                    {
                        {
                            {
                                notif_info,
                                nil,
                                close,
                                layout = wibox.layout.align.horizontal,
                                expand = "none"
                            },
                            margins = {left = dpi(15), right = dpi(15), top = dpi(10), bottom = dpi(10)},
                            widget = wibox.container.margin
                        },
                        widget = wibox.container.background,
                        bg = beautiful.bg_2,
                    },
                    layout = wibox.layout.fixed.vertical
                },

                { -- body
                    {
                        {
                            title_n,
                            message_n,
                            layout = wibox.layout.fixed.vertical,
                            spacing = dpi(3)
                        },
                        nil,
                        image_n,
                        layout = wibox.layout.align.horizontal,
                        expand = "none"
                    },
                    margins = {left = dpi(15), top = dpi(10), right = dpi(10)},
                    widget = wibox.container.margin
                },

                { -- foot
                    actions,
                    margins = dpi(10),
                    widget = wibox.container.margin
                },
                
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(10)

            },

            widget = wibox.container.background,
            shape = helpers.rrect(beautiful.rounded - 2),
            bg = beautiful.bg_color,
        }
    }

    widget.buttons = {}



    local anim = kasper_animation:new({
		duration = n.timeout,
		target = 100,
		easing = kasper_animation.easing.linear,
		reset_on_stop = false,
		update = function(self, pos)
			timeout_bar.value = pos
		end,
	})

    anim:connect_signal("ended", function()
		n:destroy()
	end)

	widget:connect_signal("mouse::enter", function()
		n:set_timeout(4294967)
		anim:stop()
	end)

	widget:connect_signal("mouse::leave", function()
		anim:start()
	end)


	local notification_height = widget.height + beautiful.notification_spacing
	local total_notifications_height = #naughty.active * notification_height

	if total_notifications_height > n.screen.workarea.height then
		get_oldest_notification():destroy(naughty.notification_closed_reason.too_many_on_screen)
	end


    anim:start()


    -- don't show notification when dnd is on or dash is visible
    if _G.awesome_dnd_state or dashbaord_d.visible then
	    naughty.destroy_all_notifications(nil, 1)
    end
end)


-- eof
------