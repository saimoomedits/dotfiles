-- minimal tasklist
-------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi



-- variables
------------

-- buttons for the tasklist
local tasklist_buttons = gears.table.join(
                 awful.button({ }, 1, function (c)
                                          if c == client.focus then
                                              c.minimized = true
                                          else
                                              c:emit_signal(
                                                  "request::activate",
                                                  "tasklist",
                                                  {raise = true}
                                              )
                                          end
                                      end),
                 awful.button({ }, 3, function(c)
                                          c:kill()
                                      end),
                 awful.button({ }, 4, function ()
                                          awful.client.focus.byidx(1)
                                      end),
                 awful.button({ }, 5, function ()
                                          awful.client.focus.byidx(-1)
                                      end))



-- widgets
----------

-- the tasklist widget itself
local tasklist_widget = awful.widget.tasklist({
	screen = awful.screen.focused(),
	filter = awful.widget.tasklist.filter.currenttags,
	buttons = tasklist_buttons,
	style = {
		font = beautiful.font_var,
		bg_normal = beautiful.bg_3,
		bg_focus = beautiful.fg_color .. "26",
		bg_minimize = beautiful.bg_2,
        shape = helpers.rrect(beautiful.rounded - 2)
	},
	layout = {
		layout = wibox.layout.fixed.horizontal,
	},
	widget_template = {
		{
            {
			    {
			    	awful.widget.clienticon,
			    	forced_height = dpi(15),
			    	forced_width = dpi(15),
			    	halign = "center",
			    	valign = "center",
			    	widget = wibox.container.place,
			    },
			    margins = dpi(9),
			    widget = wibox.container.margin,
            },
            {
                nil,
                nil,
                {
                    nil,
                    {
                        widget = wibox.container.background,
                        id = "pointer",
                        bg = beautiful.fg_color,
                        shape = gears.shape.rounded_bar,
                        forced_height = dpi(2),
                        forced_width = dpi(20)
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                layout = wibox.layout.align.vertical
            },
            layout = wibox.layout.stack,
		},
		forced_width = dpi(45),
		id = "background_role",
		widget = wibox.container.background,

        update_callback = function(self, c, _, __)

            collectgarbage("collect")

				    if c.active then
				    	self:get_children_by_id("pointer")[1].bg = beautiful.fg_color
				    elseif c.minimized then
				    	self:get_children_by_id("pointer")[1].bg = beautiful.fg_color .. "1A"
				    else
				    	self:get_children_by_id("pointer")[1].bg = beautiful.bg_3
				    end

        end,
        create_callback = function(self, c, index, objects) --luacheck: no unused args
            -- BLING: Toggle the popup on hover and disable it off hover
                local timed_show = gears.timer {
                    timeout   = 1,
                    call_now  = false,
                    autostart = false,
                    callback  = function()
                        awesome.emit_signal("bling::task_preview::visibility", s, true, c)
                    end
                }
            self:connect_signal('mouse::enter', function()
                timed_show:start()
                end)
                self:connect_signal('mouse::leave', function()
                    timed_show:stop()
                    awesome.emit_signal("bling::task_preview::visibility", s, false, c)
                end)
        end,

	},
})


-- finalize
-----------
return tasklist_widget


-- eof
------