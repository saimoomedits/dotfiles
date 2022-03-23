-- titlebar decorations for ncmpcpp
-- lol

local awful = require("awful")
local helpers = require("helpers")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local ruled = require("ruled")

-- progressbar
local pro_bar = wibox.widget {
         widget = wibox.widget.progressbar,
         bar_shape = helpers.rrect(3),
         forced_height = 6,
         color = beautiful.blue_color,
         background_color = beautiful.bg_light,
         value = 0,
         max_value = 1.0,
         halign = "left",
         valign = "center",
}

-- volume bar
local volume = wibox.widget {
    widget = wibox.widget.progressbar,
    color = beautiful.magenta_color,
    background_color = beautiful.bg_light,
    value = 50,
    max_value = 100,
    shape = helpers.rrect(10),
    forced_height = 7,
    forced_width = 160,
    halign = "left",
    valign = "center"

}

local volume_icon = wibox.widget {
      widget = wibox.widget.textbox,
      font = 'Material Icons 17',
      valign = "center",
      markup = '',
}

-- update volume value and also make it change on scroll
awesome.connect_signal("signal::volume", function (value)
    volume.value = value
end)
volume:buttons(gears.table.join(
    awful.button({}, 4, function() awful.spawn.with_shell("amixer -D pulse set Master 5%+") end),
    awful.button({}, 5, function() awful.spawn.with_shell("amixer -D pulse set Master 5%-") end)
))

-- song info
local text_song = wibox.widget {
      widget = wibox.widget.textbox,
      font = beautiful.font_var .. '12',
      valign = "center",
      markup = '<b>Numa Numa</b>',
}


local artist_human = wibox.widget {
      widget = wibox.widget.textbox,
      font = 'Roboto Regular 11',
      valign = "center",
      markup = '<span foreground="' .. beautiful.fg_color .. "99" .. '">Someone bordy</span>',
}

-- update info
awesome.connect_signal("signal::mpd", function(artist, title)
  text_song.markup = "<b>" .. title .. "</b>"
  artist_human.markup = "<span foreground='" .. beautiful.fg_color .. "BF'>" .. artist  .. "</span>"
end)



-- buttons
local button_size = 22

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
    image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/play.png", beautiful.fg_color),
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

-- update song progress and toggle button
local updater = function(widget, stdout, _, _, _)
  stdout = string.gsub(stdout, "\n", "")
  local mpdpercent = string.match(stdout, "(%d%d)%%")
  local mpdstatus = string.match(stdout, "%[(%a+)%]")
  if mpdstatus == "playing" then
    toggle_icon.image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/pause.png", beautiful.fg_color)
    widget.value = tonumber((mpdpercent)/100)
  elseif mpdstatus == "paused" then
    toggle_icon.image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/play.png", beautiful.fg_color)
    widget.value = tonumber(mpdpercent/100)
  else 
    toggle_icon.image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/mpd/play.png", beautiful.fg_color)
  end
end

watch("mpc status", 1, updater, pro_bar)


-- initial buttons
local mpd_buttons = wibox.widget {
  {
  {
      {
        prev_icon,
        toggle_icon,
        next_icon,
        valign = "center",
        spacing = 18,
        layout  = wibox.layout.fixed.horizontal
      },
  nil,
  layout = wibox.layout.fixed.horizontal,
  },
  margins = {left = 10, right = 30, top = 10, bottom = 10,},
  widget = wibox.container.margin
  },
      bg = beautiful.bg_alt_dark,
      shape = helpers.rrect(7),
      widget = wibox.container.background
}









-- initial
local music_init = function (c)

    -- buttons for controlling
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    -- Hide default titlebar
    awful.titlebar.hide(c)

    awful.titlebar(c, { postion = "top", size = 50, bg = beautiful.bg_color}):setup {
        {
            { -- left
                widget = wibox.widget.textbox,
                markup = '<span foreground="' .. beautiful.fg_color .. '"></span>',
                font = "Material Icons 18",
                valign = "center",
                align = "left",
                buttons = buttons
            },
            { -- middle
                widget = wibox.widget.textbox,
                markup = '<span foreground="' .. beautiful.fg_color .. "99" .. '">Playing - Music</span>',
                align = "center",
                valign = "center",
                font = beautiful.font_var .. "12",
                buttons = buttons
            },
            {
                awful.titlebar.widget.closebutton(c),
                widget = wibox.container.margin,
                margins = {top = 16, bottom = 16}
            },
            layout = wibox.layout.align.horizontal,
            expand = "none",
        },
        margins = {left = 18, right = 18},
        widget = wibox.container.margin

    }

    -- bottom
    awful.titlebar(c, { position = "bottom", size = 72 }):setup {
        {
            {
                pro_bar,
                widget = wibox.container.margin,
                margins = 0
            },
            {
                {
                    {
                        text_song,
                        artist_human,
                        spacing = 2,
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = {top = 15, right = 10, left = 30, bottom = 10},
                    widget = wibox.container.margin
                },
                {
                    volume_icon,
                    {
                        nil,
                        volume,
                        layout = wibox.layout.align.vertical,
                        expand = "none"
                    },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 12
                },
                mpd_buttons,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.layout.align.vertical
        },
        widget = wibox.container.background,
        bg = beautiful.bg_alt_dark,

    }


    c.custom_decoration = { top = true, left = true, bottom = true }

end


-- Add the titlebar whenever a new music client is spawned
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id = "music",
        rule = {instance = "music"},
        callback = music_init
    }
end)