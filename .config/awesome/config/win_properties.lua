-- window properties
-- credits to JavaCafe01

local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

-- Bling Module
local bling = require("mods.bling")


client.connect_signal("request::manage", function(c)
    if not c.icon then
        local i = gears.surface(gfs.get_configuration_dir() .. "images/no_window.png")
        c.icon = i._native
    end

    -- Set the windows at the slave,
    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


local ll = awful.widget.layoutlist {
    source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
    spacing = dpi(24),
    base_layout = wibox.widget {
        spacing = dpi(24),
        forced_num_cols = 4,
        layout = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id = "icon_role",
                forced_height = dpi(68),
                forced_width = dpi(68),
                widget = wibox.widget.imagebox
            },
            margins = dpi(24),
            widget = wibox.container.margin
        },
        id = "background_role",
        forced_width = dpi(68),
        forced_height = dpi(68),
        shape = helpers.rrect(8),
        widget = wibox.container.background
    }
}

-- Popup
local layout_popup = awful.popup {
    widget = wibox.widget {
        {ll, margins = dpi(24), widget = wibox.container.margin},
        bg = beautiful.bg_color,
        shape = helpers.rrect(8),
        border_color = "#00000000",
        border_width = 0,
        widget = wibox.container.background
    },
    placement = awful.placement.centered,
    ontop = true,
    visible = false,
    bg = "#00000000"
}


function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then return end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

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
    start_callback = function() layout_popup.visible = true end,
    stop_callback = function() layout_popup.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
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

-- EOF --------------