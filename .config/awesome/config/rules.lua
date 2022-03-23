-- rules
-- different windows rules

local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()

    -- Global
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            size_hints_honor = false,
            screen = awful.screen.preferred,
            placement = awful.placement.centered+awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- tasklist order
    ruled.client.append_rule {
        id = "tasklist_order",
        rule = {},
        properties = {},
        callback = awful.client.setslave
    }

    -- Floating
    ruled.client.append_rule {
        id = "floating",
        rule_any = {
            class = {"Sxiv", "Zathura", "Galculator"},
            role = {
                "pop-up"
            },
            instance = {"spad", "discord", "music"}
        },
        properties = {floating = true, placement = awful.placement.centered}
    }

    -- Borders
    ruled.client.append_rule {
        id = "borders",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            role = {"Popup"},
            type = {"splash"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal
        }
    }

    -- Center Placement
    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {"Steam", "discord", "markdown_input", "scratchpad"},
            instance = {"markdown_input", "scratchpad"},
            role = {"GtkFileChooserDialog", "conversation"}
        },
        properties = {placement = awful.placement.center}
    }

    -- Titlebar rules
    ruled.client.append_rule {
        id = "titlebars",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            class = {"Firefox"},
            type = {"splash"},
            instance = {"onboard"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {titlebars_enabled = true}
    }
end)

ruled.client.append_rule {
    -- Music clients (usually a terminal running ncmpcpp)
    rule_any = {class = {"music"}, instance = {"music"}},
    properties = {floating = true}
}

-- show titlebar only in floating  only
-- screen.connect_signal("arrange", function(s)
--   local layout = s.selected_tag.layout.name
--   for _, c in pairs(s.clients) do
--     if layout == "floating" or c.floating then
--       awful.titlebar.show(c)
--     else
--       awful.titlebar.hide(c)
--     end
--   end
-- end)