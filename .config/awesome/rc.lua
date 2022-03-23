-- RC.LUA - File for awesome wm configs

-- imports
pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
require("awful.hotkeys_popup.keys")


-- user preferences
user_likes = {
    term = "alacritty",
    editor = "alacritty -e " .. "nvim",
    code = "vscode",
    web = "firefox",
    music = "alacritty --config-file " .. os.getenv("HOME") .. "/.config/alacritty/ncmpcpp.yml --class music -e ncmpcpp",
    files = "thunar",
}

-- themes
local themes = {
    "light",
    "dark",
}

-- apply theme
local theme = themes[2]
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme/" .. theme .. ".lua")



-- error notification 
require("config.error_notif")

-- startup programs
awful.spawn.with_shell("~/.config/awesome/misc/scripts/autostart.sh", false)

-- right click menu / notifs
require("layout.menu")
require("layout.notif")

-- window properties
require("config.win_properties")

-- Wallpaper
require("config.wallpaper")

-- tags / layouts
require("config.tags")

-- signal / volume notif / bright notif / mpd notif
require("signal")
require("layout.notif.bright")
require("layout.notif.mpd")
require("layout.notif.volume")


-- sidebar widgets
require("layout.widgets.dashboard")

-- control center
require("layout.widgets.control_c")

-- bling
require("config.bling")

-- the bar 
require("layout.bar")

-- key / mouse bindings
require("config.keys")

-- rules
require("config.rules")

-- titlebar
require("layout.titlebar_top")

-- decorations
require("layout.deco.music")
require("layout.deco.term")

-- battery low notifcation
require("layout.notif.battery")


-- Garbage Collection
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)


--[[

    directories explained (idk why)

    * dirs
    config - the directory contains main configuration files like keys.lua,etc that are needed to actually use AwesomeWM
    images - this is pretty self-explanatory, its a directory for images/icons that are used in this setup.
    layout - widgets, titlebar and other UI-related things can be found here, this is the directory with most files smh.
    misc - all the miscallaneous stuff (includes bash scripts)
    mods - third-party libs.
    signal - daemons like mpd.lua that send information about certain things.
    theme - glory.lua. the file that determines what color the active titlebar should have, and other appeareance related stuff.

    * files
    helpers.lua - as it says, its a helper to make your life easier, and simplify your code.
    rc.lua - the actial config file.

    * note
    all the dirs exist just to make things simple and easy to understand, if you want you can write everything in your rc.lua
    and make a mess, and also scream at yourself. Its a good practice to speperate your code when working on big projects,

    Also credits to 
     * JavaCafe01
     * Elenapan

    ** the end **

]]
