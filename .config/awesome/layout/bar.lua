-- vertical wibar
-- bar.

local awful = require("awful")
local gears = require("gears")
local rubato = require("mods.rubato")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")



-- thing
screen.connect_signal("request::desktop_decoration", function(s)


-- Create a taglist widget
s.mylayoutbox = awful.widget.layoutbox(s)

-- layoutbox
local layoutbox = wibox.widget{
    s.mylayoutbox,
    margins = 8,
    widget = wibox.container.margin
}

-- import taglist widget
s.mytaglist = require("layout.taglist")(s)


-- Clock Widget 
local hourtextbox = {
    widget = wibox.widget.textclock,
    format = "%I",
    align = "center",
    valign = "center",
    font = beautiful.font_var .. "16"
}


local minutetextbox = {
    widget = wibox.widget.textclock,
    format = "<span foreground='" .. beautiful.fg_color .. "CC" .. "'>%M</span>",
    align = "center",
    valign = "center",
    font = beautiful.font_var .. "16"
}


local clock = wibox.widget {
        hourtextbox,
        minutetextbox,
        layout = wibox.layout.fixed.vertical,
        spacing = 2
}

local datetooltip = awful.tooltip {
    shape = helpers.rrect(6),
    preferred_alignments = {"middle", "front"},
    gaps = 10,
    margins_leftright = 10,
    margins_topbottom = 10,
    mode = "outside",
    text = os.date("%d/ %m/ %y")
}
datetooltip:add_to_object(clock)

-- Tasklist
local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
   awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

 -- Create a tasklist widget
 s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    align = "center",
    buttons = tasklist_buttons,
    bg = beautiful.bg_light,
    style = {
        bg = beautiful.bg_color,
        shape = helpers.rrect(5)
    },
    layout = {spacing = dpi(10), layout = wibox.layout.fixed.vertical},
    widget_template = {
        {
            awful.widget.clienticon,
            margins = dpi(6),
            layout = wibox.container.margin
        },
        id = "background_role",
        widget = wibox.container.background,
    }
}


-- battery
local batt_perc = wibox.widget {
    align  = 'center',
    valign = 'center',
    font = 'Material Icons 16',
    widget = wibox.widget.textbox
}

local batt = wibox.widget{
        color = beautiful.green_color,
        bar_shape = helpers.rrect(0),
        background_color = beautiful.fg_color .. "33",
        shape = helpers.rrect(4),
        value = 70,
        max_value = 100,
        widget = wibox.widget.progressbar,
}

local actual_batt = wibox.widget{
    {
        batt,
        forced_height = 65,
        forced_width  = 5,
        direction     = 'east',
        layout        = wibox.container.rotate,
        widget = wibox.container.background,
    },
    batt_perc,
    valign = "center",
    layout = wibox.layout.stack
}


local batt_tooltip = awful.tooltip {};
batt_tooltip.shape = helpers.rrect(6)
batt_tooltip.gaps = 10
batt_tooltip.margins_leftright = 10
batt_tooltip.margins_topbottom = 10
batt_tooltip.preferred_alignments = {"middle", "front", "back"}
batt_tooltip.mode = "outside"
batt_tooltip:add_to_object(batt_perc)


awesome.connect_signal("signal::battery", function(value) 

    batt.value = value

    batt_tooltip.text = value .. "%"
    
    awesome.connect_signal("signal::charger", function(state)
        if state then
            batt_perc.markup = "<span foreground=\"" .. beautiful.black_color .. "\"></span>"
        else
            batt_perc.markup = "<span foreground=\"" .. beautiful.black_color .. "\"></span>"
        end
    end)
end)


batt_perc:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        toggle_control_c()
    end)
))


-- launcher
local mylauncher = wibox.widget {
    widget = wibox.widget.imagebox,
    image = beautiful.awesome_icon,
    valign = "center",
    halign = "center",
}

mylauncher:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        dash_toggle()
    end),
    awful.button({ }, 3, function ()
        awful.spawn(user_likes.term)
    end)
))

-- wifi
local wifi = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "",
    font = "Material Icons 16",
    align = "center",
    valign = "center"
}
awesome.connect_signal("signal::wifi", function(net_status) 
    if net_status then
        wifi.markup = "<span foreground=\"" .. beautiful.fg_color .. "\"></span>"
    else
        wifi.markup = "<span foreground=\"" .. beautiful.fg_color .. "61" .. "\"></span>"
    end
end)








local screen_height = awful.screen.focused().geometry.height

s.mywibox = wibox({
        screen = s,
        type = "dock",
        ontop = true,
        x = 0,
        y = 0,
        width = 52,
        height = screen_height,
        visible = true
    })

s.mywibox:struts{left = s.mywibox.width}

local panel_timed = rubato.timed {
    intro = 0.2,
    awestore_compat = true,
    duration = 0.5,
    rate = 60,
    subscribed = function(pos) s.mywibox.x = pos end
}

-- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = false
        else
            c.screen.mywibox.visible = true
        end
    end
    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = true
        end
    end

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)




function bar_move_true()
        panel_timed.target = dpi(400)
end


function bar_move_false()
        panel_timed.target = 0    
end

panel_timed.target = 0

   -- init
s.mywibox.widget = wibox.widget {
    widget = wibox.container.background
         {
            layout = wibox.layout.align.vertical,
            expand = "none",
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 4,
                {
                    clock,
                    margins = {top = 12},
                    widget = wibox.container.margin
                },
            },
                    {
                        {
                            s.mytaglist,
                            margins = dpi(6),
                            widget = wibox.container.margin
                        },
                        margins = 5, 
                        widget = wibox.container.margin
                    },
            { -- bottom widgets
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(5),
                {
                {
                    {
                        actual_batt,
                        widget = wibox.container.margin,
                        margins = {left = 8, right = 8, bottom = 10 }
                    },
                    wifi,
                    {
                        {
                            layoutbox,
                            widget = wibox.container.background,
                            bg = beautiful.bg_color
                        },
                        widget = wibox.container.margin,
                        margins = {bottom = 10}
                    },
                    spacing = 7,
                    layout = wibox.layout.fixed.vertical
                },
                left = dpi(7),
                right = dpi(7),
                widget = wibox.container.margin
                },
            },
        }
    }

end)