-- Drafted music buttons widgets
-- not in use...

local awful = require("awful")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")

local button_size = 20

local prev_icon = wibox.widget  {
    widget = wibox.widget.imagebox,
    image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/prev.png", beautiful.fg_color .. "99"),
    resize = true,
    valign = "center",
    halign = "center",
    forced_width = button_size,
    forced_height = button_size,
}
prev_icon:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc -q prev")
    end)
))


local next_icon = wibox.widget  {
    widget = wibox.widget.imagebox,
    image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/next.png", beautiful.fg_color .. "99"),
    resize = true,
    valign = "center",
    halign = "center",
    forced_width = button_size,
    forced_height = button_size,
}
next_icon:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc -q next")
    end)
))


local toggle_icon = wibox.widget  {
    widget = wibox.widget.imagebox,
    image = os.getenv("HOME") .. "/.config/awesome/images/mpd/play.png",
    resize = true,
    valign = "center",
    halign = "center",
    forced_width = button_size,
    forced_height = button_size,
}
toggle_icon:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc -q toggle")
    end)
))


local hmm_icon = wibox.widget  {
    widget = wibox.widget.imagebox,
    image = os.getenv("HOME") .. "/.config/awesome/images/music.png",
    resize = true,
    valign = "center",
    halign = "center",
    forced_width = button_size,
    forced_height = button_size,
}

local mpd_buttons = wibox.widget {
  {
  {
      {
        prev_icon,
        toggle_icon,
        next_icon,
        valign = "center",
        spacing = 21,
        layout  = wibox.layout.fixed.vertical
      },
  nil,
  layout = wibox.layout.fixed.vertical,
  },
  margins = {left = 10, right = 10, top = 20, bottom = 10,},
  widget = wibox.container.margin
  },
      bg = beautiful.bg_alt_dark,
      forced_height = 140,
      shape = helpers.rrect(7),
      widget = wibox.container.background
}

local updater = function(widget, stdout, _, _, _)
  stdout = string.gsub(stdout, "\n", "")
  local mpdstatus = string.match(stdout, "%[(%a+)%]")
  if mpdstatus == "playing" then
    toggle_icon.image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/pause.png", beautiful.fg_color)
  elseif mpdstatus == "paused" then
    toggle_icon.image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/play.png", beautiful.fg_color)
  else 
    toggle_icon.image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/play.png", beautiful.fg_color)
  end
end


watch("mpc status", 1, updater )

local ll = wibox.widget {
    {
        mpd_buttons,
        layout = wibox.layout.fixed.vertical
    },
    margins = {top = 10, right = 20},
    widget = wibox.container.margin
}

return ll