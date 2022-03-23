-- menu
-- awful.menu

require("awful.hotkeys_popup.keys")
local awful = require("awful")

-- sub menu
myawesomemenu = {
   { "manual", user_likes.term .. " -e man awesome" , os.getenv("HOME") .. "/.config/awesome/images/menu/awesome_menu/doc.png" },
   { "music", user_likes.music, os.getenv("HOME") .. "/.config/awesome/images/menu/awesome_menu/music.png" },
   { "edit config", user_likes.editor .. " " .. awesome.conffile , os.getenv("HOME") .. "/.config/awesome/images/menu/awesome_menu/edit.png" },
   { "code", function () awful.spawn(user_likes.code) end , os.getenv("HOME") .. "/.config/awesome/images/menu/awesome_menu/code.png" },
   { "restart", awesome.restart , os.getenv("HOME") .. "/.config/awesome/images/menu/awesome_menu/restart.png" },
   { "quit", function() awesome.quit() end , os.getenv("HOME") .. "/.config/awesome/images/menu/awesome_menu/exit.png" },
}

-- music_ctl menu
mpd_menu = {
   { "prev", function () awful.spawn("mpc prev", false) end, os.getenv("HOME") .. "/.config/awesome/images/menu/music_menu/prev.png" },
   { "toggle", function () awful.spawn("mpc toggle", false) end , os.getenv("HOME") .. "/.config/awesome/images/menu/music_menu/toggle.png" },
   { "next", function () awful.spawn("mpc next", false) end , os.getenv("HOME") .. "/.config/awesome/images/menu/music_menu/next.png" }
}


-- the thing itself
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, os.getenv("HOME") .. "/.config/awesome/images/menu/main.png" },
                                    { "music", mpd_menu, os.getenv("HOME") .. "/.config/awesome/images/menu/music.png" },
                                    { "web browser", user_likes.web , os.getenv("HOME") .. "/.config/awesome/images/menu/web.png" },
                                    { "open terminal", user_likes.term , os.getenv("HOME") .. "/.config/awesome/images/menu/term.png" }
                                  }
                        })



