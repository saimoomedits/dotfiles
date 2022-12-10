-- rules
--------
-- Copyleft © 2022 Saimoomedits


-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")



-- Configurations
-- ~~~~~~~~~~~~~~

-- connect to signal
ruled.client.connect_signal("request::rules", function()

    -- Global
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus               = awful.client.focus.filter,
            raise               = true,
            size_hints_honor    = false,
            screen              = awful.screen.preferred,
            titlebars_enabled   = true,
            placement           = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    -- tasklist order
    ruled.client.append_rule {
        id          = "tasklist_order",
        rule        = {},
        properties  = {},
        callback    = awful.client.setslave
    }

    -- Floating
    ruled.client.append_rule {
        id          = "floating",
        rule_any    = {
            class   = {"Sxiv", "Zathura", "Galculator", "Xarchiver", "amberol"},
            role    = { "pop-up"},
            instance    = {"spad", "discord", "music"}
        },
        properties      = {floating = true, placement = awful.placement.centered}
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
        }
    }

    -- Center Placement
    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {"Steam", "discord", "markdown_input", "nemo", "thunar" },
            instance = {"markdown_input",},
            role = {"GtkFileChooserDialog"}
        },
        properties = {placement = awful.placement.center}
    }

    -- Titlebar rules
    ruled.client.append_rule {
        id = "titlebars",
        rule_any = {
            type = {
            "dialog",
            "splash"
        },
        name = {
            "^discord.com is sharing your screen.$",
            "file_progress"
        },
				class = {
                        "spad",
						"amberol"
				}
    },
        properties = {titlebars_enabled = false}
    }
    end)


    -- Music client
    ruled.client.append_rule {
        rule_any = {class = {"music"}, instance = {"music"}},
        properties = {
            floating = true,
            width = 700,
			height = 444,
        },

}

-- hide titlebar for tiled/maxed
screen.connect_signal("arrange", function(s)
  local layout = s.selected_tag.layout.name
  for _, c in pairs(s.clients) do
    if c.maximized or c.fullscreen then 
      awful.titlebar.hide(c)
      c.border_width = 0
    elseif layout == "floating" or c.floating then
      awful.titlebar.show(c)
      c.border_width = 0
    else
      awful.titlebar.hide(c)
      c.border_width = beautiful.border_width
    end
  end
end)
