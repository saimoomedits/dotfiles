-- Taglist widget
-- ~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- default modkey
local modkey = "Mod4"


local get_taglist = function(s)

    -- Taglist buttons
    local taglist_buttons = gears.table.join(
                                awful.button({}, 1,
                                             function(t) t:view_only() end),
                                awful.button({modkey}, 1, function(t)
            if client.focus then client.focus:move_to_tag(t) end
        end), awful.button({}, 3, awful.tag.viewtoggle),
                                awful.button({modkey}, 3, function(t)
            if client.focus then client.focus:toggle_tag(t) end
        end), awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end), awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end))


    local the_taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {shape = helpers.rrect(5)},
        layout = {spacing = dpi(16), layout = wibox.layout.fixed.horizontal},
        widget_template = {
            widget = wibox.container.background,
            shape = gears.shape.rounded_rect,
            forced_width = dpi(13),
            forced_height = dpi(12),

            create_callback = function(self, c3, _)
                if c3.selected then
                    self.bg = beautiful.accent
                    self.forced_width = dpi(20)
                elseif #c3:clients() == 0 then
                    self.bg = beautiful.bg_3
                    self.forced_width = dpi(12)
                else
                    self.bg = beautiful.accent_2
                    self.forced_width = dpi(12)
                end
            end,
            update_callback = function(self, c3, _)

                if c3.selected then
                    self.bg = beautiful.accent
                    self.forced_width = dpi(20)
                elseif #c3:clients() == 0 then
                    self.bg = beautiful.bg_3
                    self.forced_width = dpi(12)
                else
                    self.bg = beautiful.accent_2
                    self.forced_width = dpi(12)
                end
            end
        },
        buttons = taglist_buttons
    }

    return the_taglist
end

return get_taglist