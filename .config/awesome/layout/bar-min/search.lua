-- shell/web Search bar
-----------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi



-- widgets
----------

-- search icon
local search_icon = wibox.widget{
    font    = beautiful.icon_var .. " bold 12",
    align   = "center",
    valign  = "center",
    widget  = wibox.widget.textbox,
}

-- reset search icon
local reset_search_icon = function()
    search_icon.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
end
reset_search_icon()

-- search text
local search_text = wibox.widget({
    markup = helpers.colorize_text("boogle", beautiful.fg_color .. "99"),
    align = "center",
    valign = "center",
    font = beautiful.font_var .. "9",
    widget = wibox.widget.textbox(),
})


-- main box
local search = wibox.widget({
    {
        {
            search_icon,
            {
                search_text,
                widget = wibox.container.margin,
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(15),
        widget = wibox.container.margin,
    },
    forced_height = dpi(24),
    forced_width = dpi(320),
    shape = helpers.rrect(beautiful.rounded - 2),
    bg = beautiful.bg_2,
    widget = wibox.container.background,
})



-- update widgets
-----------------

-- promptbox icon generator
local function generate_prompt_icon(text, color)
    return "<span font='" .. beautiful.font_var .. " 8' foreground='" .. color .. "'>" .. text .. "</span> "
end


-- make it functional
local function activate_prompt(action)
    search_icon.visible = false
    local prompt
    if action == "run" then
        prompt = generate_prompt_icon("run:", beautiful.fg_color)
    elseif action == "web_search" then
        prompt = generate_prompt_icon("web:", beautiful.fg_color)
    end
    helpers.prompt(action, search_text, prompt, function()
        search_icon.visible = true
        search_text.markup = helpers.colorize_text("boogle", beautiful.fg_color .. "99")
    end)
end

-- user input
search:buttons(gears.table.join(
    awful.button({}, 1, function()
        activate_prompt("run")
    end),
    awful.button({}, 3, function()
        activate_prompt("web_search")
    end)
))


-- finalize
-----------
return search


-- eof
------