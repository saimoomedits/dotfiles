-- notification center
-- ~~~~~~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local naughty = require "naughty"
local wibox = require "wibox"
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi



-- misc/vars
-- ~~~~~~~~~

-- table of icons
local app_icons = {
    [ "firefox" ]           = { icon = "" },
    [ "discord" ]           = { icon = "" },
    [ "music" ]             = { icon = "" },
    [ "color picker" ]      = { icon = "" },
    [ "notify-send" ]       = { icon = "" },
    [ "set theme" ]         = { icon = "" }
}



-- init
-- ~~~~

-- animation bg for clear button
local animate_clear_icon_bg = wibox.widget{
    bg = beautiful.accent,
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
}

-- clear button
local notifs_clear = require("helpers.widgets.create_button")(
  {
    markup = helpers.colorize_text("Clear All", (beautiful.ext_light_fg or beautiful.fg_color)),
    font = beautiful.font_var .. "11",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  },
  beautiful.ext_light_bg_2 or beautiful.bg_3,
  beautiful.accent_3,
  {top = dpi(10), bottom = dpi(10), left = dpi(20), right = dpi(20)}
)

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
  _G.notif_center_reset_notifs_container()
end)))




-- when there is no notification
local notifs_empty = wibox.widget {
  widget = wibox.widget.textbox,
  markup = helpers.colorize_text("No Notifications", (beautiful.ext_light_fg or beautiful.fg_color)),
  font = beautiful.font_var .. "13",
  valign = "center",
  align = "center"
}

local notifs_container = wibox.widget {
  spacing = 10,
  spacing_widget = {
    {
      shape = gears.shape.rounded_rect,
      widget = wibox.container.background,
    },
    margins = {top = 2, bottom = 2, left = 6, right = 6},
    widget = wibox.container.margin,
  },
  forced_width = dpi(380),
  forced_height = dpi(535),
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



  -- app icon
    local app_icon
    local tolow = string.lower

    if app_icons[tolow(n.app_name)] then
        app_icon = app_icons[tolow(n.app_name)].icon
    else
        app_icon = ""
    end

    local app_icon_n = wibox.widget{
        {
            font        = beautiful.icon_alt_var .. "10",
            markup      = "<span foreground='" .. beautiful.black_color .. "'>".. app_icon .. "</span>",
            align       = "center",
            valign      = "center",
            widget      = wibox.widget.textbox
        },
        bg = beautiful.accent,
        widget = wibox.container.background,
        shape = gears.shape.circle,
        border_width = dpi(1),
        border_color = beautiful.ext_light_fg,
        forced_height = dpi(20),
        forced_width = dpi(20)
    }


  local message = wibox.widget{
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    {
      markup = helpers.colorize_text(n.message, (beautiful.ext_light_fg or beautiful.fg_color)),
      font = beautiful.font_var .. "10",
      align = "left",
      valign = "bottom",
      widget = wibox.widget.textbox,
    },
    forced_width = dpi(300),
    widget = wibox.container.scroll.horizontal,

  }

  local title = wibox.widget{
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    {
        {
            markup = helpers.colorize_text(n.title .. "  ", (beautiful.ext_light_fg or beautiful.fg_color)),
            font = beautiful.font_var .. " Bold 11",
            align = "left",
            valign = "center",
            widget = wibox.widget.textbox,
        },
        {
            {
                widget = wibox.widget.separator,
                shape = gears.shape.circle,
                valign = "center",
                align = "center",
                forced_width = dpi(4),
                forced_height = dpi(4),
                color = (beautiful.ext_light_fg or beautiful.fg_color) .. "E6"
            },
            {
                markup = helpers.colorize_text("  " .. time, (beautiful.ext_light_fg or beautiful.fg_color) .. "E6"),
                font = beautiful.font_var .. "10",
                align = "left",
                valign = "center",
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.layout.align.horizontal,
    },
    forced_width = dpi(300),
    widget = wibox.container.scroll.horizontal,
  }

  local image = wibox.widget{
    {
      {
          image = icon,
          resize = true,
          clip_shape = gears.shape.circle,
          halign = "center",
          valign = "center",
          widget = wibox.widget.imagebox,
      },
      strategy = "exact",
      height = dpi(50),
      width = dpi(50),
      widget = wibox.container.constraint,
    },
    {
      nil,
      nil,
      {
        nil,
        nil,
        app_icon_n,
        layout = wibox.layout.align.horizontal,
        expand = "none"
      },
      layout = wibox.layout.align.vertical,
      expand = "none"
    },
    layout = wibox.layout.stack
}




  local box = {}

  box = wibox.widget {
    {
        {
            image,
            {
                nil,
                {
                    title,
                    message,
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(3)
                },
                layout = wibox.layout.align.vertical,
                expand = "none"
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(16)
        },
        margins = dpi(15),
        widget = wibox.container.margin,
    },
    widget = wibox.container.background,
    bg = beautiful.ext_light_bg_2 or beautiful.bg_3,
    shape = helpers.rrect(dpi(6))

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
                notifs_container,
                shape = helpers.rrect(beautiful.rounded),
                widget = wibox.container.background
            },
            nil,
            {
                {
                    nil,
                    nil,
                    notifs_clear,
                    layout = wibox.layout.align.horizontal,
                    expand = "none"
                },
                margins = {left = dpi(12), right = dpi(12), bottom = dpi(10)},
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        margins = dpi(15),
        widget = wibox.container.margin
    },
    widget = wibox.container.background,
    bg = beautiful.ext_light_bg or beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded)
}

return notifs