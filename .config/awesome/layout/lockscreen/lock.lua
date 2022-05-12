-- Lockscreen
-- ~~~~~~~~~~~~~~~~~~~~
-- edited from elenapan


-- Requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local lock_screen = require("layout.lockscreen")
local dpi = beautiful.xresources.apply_dpi

-- misc/vars
-- ~~~~~~~~~

local lock_screen_symbol = ""
local lock_screen_fail_symbol = ""



-- widgets themselves
-- ~~~~~~~~~~~~~~~~~~


-- profile overlay
local pfp_overlay = wibox.widget{
    widget = wibox.container.background,
    bg = "#00000000",
    shape = gears.shape.circle
}

-- lock icon
local icon = wibox.widget{
    widget = wibox.widget.textbox,
    markup = lock_screen_symbol,
    font = beautiful.icon_var .. "24",
    align = "center",
    valign = "center"
}


-- clock
local clock = wibox.widget{
    helpers.vertical_pad(120),
    {
        font = beautiful.font_var .. "Medium 62",
        format = helpers.colorize_text("%I:%M", beautiful.fg_color),
        widget = wibox.widget.textclock,
        align = "center",
        valign = "center"
    },
    {
        font = beautiful.font_var .. "Medium 14",
        format = "%A, %B %Y",
        widget = wibox.widget.textclock,
        align = "center",
        valign = "center"
    },
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}


-- wrong password text
local wrong_password = wibox.widget{
    widget = wibox.widget.textbox,
    markup = "<span foreground='" .. beautiful.red_color .. "'>Password Incorrect!</span>",
    font = beautiful.font_var .. "Light 14",
    align = "center",
    valign = "center",
    visible = false,
}






-- dummy text
local some_textbox = wibox.widget.textbox()


-- Create the lock screen wibox
local lock_screen_box = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    bg = beautiful.black_color .. "CC",
    fg = beautiful.fg_color,
    screen = screen.primary
})

awful.placement.maximize(lock_screen_box)




-- Add lockscreen to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.mylockscreen = lock_screen_box
    end
end)


local function set_visibility(v)
    for s in screen do
        s.mylockscreen.visible = v
    end
end

-- Lock animation
local lock_animation_widget_rotate = wibox.container.rotate()

local arc = function()
    return function(cr, width, height)
        gears.shape.arc(cr, width, height, dpi(5), 0, math.pi/2, true, true)
    end
end

local lock_animation_arc = wibox.widget {
    shape = arc(),
    bg = "#00000000",
    forced_width = dpi(80),
    forced_height = dpi(80),
    widget = wibox.container.background
}



-- main widget
local lock_animation_widget = {
    layout = wibox.layout.stack,
    {
        lock_animation_arc,
        widget = lock_animation_widget_rotate,
    },
    icon
}


-- Lock helper functions
local characters_entered = 0

-- reset function
local function reset()
    characters_entered = 0;
    lock_animation_widget_rotate.direction = "north"
    lock_animation_arc.bg = "#00000000"
end

-- fail function
local function fail()
    characters_entered = 0;
    wrong_password.visible = true
    lock_animation_widget_rotate.direction = "north"
    pfp_overlay.bg = beautiful.red_color .. "1A"
    icon.markup = "<span foreground='" .. beautiful.red_color .. "'>" .. lock_screen_fail_symbol .. "</span>"
    lock_animation_arc.bg = "#00000000"
end

-- animation rotation directions
local animation_directions = {"north", "west", "south", "east"}


-- animation function
local function key_animation(char_inserted)
    local color
    local direction = animation_directions[(characters_entered % 4) + 1]
    if char_inserted then
        color = beautiful.accent
    else
        if characters_entered == 0 then
            reset()
        else
            color = beautiful.red_color .. "55"
        end
    end

    lock_animation_arc.bg = color
    icon.markup = "<span foreground='" .. beautiful.fg_color .. "'>" .. lock_screen_symbol .. "</span>"
    pfp_overlay.bg = "#00000000"
    lock_animation_widget_rotate.direction = direction
end


-- user input
local function grab_password()
    awful.prompt.run {
        hooks = {
            {{ }, 'Escape',
                function(_)
                    reset()
                    grab_password()
                end
            },
            {{ 'Control' }, 'Delete', function ()
                reset()
                grab_password()
            end}
        },
        keypressed_callback  = function(mod, key, cmd)
            if #key == 1 then
                characters_entered = characters_entered + 1
                key_animation(true)
            elseif key == "BackSpace" then
                if characters_entered > 0 then
                    characters_entered = characters_entered - 1
                end
                key_animation(false)
            end

        end,
        exe_callback = function(input)
            -- compare input
            if lock_screen.authenticate(input) then
                -- YAY 
                reset()
                set_visibility(false)
            else
                -- NAY
                fail()
                grab_password()
            end
        end,
        textbox = some_textbox,
    }
end


-- show lockscreen func
function lock_screen_show()
    set_visibility(true)
    grab_password()
end





-- init
-- ~~~~
lock_screen_box:setup {
    {
        clock,
        nil,
        {
            lock_animation_widget,
            margins = {bottom = dpi(40)},
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.vertical,
        expand = "none"
    },
    layout = wibox.layout.stack
}