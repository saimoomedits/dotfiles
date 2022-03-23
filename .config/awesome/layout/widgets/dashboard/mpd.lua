-- mpd widget
-- song widget with progress bar


local awful = require("awful")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local GET_MPD_CMD = "mpc status"



-- music icon
local icon = wibox.widget {
        id = "icon",
        widget = wibox.widget.imagebox,
        forced_height = 75,
        forced_width = 75,
        image = os.getenv("HOME") .. "/.config/awesome/images/music.png"
    }

icon:buttons(gears.table.join(
    awful.button({}, 4, function() awful.spawn.with_shell("mpc -q seek +5") end),
    awful.button({}, 5, function() awful.spawn.with_shell("mpc -q seek -5") end)
))


-- mpd status
local text_song = wibox.widget {
      widget = wibox.widget.textbox,
      font = beautiful.font_var .. '13',
      valign = "center",
      markup = 'Offline',
}


local text_status = wibox.widget {
      widget = wibox.widget.textbox,
      font = beautiful.font_var .. '11',
      valign = "center",
      markup = 'Music',
}

local artist_human = wibox.widget {
      widget = wibox.widget.textbox,
      font = beautiful.font_var .. '12',
      valign = "center",
      markup = 'artist',
}


-- connect to mpd daemon, and change the status accordingly
awesome.connect_signal("signal::mpd", function(artist, title, status)
  text_song.markup = "<b>" .. title .. "</b>"
  artist_human.markup = "<span foreground='" .. beautiful.fg_color .. "BF'>" .. artist  .. "</span>"
end)




local bar = wibox.widget {
  color = beautiful.magenta_color,
  background_color = beautiful.bg_light,
  bar_shape = helpers.rrect(2),
  shape = gears.shape.rounded_bar,
  value = 0.0,
  forced_height = 7,
  forced_width = 330,
  max_value = 1,
  widget = wibox.widget.progressbar,
}

-- music progression 
local update_graphic = function(widget, stdout, _, _, _)
  stdout = string.gsub(stdout, "\n", "")
  local mpdpercent = string.match(stdout, "(%d%d)%%")
  local mpdstatus = string.match(stdout, "%[(%a+)%]")
  if mpdstatus == "playing" then
    widget.value = tonumber((mpdpercent)/100)
    text_status.markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>Playing</span>"
  elseif mpdstatus == "paused" then
    text_status.markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>Paused</span>"
    widget.value = tonumber(mpdpercent/100)
  else 
    text_status.markup = "<span foreground='" .. beautiful.fg_color .. "99" ..  "'>mpd is stopped!</span>"
  end
end


watch(GET_MPD_CMD, 1, update_graphic, bar)

-- initial
local mpd_widget = wibox.widget{
{
  nil,
  {
    {
      nil,
      nil,
      {
        nil,
        nil,
        {
          icon,
          margins = 13,
          widget = wibox.container.margin
        },
        layout = wibox.layout.align.vertical,
        expand = "none"
      },
      expand = "none",
      widget = wibox.layout.align.horizontal,
    },
    {
      {
          text_status,
          {
              {
                  {
                      step_function = wibox.container.scroll
                          .step_functions
                          .waiting_nonlinear_back_and_forth,
                      speed = 50,
                      {
                          widget = text_song,
                      },
                      forced_width = dpi(180),
                      widget = wibox.container.scroll.horizontal
                  },
                  {
                      step_function = wibox.container.scroll
                          .step_functions
                          .waiting_nonlinear_back_and_forth,
                      speed = 50,
                      {
                          widget = artist_human,
                      },
                      forced_width = dpi(180),
                      widget = wibox.container.scroll.horizontal
                  },
                  layout = wibox.layout.fixed.vertical
              },
              bottom = dpi(0),
              widget = wibox.container.margin
          },
          {
            {
              bar,
              layout = wibox.layout.align.horizontal,
              expand = "none",
            },
            margins = {top = 5, right = 10},
            widget = wibox.container.margin
          },
          expand = "none",
          layout = wibox.layout.align.vertical
      },
      top = dpi(15),
      bottom = dpi(9),
      left = dpi(15),
      right = dpi(10),
      widget = wibox.container.margin
  },
  layout = wibox.layout.stack
},
    bg = beautiful.bg_alt_dark,
    shape = helpers.rrect(dpi(7)),
    forced_width = dpi(290),
    forced_height = dpi(140),
    widget = wibox.container.background
    },
  margins = {left = 20, right = 15, top = 10, bottom = 15},
  widget = wibox.container.margin,
}

return mpd_widget
