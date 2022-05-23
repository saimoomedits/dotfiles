-- a minimal bar
-- ~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local helpers       = require("helpers")
local dpi           = beautiful.xresources.apply_dpi



-- misc/vars
-- ~~~~~~~~~





-- connect to screen
-- ~~~~~~~~~~~~~~~~~
awful.screen.connect_for_each_screen(function(s)

-- screen width
local screen_height = s.geometry.height




    -- widgets
    -- ~~~~~~~

    -- taglist
    local taglist = require("layout.bar.taglist")(s)


    -- launcher {{
    local launcher = wibox.widget{
        widget = wibox.widget.textbox,
        markup = helpers.colorize_text("", beautiful.fg_color),
        font = beautiful.icon_var .. "21",
        align = "center",
        valign = "center",
    }

    launcher:buttons(gears.table.join({
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(require("misc").rofiCommand, false)
        end)

    }))
    -- }}



    -- wifi
    local wifi = wibox.widget{
        markup = "",
        font = beautiful.icon_var .. "15",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }

    -- cc
    local cc_ic = wibox.widget{
        markup = "",
        font = beautiful.icon_var .. "17",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }


    --------------------
    -- battery widget
    local bat_icon = wibox.widget{
        markup = "<span foreground='" .. beautiful.black_color .. "'></span>",
        font = beautiful.icon_var .. "10",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local battery_progress = wibox.widget{
    	color				= beautiful.green_color,
    	background_color	= beautiful.fg_color .. "00",
        forced_width        = dpi(27),
        border_width        = dpi(0.5),
        border_color        = beautiful.fg_color .. "A6",
        paddings             = dpi(2),
        bar_shape           = helpers.rrect(dpi(2)),
    	shape				= helpers.rrect(dpi(4)),
        value               = 70,
    	max_value 			= 100,
        widget              = wibox.widget.progressbar,
    }

    local battery_border_thing = wibox.widget{
            wibox.widget.textbox,
            widget = wibox.container.background,
            border_width        = dpi(0),
            bg = beautiful.fg_color .. "A6",
            forced_width = dpi(9.4),
            forced_height = dpi(9.4),
            shape = function(cr, width, height)
                gears.shape.pie(cr,width, height, 0, math.pi)
            end
    }

    local battery = wibox.widget{
        {
            {
                {
                    battery_border_thing,
                    direction = "south",
                    widget = wibox.container.rotate
                },
                {
                    battery_progress,
                    direction = "east",
                    widget = wibox.container.rotate()
                },
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(-4)
            },
            {
                bat_icon,
                margins = {top = dpi(3)},
                widget = wibox.container.margin,
            },
            layout = wibox.layout.stack,
        },
        widget = wibox.container.margin,
        margins = {left = dpi(7.47),right = dpi(7.47)}
    }
    -- Eo battery
    -----------------------------------------------------



    cc_ic:buttons{gears.table.join(
        awful.button({ }, 1, function ()
            cc_toggle(s)
        end)
    )}



    -- clock
    ---------------------------
    local clock = wibox.widget{
        {
            widget = wibox.widget.textclock,
            format = "%I",
            font = beautiful.font_var .. "Bold 12",
            valign = "center",
            align = "center"
        },
        {
            widget = wibox.widget.textclock,
            format = "%M",
            font = beautiful.font_var .. "Medium 12",
            valign = "center",
            align = "center"
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(3)
    }
    -- Eo clock
    ------------------------------------------




    -- update widgets accordingly
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~
    awesome.connect_signal("signal::battery", function(value, state)
        battery_progress.value = value


        if state == 1 then
            bat_icon.visible = true
        else
            bat_icon.visible = false
        end

    end)

    awesome.connect_signal("signal::wifi", function (value)
        if value then
            wifi.markup = helpers.colorize_text("", beautiful.fg_color .. "CC")
        else
            wifi.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
        end
        
    end)


    -- wibar
    s.wibar_wid = awful.wibar({
        screen      = s,
        visible     = true,
        ontop       = false,
        type        = "dock",
        width      = dpi(48),
        shape       = helpers.rrect(beautiful.rounded - 5),
        bg          =  beautiful.bg_color,
        height       = screen_height - beautiful.useless_gap * 4
    })


    -- wibar placement
    awful.placement.left(s.wibar_wid, {margins = beautiful.useless_gap * 2})
    s.wibar_wid:struts{left = s.wibar_wid.width + beautiful.useless_gap * 2 }


    -- bar setup
    s.wibar_wid:setup {
        {
            launcher,
            {
                taglist,
                margins = {left = dpi(8), right = dpi(8)},
                widget = wibox.container.margin
            },
            {
                {
                    battery,
                    margins = {left = dpi(8), right = dpi(8)},
                    widget = wibox.container.margin
                },
                {
                    cc_ic,
                    clock,
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(20)
                },
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(20)
            },
            layout = wibox.layout.align.vertical,
            expand = "none"
        },
        layout = wibox.container.margin,
        margins = {top = dpi(10), bottom = dpi(14)}
    }

end)