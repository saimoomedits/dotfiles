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


local profile_image = wibox.widget {
    {
        image = beautiful.images.profile,
        upscale = true,
        forced_width = dpi(160),
        forced_height = dpi(160),
        clip_shape = gears.shape.circle,
        widget = wibox.widget.imagebox,
        halign = "center",
    },
    widget = wibox.container.background,
    border_width = dpi(2),
    shape = gears.shape.circle,
    border_color = beautiful.fg_color
}


local username = wibox.widget{
    widget = wibox.widget.textbox,
    markup = user_likes.username,
    font = beautiful.font_var .. "15",
    align = "center",
    valign = "center"
}


local myself = wibox.widget{
    profile_image,
    username,
    spacing = dpi(15),
    layout = wibox.layout.fixed.vertical
}

-- dummy text
local some_textbox = wibox.widget.textbox()

-- lock icon
local icon = wibox.widget{
    widget = wibox.widget.textbox,
    markup = lock_screen_symbol,
    font = beautiful.icon_var .. "14",
    align = "center",
    valign = "center"
}


-- clock
local clock = wibox.widget{
    helpers.vertical_pad(dpi(40)),
    {
        font = beautiful.font_var .. "Medium 42",
        format = helpers.colorize_text("%I:%M", beautiful.fg_color),
        widget = wibox.widget.textclock,
        align = "center",
        valign = "center"
    },
    {
        font = beautiful.font_var .. "Regular 18",
        format = helpers.colorize_text("%A, %B", beautiful.fg_color),
        widget = wibox.widget.textclock,
        align = "center",
        valign = "center"
    },
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}






-- password prompt
local promptbox = wibox.widget{
    widget = wibox.widget.textbox,
    markup = "",
    font = beautiful.icon_var .. "13",
    align = "center"
}

local promptboxfinal = wibox.widget{
    {
        {
            {
                promptbox,
                margins = {left = dpi(10)},
                widget = wibox.container.margin
            },
            nil,
            {
                icon,
                margins = {right = dpi(10)},
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal,
            expand = "none"
        },
        widget = wibox.container.margin,
        margins = dpi(10)
    },
    widget = wibox.container.background,
    bg = beautiful.fg_color .. "1A",
    forced_width = dpi(300),
    forced_height = dpi(40),
    shape = gears.shape.rounded_bar
}

-- Create the lock screen wibox
local lock_screen_box = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    bg = beautiful.bg_color .. "99",
    fg = beautiful.fg_color,
    screen = screen.primary
})

-- Create the lock screen wibox (extra)
local function create_extender(s)
    

local lock_screen_box_ext wibox({
    visible = false,
    ontop = true,
    type = "splash",
    bg = beautiful.bg_color .. "E6",
    fg = beautiful.fg_color,
    screen = s
})

awful.placement.maximize(lock_screen_box_ext)

return lock_screen_box_ext

end

awful.placement.maximize(lock_screen_box)




-- Add lockscreen to each screen
awful.screen.connect_for_each_screen(function(s)
    if s.index == 2 then
        s.mylockscreenext = create_extender(2)
        s.mylockscreen = lock_screen_box
    else
        s.mylockscreen = lock_screen_box
    end
end)


local function set_visibility(v)
    for s in screen do
        s.mylockscreen.visible = v
        if s.mylockscreenext then
            s.mylockscreenext.visible = v
        end
    end
end



-- Lock helper functions
local characters_entered = 0


-- reset function
local function reset()
    characters_entered = 0;
    promptbox.markup = helpers.colorize_text("", beautiful.red_3)
    icon.markup = lock_screen_symbol
end

-- fail function
local function fail()
    characters_entered = 0;
    promptbox.markup = helpers.colorize_text("Incorrect", beautiful.red_3)
    icon.markup = lock_screen_fail_symbol
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
                promptbox.markup = helpers.colorize_text(string.rep("", characters_entered), beautiful.fg_color)
            elseif key == "BackSpace" then
                if characters_entered > 0 then
                    characters_entered = characters_entered - 1
                end
                promptbox.markup = helpers.colorize_text(string.rep("", characters_entered), beautiful.fg_color)
            end

        end,
        exe_callback = function(input)
            -- compare input
            if lock_screen.authenticate(input) then
                -- YAY 
                reset()
                set_visibility(false)
            else
                -- NAH, JIT TRIPPIN
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
        {
            myself,
            {
                {
                    promptboxfinal,
                    layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.container.place
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(50)
        },
        layout = wibox.layout.align.vertical,
        expand = "none"
    },
    layout = wibox.layout.stack
}