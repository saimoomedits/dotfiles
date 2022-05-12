--[[
    A mtertial-you inspired awesomewm setup!
    source: https://github.com/saimoomedits/dotfiles
]]


pcall (require, "luarocks.loader")


-- misc/vars
-- ~~~~~~~~~

-- home variable
home_var        = os.getenv("HOME")

-- user preferences
user_likes      = {

    -- aplications
    term        = "alacritty",
    editor      = "alacritty -e " .. "nvim",
    code        = "vscode",
    web         = "firefox",
    music       = "alacritty --class 'music' --config-file " .. home_var .. "/.config/alacritty/ncmpcpp.yml -e ncmpcpp ",
    files       = "thunar",

    -- weather info
    weather_key     = "",
    city_id         = "",
    weather_unit    = "metric"
}


-- general
-- ~~~~~~~

-- theme
require("theme")

-- configs
require("config")

-- startup programs
require("misc")

-- signals
require("signal")

-- ui elements
require("layout")