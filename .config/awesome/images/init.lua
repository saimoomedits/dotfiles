-- sussy images
-- ~~~~~~~~~~~~


-- misc/vars
-- ~~~~~~~~~
local directory = home_var .. "/.config/awesome/images/sus/"
local ui_vars = require("theme.ui_vars")


-- init
-- ~~~~
return {

    -- images
    bell = directory .. "bell.png",
    profile = directory .. "profile.jpg",
    music_icon = directory .. "music.png",
    album_art = directory .. "album-art.png",
    awesome = directory .. "awesome.png",

    -- layouts
    layouts = {
        flair = directory .. "layouts/flair.png",
        floating = directory .. "layouts/floating.png",
        tile = directory .. "layouts/tile.png",
        layoutMachi = directory .. "layouts/layout-machi.png"
    },

    -- wallpapers
    wall = directory .."walls/" .. ui_vars.color_scheme .. ".png",
}