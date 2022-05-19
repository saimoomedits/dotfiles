--[[
    A random rice. i guess.
    source: https://github.com/saimoomedits/dotfiles
]]


pcall (require, "luarocks.loader")


-- home variable 🏠
home_var        = os.getenv("HOME")


-- user preferences ⚙️
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
    weather_unit    = "metric",

    -- your profile
    username = os.getenv("USER") or "user",
    userdesc = "@computer"
}



-- theme 🖌️
require("theme")

-- configs ⚙️
require("config")

-- miscallenous ✨
require("misc")

-- signals 📶
require("signal")

-- ui elements 💻
require("layout")