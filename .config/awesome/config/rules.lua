-- rules
-- ~~~~~


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
            class   = {"Sxiv", "Zathura", "Galculator", "Xarchiver"},
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
            border_color = beautiful.border_normal
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
        }
    },
        properties = {titlebars_enabled = false}
    }
    end)




    -- move to certain tag when spawned
    -- -- -- -- -- -- -- -- -- -- -- --

    -- windows opened in tag 2 (web browsers/internet)
    ruled.client.append_rule {
        rule_any    = {
            class = {"qutebrowder", "chromium", user_likes.web}
        },
        properties = {
            tag = "2",
        },
    }

    -- windows opened in tag 5 (files)
    ruled.client.append_rule {
        rule_any    = {
            class = {"Nemo", "thunar"}
        },
        properties = {
            tag = "5",
        },
    }

    -- windows opened in tag 3 (code)
    ruled.client.append_rule {
        rule_any    = {
            class = {"Code", "lite-xl"}
        },
        properties = {
            tag = "3",
        },
    }

    -- windows opened in tag 4 (games)
    ruled.client.append_rule {
        rule_any    = {
            class = {"Steam", "Minecraft", "Multimc", "Sauerbraten"}
        },
        properties = {
            tag = "4",
        },
    }

    -- Music client
    ruled.client.append_rule {
        rule_any = {class = {"music"}, instance = {"music"}},
        properties = {
            floating = true,
            width = 650,
			height = 550,
        }
}
