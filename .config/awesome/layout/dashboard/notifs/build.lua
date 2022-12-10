-- notification center
----------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local naughty = require "naughty"
local wibox = require "wibox"
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi




-- clear button
-------------------------------------------------------------------
local notifs_clear = require("layout.dashboard.notifs.clear_button")

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
  _G.notif_center_reset_notifs_container()
end)))
--------------------------------------------------------------------



-- empty box
-------------------------------------------------------------------
local notifs_empty = require("layout.dashboard.notifs.notifs-empty")
--------------------------------------------------------------------


-- Create notif
--------------------------------------------------------------
local create_notif = require("layout.dashboard.notifs.creator")
---------------------------------------------------------------


-- Notifs container
--------------------------------------------------------------------
local notifs_container = require("layout.dashboard.notifs.container")
--------------------------------------------------------------------







-- Helper functions
-------------------------------
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
--------------------------------------------------




-- update functions
----------------------------------------
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

  notifs_container:insert(1, create_notif(appicon, n))
end)
-------------------------------------------------------





-----------------------------------------------
-----------------------------------------------
return wibox.widget {
    {
      {
          {
              {
                  widget = wibox.widget.textbox,
                  markup = helpers.colorize_text("Notifications", beautiful.fg_color .. "99"),
                  font = beautiful.font_var .. "11"
              },
              nil,
              notifs_clear,
              layout = wibox.layout.align.horizontal
          },
          {
              notifs_container,
              nil,
              layout = wibox.layout.align.vertical,
              expand = "none"
          },
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(20)
      },
        margins = dpi(20),
        widget = wibox.container.margin
    },
    widget = wibox.container.background,
    bg = beautiful.bg_2,
    shape = helpers.rrect(beautiful.rounded)
}
-----------------------------------------------
-----------------------------------------------

-- eof
------
