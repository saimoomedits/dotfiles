-- Taglist widget
-- credits to JavaCafe01

local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

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

    local occupied = gears.surface.load_uncached(
                        gfs.get_configuration_dir() .. "images/taglist/occ.png")
    local occ_icon = gears.color.recolor_image(occupied, beautiful.fg_color .. "99")

    local empty = gears.surface.load_uncached(
                         gfs.get_configuration_dir() .. "images/taglist/empty.png")
    local em_icon = gears.color.recolor_image(empty, beautiful.fg_color .. "61")
    
    local active = gears.surface.load_uncached(
                           gfs.get_configuration_dir() .. "images/taglist/focus.png")
    local active_icon = gears.color.recolor_image(active, beautiful.fg_color)

    -- Function to update the tags
    local update_tags = function(self, c3)
        local imgbox = self:get_children_by_id('icon_role')[1]
        if c3.selected then
            imgbox.image = active_icon
        elseif #c3:clients() == 0 then
            imgbox.image = em_icon
        else
            imgbox.image = occ_icon
        end
    end

    local the_taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {shape = helpers.rrect(5)},
        layout = {spacing = 0, layout = wibox.layout.fixed.vertical},
        widget_template = {
            {
                {id = 'icon_role', widget = wibox.widget.imagebox},
                id = 'margin_role',
                margins = dpi(8), 
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
                update_tags(self, c3)
                self:connect_signal('mouse::enter', function()
                    if #c3:clients() > 0 then
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        awesome.emit_signal("bling::tag_preview::visibility", s,
                                            true)
                    end
                    if self.bg ~= beautiful.bg_alt_dark then
                        self.backup = self.bg
                        self.has_backup = true
                    end
                    self.bg = beautiful.bg_alt_dark
                end)
                self:connect_signal('mouse::leave', function()
                    awesome.emit_signal("bling::tag_preview::visibility", s,
                                        false)
                    if self.has_backup then
                        self.bg = self.backup
                    end
                end)
            end,
            update_callback = function(self, c3, index, objects)
                update_tags(self, c3)
            end
        },
        buttons = taglist_buttons
    }

    return the_taglist
end

return get_taglist