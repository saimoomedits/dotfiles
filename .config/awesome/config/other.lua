-- extra configs
-- ~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local bling = require("mods.bling")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi



-- bling
-- ~~~~~
local bar_size = beautiful.bar_size

-- flash
-- bling.module.flash_focus.enable()

-- tag preview
bling.widget.tag_preview.enable {
    show_client_content     = false,
    placement_fn            = function(c)

    awful.placement.left(c, {
        margins = {
            left = bar_size + beautiful.useless_gap * 4
        }
    })

    end,
    scale                   = 0.16,
    honor_padding           = false,
    honor_workarea          = false,
    background_widget       = wibox.widget {
                widget = wibox.container.background,
                bg = beautiful.wallpaper
                }
}




-- Error ding
-- ~~~~~~~~~~
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        app_name = "AwesomeWM",
        urgency = "critical",
        title   = "bruh! an error has occured " .. (startup and " during startup" or "!"),
        message = message
    }
end)



-- wallpaper
-- ~~~~~~~~~
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            image = beautiful.wallpaper,
            widget = wibox.widget.imagebox,
            upscale               = true,
            downscale             = true,
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
        }
    }
end)





-- window stuff
-- ~~~~~~~~~~~~

-- autofucs on tag change
require("awful.autofocus")

-- remember floating window pos
require("mods.savefloats")

-- better resizing
require("mods.better-resize")


-- request client's properties
client.connect_signal("request::manage", function(c)

    -- set default window icon
    if not c.icon then
        local i = gears.color.recolor_image(beautiful.images.awesome, beautiful.accent)
        c.icon = i._native
    end

    -- Set the windows at the slave
    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
    end
end)



-- layoutlist popup widget --
local ll = awful.widget.layoutlist {
    source              = awful.widget.layoutlist.source.default_layouts,
    spacing             = dpi(24),
    base_layout         = wibox.widget {
        spacing         = dpi(24),
        forced_num_cols = 3,
        layout          = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id              = "icon_role",
                forced_height   = dpi(68),
                forced_width    = dpi(68),
                widget          = wibox.widget.imagebox
            },
            margins     = dpi(24),
            widget      = wibox.container.margin
        },
        id              = "background_role",
        forced_width    = dpi(68),
        forced_height   = dpi(68),
        shape           = helpers.rrect(8),
        widget          = wibox.container.background
    }
}

-- Popup
local layout_popup = awful.popup {
    widget = wibox.widget {
        {ll, margins    = dpi(24), widget = wibox.container.margin},
        bg              = beautiful.bg_color,
        widget          = wibox.container.background
    },
    placement   = awful.placement.centered,
    ontop       = true,
    visible     = false,
    shape           = helpers.rrect(beautiful.rounded),
    bg          = "#00000000"
}


function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then return end

    step_size       = step_size or 1
    local new_key   = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i = 1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then return t[k2], k2 end
        end
        return
    end

    return t[new_key], new_key
end


local modkey = "Mod4"

awful.keygrabber {
    start_callback      = function() layout_popup.visible = true end,
    stop_callback       = function() layout_popup.visible = false end,
    export_keybindings  = true,
    stop_event          = "release",
    stop_key            = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {
            {modkey, "Shift"}, " ", function()
                awful.layout.set(gears.table.iterate_value(ll.layouts,
                                                           ll.current_layout, -1),
                                 nil)
            end
        }, {
            {modkey}, " ", function()
                awful.layout.set(gears.table.iterate_value(ll.layouts,
                                                           ll.current_layout, 1),
                                 nil)
            end
        }
    }
}




-- sloppy focus
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)


-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
	local t = screen.primary.selected_tag
	if vis then
		for idx, c in ipairs(t:clients()) do
			c.hidden = true
		end
	else
		for idx, c in ipairs(t:clients()) do
			c.hidden = false
		end
	end
end)


-- round windows
local function enable_rounding()
    if beautiful.rounded and beautiful.rounded > 0 then
        client.connect_signal("manage", function (c, startup)
            if not c.fullscreen and not c.maximized then
                c.shape = helpers.rrect(beautiful.rounded)
            end
        end)

        local function no_round_corners (c)
            if c.fullscreen then
                c.shape = nil
            elseif c.maximized then
                c.shape = helpers.prrect(beautiful.rounded, true, true, false, false)
            else
                c.shape = helpers.rrect(beautiful.rounded)
            end
        end

        client.connect_signal("property::fullscreen", no_round_corners)
        client.connect_signal("property::maximized", no_round_corners)

        beautiful.snap_shape = helpers.rrect(beautiful.rounded)
    else
        beautiful.snap_shape = gears.shape.rectangle
    end
end

enable_rounding()



-- Garbage Collection
-- ~~~~~~~~~~~~~~~~~~
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)