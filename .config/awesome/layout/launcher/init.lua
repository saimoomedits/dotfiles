-- Bling's app launcher
-- forked..
------------------------
-- Copyleft © 2022 Saimoomedits

-- requirements
---------------
local awful = require("awful")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- arguments
local args = {
    terminal = "alacritty",
    favorites = { "firefox", "alacritty", "discord" },
    search_commands = true,
    skip_empty_icons = true,
    sort_alphabetically = true,
    hide_on_left_clicked_outside = true,
    hide_on_right_clicked_outside = true,
    try_to_keep_index_after_searching = false,
    save_history = true,
    background = beautiful.bg_color,
    shape = helpers.rrect(beautiful.rounded),
    prompt_height = dpi(60),
    placement = awful.placement.bottom_left,
    prompt_margins = dpi(20),
    prompt_paddings = dpi(20), 
    prompt_text = "> ",
    prompt_color = beautiful.bg_2,
    prompt_icon_markup = helpers.colorize_text("", beautiful.fg_color),
    prompt_text_color = beautiful.fg_color,
    prompt_cursor_color = beautiful.fg_color .. "33",
    apps_per_column = 1,
    apps_per_row = 6,
    app_icon_halign = "left",
    app_selected_color = beautiful.bg_2,
    app_normal_color = beautiful.bg_color,
    app_name_normal_color = beautiful.fg_color .. "4D",
    app_name_selected_color = beautiful.bg_color,
    app_name_selected_color = beautiful.fg_color,
    app_name_font = beautiful.font_var .. "11",
    app_icon_width = dpi(32),                             
    app_icon_height = dpi(32),
    app_width = dpi(320),
    app_height = dpi(65),
    icon_size = 24,
    apps_spacing = dpi(5),
    app_shape = helpers.rrect(beautiful.rounded)
}

-- finalize
-----------
_G.app_launcher = require("mods.app_launcher")(args)

-- eof
------