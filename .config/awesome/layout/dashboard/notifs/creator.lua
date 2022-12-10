
-- requirements
local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")


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
        [ "set theme" ]         = { icon = "" },
        [ "terminal" ]          = { icon = "" },
        [ "runner" ]          = { icon = "" }
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
            font        = beautiful.icon_alt_var .. "11",
            markup      = "<span foreground='" .. beautiful.accent .. "'>".. app_icon .. "</span>",
            align       = "center",
            valign      = "center",
            widget      = wibox.widget.textbox
        },
        bg = beautiful.accent .. "1A",
        widget = wibox.container.background,
        forced_height = dpi(20),
        forced_width = dpi(35)
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
        layout = wibox.layout.align.horizontal,
    },
    widget = wibox.container.scroll.horizontal,
  }

    local app_name_n = wibox.widget{
            markup      = helpers.colorize_text(n.app_name, beautiful.fg_color .. "BF"),
            font        = beautiful.font_var .. " 10",
            align       = "left",
            valign      = "center",
            widget      = wibox.widget.textbox
    }

local time_text = wibox.widget{
    markup = helpers.colorize_text(time, (beautiful.ext_light_fg or beautiful.fg_color) .. "E6"),
    font = beautiful.font_var .. "9",
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox,
}

  local image = wibox.widget{
      {
          image = icon,
          resize = true,
          halign = "center",
          valign = "center",
          widget = wibox.widget.imagebox,
      },
      strategy = "exact",
      height = dpi(38),
      width = dpi(38),
      widget = wibox.container.constraint,
}



    -- action widget
    local action_widget = {
        {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                font = beautiful.font_var .. "10",
                widget = wibox.widget.textbox
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin
        },
        bg = beautiful.bg_3,
        forced_height = dpi(30),
        shape = helpers.rrect(beautiful.rounded - 4),
        widget = wibox.container.background
    }


    -- actions
    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
          action_widget,
          bottom = dpi(15),
          widget = wibox.container.margin
        },
        style = {underline_normal = false, underline_selected = true},
        widget = naughty.list.actions
    }


    local close = wibox.widget {
        markup      = helpers.colorize_text("", beautiful.red_color),
        font        = beautiful.icon_var .. " 12",
        align       = "ceneter",
        valign      = "center",
        widget      = wibox.widget.textbox
    }




  local box = {}

  box = wibox.widget {
    {
        {
          {
              {
                  app_icon_n,
                  app_name_n,
                  layout = wibox.layout.fixed.horizontal,
                  spacing = dpi(10)
              },
              nil,
              {
                {
                  time_text,
                  close,
                  layout = wibox.layout.fixed.horizontal,
                  spacing = dpi(15)
                },
                  margins = {right = dpi(10)},
                  widget = wibox.container.margin
              },
              layout = wibox.layout.align.horizontal,
              expand = "none"
            },
            widget = wibox.container.background,
            bg = beautiful.fg_color .. "0D",
            forced_height = dpi(35)
        },
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
                spacing = dpi(20)
            },
            margins = {right = dpi(15), left = dpi(15), bottom = dpi(20), top = dpi(25)},
            widget = wibox.container.margin,
        },
        {
          actions,
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.background,
    bg = beautiful.bg_3,
    shape = helpers.rrect(beautiful.rounded - 2)

  }

  -- setup
    close:buttons(gears.table.join(awful.button({}, 1, function()
      _G.notif_center_remove_notif(box)
    end)))

  return box
end
