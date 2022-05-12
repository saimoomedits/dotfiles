-- images variables
-- ~~~~~~~~~~~~~~~~


-- misc/vars
-- ~~~~~~~~~
local directory = os.getenv("HOME") .. "/.config/awesome/images/M3/"
local ui_vars = require("theme.ui_vars")


-- init
-- ~~~~
return {

    -- images
    bell = directory .. "bell.png",
    profile = directory .. "profile.jpg",
    music_icon = directory .. "music.png",
    album_art = directory .. "album-art.png",

    -- layouts
    layouts = {
        flair = directory .. "layouts/flair.png",
        floating = directory .. "layouts/floating.png",
        tile = directory .. "layouts/tile.png",
        layoutMachi = directory .. "layouts/layout-machi.png"
    },

    extra = {
        theme_icon = directory .. "extra/theme.png",
    },

    -- wallpapers
    wall = directory .."walls/" .. ui_vars.color_scheme  ..".png",
}