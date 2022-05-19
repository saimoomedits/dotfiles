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




-- clear button
-------------------------------------------------------------------
local notifs_clear = require("layout.dashboard.notifs.clear")

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
                notifs_container,
                shape = helpers.rrect(beautiful.rounded),
                widget = wibox.container.background,
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
    bg = beautiful.bg_2,
    forced_height = dpi(470),
    shape = helpers.rrect(beautiful.rounded)
}
-----------------------------------------------
-----------------------------------------------