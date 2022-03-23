-- Bling config
-- Credits to JavaCafe01

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local bling = require("mods.bling")

 --[[ wallpaper
 awful.screen.connect_for_each_screen(function(s) 
     bling.module.tiled_wallpaper("+", s, {       
         fg = beautiful.bg_light,
         bg = beautiful.bg_alt,
         offset_y = 20,
         offset_x = 20,
         font = beautiful.font_var,
         font_size = 40,
         padding = 130,
         zickzack = true
     })
 end)
 --]]



-- tag preview
bling.widget.tag_preview.enable {
    show_client_content = false,
    placement_fn = function(c)
        awful.placement.left(c, {
            margins = {
                top = 0,
                left = 70
            }
        })
    end,
    scale = 0.15,
    honor_padding = true,
    honor_workarea = false,
    background_widget = wibox.widget {
        image = gears.color.recolor_image("/home/saimoom/wallpapers/plain.png", beautiful.bg_color),
        horizontal_fit_policy = "fit",
        vertical_fit_policy = "fit",
        widget = wibox.widget.imagebox
    }
}

-- task preview
-- Enable Task Preview Module from Bling
-- bling.widget.task_preview.enable {
--     placement_fn = function(c)
--         awful.placement.left(c, {
--             margins = {
--                 top = 0,
--                 left = 60 -- change to right when using vertical bar
--             }
--         })
--     end
-- }

