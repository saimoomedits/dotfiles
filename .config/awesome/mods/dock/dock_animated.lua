-- A dock with Awesomewm's taglist widget
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- source: https://github.com/saimoomedits/dotfiles
-- The dock has authide with animations and much more!
-- The animations require `rubato` module for awesomewm
-- clone it to your `mods` directory from here:
-- https://github.com/andOrnaldo/rubato


--[[ some things to clear out:

  * Why the extra `wibox` for opening the dock?
  : it causes screen tearing, lag and picom issues for me. so its better to use an
  invisible wibox instead of gliding the dock downwards

  * Why the icon handler?
  : its just useful

]]



-- Requirements
---------------
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local rubato = require("mods.rubato")
------------------------------------------------------




return function (screen, pinned, size, offset, modules_spacing, active_color, inactive_color, minimized_color, background_color, hover_color, icon_handler)


    -- buttons for the dock
    ------------------------
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
    -- Eof tasklist buttons
    -----------------------------------------------------------------------




  -- main tasklist
  -------------------------------------------
  screen.mytasklist = awful.widget.tasklist {
    screen   = screen,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    layout   = {
        spacing = dpi(modules_spacing),
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            awful.widget.clienticon,
            id = "app_icon_role",
            forced_height = dpi(size / 1.7),
            forced_width = dpi(size / 1.7),
            margins = 5,
            opacity = 1,
            widget  = wibox.container.margin
        },
        {
          {
              forced_height = dpi(6),
              forced_width = dpi(size / 2.2),
              id            = "pointer",
              shape         = gears.shape.rounded_rect,
              bg            = active_color,
              widget        = wibox.container.background,
          },
          widget = wibox.container.place
        },
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical,
    create_callback = function(self, c, index, objects)

      -- plans to add effects to the dock

    end,

    update_callback = function(self, c, _, __)

        collectgarbage("collect")

				if c.active then
					self:get_children_by_id("app_icon_role")[1].opacity = 1
					self:get_children_by_id("pointer")[1].forced_width = dpi(size / 2.2)
					self:get_children_by_id("pointer")[1].bg = active_color
				elseif c.minimized then
					self:get_children_by_id("app_icon_role")[1].opacity = 0.5
					self:get_children_by_id("pointer")[1].forced_width = 6
					self:get_children_by_id("pointer")[1].bg = minimized_color
				else
					self:get_children_by_id("app_icon_role")[1].opacity = 1
					self:get_children_by_id("pointer")[1].forced_width = 6
					self:get_children_by_id("pointer")[1].bg = inactive_color
				end

        when_no_apps_open(screen)
    end

    },

  }
  -- Eof taglist
  -------------------------------------------------------------------------------




  -- helper function to create an pinned app
  ------------------------------------------
  local pin_app_creator = function (app_command, app_name)


    local app_icon = icon_handler("Crule", nil, app_name or string.lower(app_command) )

    local w = wibox.widget{
      {
        {
          widget = wibox.widget.imagebox,
          image = app_icon,
          valign = "center",
          halign = "center"
        },
        layout = wibox.container.place,
      },
      widget = wibox.container.margin,
      margins = dpi(10)
    }

    w:connect_signal(
        "button::press",
        function()
          awful.spawn.with_shell(app_command, false)
          w.opacity = 0.7
        end)
    w:connect_signal(
        "button::release",
        function()
          w.opacity = 1
        end)

    return w

  end
  -- Eof pinned-helper
  ----------------------------------------------------




  -- few pinned apps
  ---------------------------------
  local predefine_pinned_apps = { layout = wibox.layout.fixed.horizontal, spacing = dpi(modules_spacing) }


  for i in ipairs(pinned) do
    table.insert(predefine_pinned_apps, pin_app_creator(
      pinned[i][1],
      pinned[i][2] or pinned[i][1]
    ))
  end


  local pinned_apps = wibox.widget(predefine_pinned_apps)

  -- Eof pinned apps
  --------------------




  -- main dock wibox
  --------------------------
  local dock = awful.popup {
    screen          = screen,
    widget          = wibox.container.background,
    ontop           = true,
    bg              = background_color,
    visible         = false,
    maximum_width   = dpi(1000),
    maximum_height  = dpi(size),
    x               = screen.geometry.x + screen.geometry.width / 2,
    y               = awful.screen.focused().geometry.height,
    shape           = function(cr, width, height)
                            gears.shape.rounded_rect(cr, width, height, 10)
                      end,
  }

  dock:setup {
    screen.mytasklist,
    widget = wibox.container.margin,
    margins = dpi(10)
  }


  -- Eof main dock
  --------------------------------------------------------------------------




  -- fake dock
  ---------------------------
  local dock_helper = wibox {
    screen = screen,
    widget = wibox.container.background,
    ontop = false,
    opacity = 0,
    visible = true,
    width = dpi(800),
    height = dpi(10),
    type = "tooltip"
  }

  awful.placement.bottom(dock_helper)

  -- Eof fake dock
  ---------------------------









  -- helper function for empty dock
  ---------------------------------------
  function when_no_apps_open(s)
    if #s.selected_tag:clients() < 1 then


      if (#pinned or pinned) == 0 then
          dock:setup {
            layout = wibox.layout.fixed.horizontal,
        }
      else
          dock:setup {
            pinned_apps,
            widget = wibox.container.margin,
            margins = dpi(10)
        }
      end

    elseif #s.selected_tag:clients() == 1 then

      if (#pinned or pinned) == 0 then
        dock:setup {
          screen.mytasklist,
          widget = wibox.container.margin,
          margins = dpi(10)
        }
      else
        dock:setup {
          {
            pinned_apps,
            screen.mytasklist,
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(30),
            spacing_widget = wibox.widget{
              {
                widget = wibox.widget.separator,
                orientation = "vertical",
                thickness = 3,
              },
              widget = wibox.container.margin,
              margins = {top = dpi(modules_spacing), bottom = dpi(modules_spacing)}
            }
          },
          widget = wibox.container.margin,
          margins = dpi(10)
        }
      end

    else
        dock:setup {
          screen.mytasklist,
          widget = wibox.container.margin,
          margins = dpi(10)
        }
    end
  end
  -------------------------------------------




  -- The dock visibility
  ------------------------------------------------------------

  -- hidden y
  local hidden_y = awful.screen.focused().geometry.height - 10

  --visible y
  local visible_y = awful.screen.focused().geometry.height - (dock.maximum_height + offset)


  -- animation when the dock is closed/opened
  local animation = rubato.timed({
		intro = 0.1,
		outro = 0.1,
		duration = 0.3,
		pos = hidden_y,
		rate = 60,
		easing = rubato.quadratic,
		subscribed = function(pos)
			dock.y = pos
		end,
	})



  -- timer that hides the dock automatically
  local hidetimeout = gears.timer({
		timeout = 1,
		single_shot = true,
		callback = function()
			animation.target = hidden_y
         gears.timer({
	        	timeout = 0.4,
            call_now = false,
	        	single_shot = true,
	        	callback = function()
	        		dock.visible = false
	        	end,
	        })
		end,
	})


  dock_helper:connect_signal("mouse::leave", function()
    when_no_apps_open(screen)
		hidetimeout:again()
	end)

	dock_helper:connect_signal("mouse::enter", function()
    dock:connect_signal("property::width", function()
	  	dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
	  end)
    when_no_apps_open(screen)
    dock.visible = true
		animation.target = visible_y
		hidetimeout:stop()
	end)


  dock:connect_signal("mouse::leave", function()
		hidetimeout:again()
	end)

	dock:connect_signal("mouse::enter", function()
    dock:connect_signal("property::width", function()
	  	dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
	  end)
		hidetimeout:stop()
	end)



  -- Eof dock visibility
  ----------------------------------------------------------------------------


end