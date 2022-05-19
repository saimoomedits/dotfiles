
-- requirements
local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")


-- notification themselves
return function(icon, n, width)
  local time = os.date "%I:%M"


    -- table of icons
    local app_icons = {
        [ "firefox" ]           = { icon = "" },
        [ "discord" ]           = { icon = "" },
        [ "music" ]             = { icon = "" },
        [ "color picker" ]      = { icon = "" },
        [ "notify-send" ]       = { icon = "" },
        [ "set theme" ]         = { icon = "" }
    }
   

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
    bg = beautiful.bg_3 .. "E6",
    shape = helpers.rrect(dpi(6))

  }

  -- setup
  box:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_remove_notif(box)
  end)))

  return box
end