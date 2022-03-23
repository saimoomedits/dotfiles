-- notification center

local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local naughty = require "naughty"
local wibox = require "wibox"
local helpers = require("helpers")

-- heading
local notifs_text = wibox.widget {
  font = beautiful.font_var .. "11",
  markup = "<span foreground='" .. beautiful.fg_color .. "99" .. "'>Notifications</span>",
  halign = "left",
  align = "left",
  widget = wibox.widget.textbox,
}

-- clear icon
local notifs_clear = wibox.widget {
  {
    {
      markup = "<span foreground='" .. beautiful.magenta_color .. "'></span>",
      font = "Material Icons 18",
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    margins = 13,
    widget = wibox.container.margin
  },
  bg = beautiful.bg_light_alt,
  shape = gears.shape.circle,
  widget = wibox.container.background,
}

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
  _G.notif_center_reset_notifs_container()
end)))

-- when there is no notification
local notifs_empty = wibox.widget {
  {
    nil,
    {
      nil,
      {
        {
          widget = wibox.widget.imagebox,
          image = gears.color.recolor_image(os.getenv("HOME") .. "/.config/awesome/images/notifs/no-notifs.png", "#737373"),
          forced_height =90,
          forced_width = 90,
          valign = "center",
          halign = "center",
        },
        {
          markup = "<span foreground='" .. beautiful.fg_color .. "61" .. "'>No Notifications</span>",
          align = "center",
          font = beautiful.font_var .. "13",
          valign = "center",
          widget = wibox.widget.textbox,
        },
        spacing = 7,
        layout = wibox.layout.fixed.vertical
      },
      layout = wibox.layout.align.vertical,
      expand = "none"
    },
    layout = wibox.layout.align.horizontal,
  },
  widget = wibox.container.background,
  forced_height = 200,
}

local notifs_container = wibox.widget {
  spacing = 10,
  spacing_widget = {
    {
      shape = gears.shape.rounded_rect,
      widget = wibox.container.background,
    },
    top = 2,
    bottom = 2,
    left = 6,
    right = 6,
    widget = wibox.container.margin,
  },
  forced_width = beautiful.notifs_width or 240,
  forced_height = 500,
  layout = wibox.layout.fixed.vertical,
}

local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
  notifs_container:reset(notifs_container)
  notifs_container:insert(1, notifs_empty)
  remove_notifs_empty = true
end

notif_center_remove_notif = function(box)
  notifs_container:remove_widgets(box)

  if #notifs_container.children == 0 then
    notifs_container:insert(1, notifs_empty)
    remove_notifs_empty = true
  end
end


-- notification themselves
local create_notif = function(icon, n, width)
  local time = os.date "%I:%M"
  local box = {}

  box = wibox.widget {
    {
      {
        {
          {
            image = icon,
            resize = true,
            clip_shape = helpers.rrect(6),
            halign = "center",
            valign = "center",
            widget = wibox.widget.imagebox,
          },
          strategy = "exact",
          height = 50,
          width = 50,
          widget = wibox.container.constraint,
        },
        {
          {
            nil,
            {
              {
                {
                  step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                  speed = 50,
                  {
                    markup = n.title,
                    font = beautiful.font_var .. " Bold 11",
                    align = "left",
                    widget = wibox.widget.textbox,
                  },
                  forced_width = 140,
                  widget = wibox.container.scroll.horizontal,
                },
                nil,
                {
                  markup = "<span foreground='" .. beautiful.fg_color .. "'>" .. time .. "</span>",
                  align = "right",
                  valign = "bottom",
                  font = beautiful.font_var .. "9",
                  widget = wibox.widget.textbox,
                },
                expand = "none",
                layout = wibox.layout.align.horizontal,
              },
              {
                markup = "<span foreground='" .. beautiful.fg_color .. "99" .. "'>" ..  n.message .. "</span>",
                font = beautiful.font_var .. " 10",
                align = "left",
                forced_width = 165,
                widget = wibox.widget.textbox,
              },
              spacing = 3,
              layout = wibox.layout.fixed.vertical,
            },
            expand = "none",
            layout = wibox.layout.align.vertical,
          },
          left = 15,
          widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
      },
      margins = 15,
      widget = wibox.container.margin,
    },
    forced_height = 85,
    shape = helpers.rrect(6),
    widget = wibox.container.background,
    bg = beautiful.bg_light_alt .. "4D",
  }

  -- setup
  box:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_remove_notif(box)
  end)))

  return box
end

notifs_container:buttons(gears.table.join(
  awful.button({}, 4, nil, function()
    if #notifs_container.children == 1 then
      return
    end
    notifs_container:insert(1, notifs_container.children[#notifs_container.children])
    notifs_container:remove(#notifs_container.children)
  end),

  awful.button({}, 5, nil, function()
    if #notifs_container.children == 1 then
      return
    end
    notifs_container:insert(#notifs_container.children + 1, notifs_container.children[1])
    notifs_container:remove(1)
  end)
))

notifs_container:insert(1, notifs_empty)

naughty.connect_signal("request::display", function(n)
  if #notifs_container.children == 1 and remove_notifs_empty then
    notifs_container:reset(notifs_container)
    remove_notifs_empty = false
  end

  local appicon = n.icon or n.app_icon
  if not appicon then
    appicon = beautiful.notification_icon
  end

  notifs_container:insert(1, create_notif(appicon, n, width))
end)


-- initial
local notifs = wibox.widget {
  {
    {
      {
      {
      {
        {
          notifs_text,
          nil,
          nil,
          expand = "none",
          layout = wibox.layout.align.horizontal,
        },
        left = 5,
        right = 5,
        layout = wibox.container.margin,
      },
      notifs_container,
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },  
    widget = wibox.container.margin,
    margins = 15
  },  
    bg = beautiful.bg_alt_dark,
    shape = helpers.rrect(6),
    widget = wibox.container.background
  },
    margins = {top = 5, bottom = 25, right = 20, left = 20},
    widget = wibox.container.margin
},
{
  {
    nil,
    nil,
    {
      nil, 
      nil,
      notifs_clear,
      layout = wibox.layout.align.horizontal,
      expand = "none"
    },
    expand = "none",
    layout = wibox.layout.align.vertical
  },
  margins = 35,
  widget = wibox.container.margin

},
  layout = wibox.layout.stack,
}

return notifs