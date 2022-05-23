-- keybinds haha
-- ~~~~~~~~~~~~~


-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local lmachi        = require("mods.layout-machi")
local bling         = require("mods.bling")
local misc          = require("misc")
require("layout.lockscreen").init()


-- vars/misc
-- ~~~~~~~~~

-- modkey
local modkey    = "Mod4"

-- modifer keys
local shift     = "Shift"
local ctrl      = "Control"
local alt       = "Mod1"


-- Configurations
-- ~~~~~~~~~~~~~~

-- mouse keybindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})


-- launchers
awful.keyboard.append_global_keybindings({

	awful.key({ modkey }, "Return", function()
		awful.spawn(user_likes.term)
	end,
    { description = "open terminal", group = "launcher" }),

	awful.key({ modkey }, "s", function()
		awful.spawn(user_likes.music)
	end,
    { description = "launch music client", group = "launcher" }),

	awful.key({ modkey }, "b", function()
		awful.spawn.with_shell(user_likes.web)
	end, 
    { description = "open web browser", group = "launcher" }),

	awful.key({ modkey }, "e", function()
        awful.spawn(misc.rofiCommand)
	end,
    { description = "open rofi", group = "launcher" }),

	awful.key({ modkey }, "r", function()
        awful.spawn(home_var .. "/.scripts/awesome/picker", false)
	end, 
    { description = "exec color picker", group = "launcher" }),

	awful.key({ modkey }, "a", function()
        cc_toggle(screen.primary)
	end,
    { description = "toggle control center", group = "launcher" }),

	awful.key({ modkey }, "d", function()
        lock_screen_show()
	end,
    { description = "show lockscreen", group = "launcher" }),



})



-- control/media
awful.keyboard.append_global_keybindings({

    awful.key({}, "XF86MonBrightnessUp",  function() 
        awful.spawn("brightnessctl set 5%+ -q", false) 
    end,
    {description = "increase brightness", group = "control"}),


    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("brightnessctl set 5%- -q", false) 
    end,
    {description = "decrease brightness", group = "control"}),


    awful.key({}, "Print", function() 
        awful.util.spawn(home_var .. "/.scripts/awesome/ss area", false)
    end,
    {description = "screenshot", group = "control"}),


    awful.key({}, "XF86AudioRaiseVolume",
            function() awful.spawn("amixer -D pulse set Master 5%+", false) 
    end,
    {description = "increase volume", group = "control"}),


    awful.key({}, "XF86AudioLowerVolume",
            function() awful.spawn("amixer -D pulse set Master 5%-", false) 
    end,
    {description = "decrease volume", group = "control"}),


    awful.key({}, "XF86AudioMute", function() 
        awful.spawn("amixer -D pulse set Master 1+ toggle", false) 
    end,
    {description = "mute volume", group = "control"}),


    awful.key({modkey }, "F2", function() 
        misc.musicMenu()
    end,
    {description = "screenshot", group = "control"}),

})



-- awesome yeah!
awful.keyboard.append_global_keybindings({

    awful.key({ modkey },       "F1",      hotkeys_popup.show_help,
              {description="show this help window", group="awesome"}),

    awful.key({ modkey, ctrl }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, shift }, "c", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, shift }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey }, "v", function () require("mods.exit-screen") awesome.emit_signal('module::exit_screen:show') end,
              {description = "show exit screen", group = "modules"}),

})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tags"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Left",
        function ()
            awful.client.focus.bydirection("left")
            bling.module.flash_focus.flashfocus(client.focus)
        end,
    {description = "focus left", group = "client"}),


    awful.key({ modkey }, "Right",
        function ()
            awful.client.focus.bydirection("right")
            bling.module.flash_focus.flashfocus(client.focus)
        end,
    {description = "focus right", group = "client"}),


    awful.key({ modkey }, "Tab",
        function ()
            awesome.emit_signal("bling::window_switcher::turn_on")
        end,
        {description = "window switcher", group = "client"}),

    awful.key({ modkey, ctrl }, "j", function () 
        awful.screen.focus_relative( 1) 
    end,
    {description = "focus the next screen", group = "screen"}),


    awful.key({ modkey, ctrl }, "k", function () 
        awful.screen.focus_relative(-1) 
    end,
    {description = "focus the previous screen", group = "screen"}),


    awful.key({ modkey, ctrl }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
    {description = "restore minimized", group = "client"}),
})


-- Layout related keybindings
awful.keyboard.append_global_keybindings({

    awful.key({ modkey, shift   }, "d", function () awful.client.swap.byidx(  1)                end,
              {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey, shift   }, "a", function () awful.client.swap.byidx( -1)                end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)            end,
              {description = "increase master width factor", group = "layout"}),

    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)            end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey, shift   }, "h",     function () awful.tag.incnmaster( 1, nil, true)     end,
              {description = "increase the number of master clients", group = "layout"}),

    awful.key({ modkey, shift   }, "l",     function () awful.tag.incnmaster(-1, nil, true)     end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, ctrl }, "h",     function () awful.tag.incncol( 1, nil, true)           end,
              {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, ctrl }, "l",     function () awful.tag.incncol(-1, nil, true)           end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                  end,
              {description = "select next", group = "layout"}),

    awful.key({ modkey, shift   }, "space", function () awful.layout.inc(-1)                    end,
              {description = "select previous", group = "layout"}),


    -- layout machi
	awful.key({ modkey }, ".", function()
		lmachi.default_editor.start_interactive()                                               end, 
    { description = "edit current layout", group = "layout" }),

	awful.key({ modkey, shift }, ".", function()
		lmachi.switcher.start(client.focus)                                                     end, 
    { description = "switch between windows for a machi layout", group = "layout" }),

})




-- tag related keys
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },

    awful.key {
        modifiers   = { modkey, ctrl },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },

    awful.key {
        modifiers = { modkey, shift },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { modkey, ctrl, shift },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})


-- mouse mgmt
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({

        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),

        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),

        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),

    })
end)


-- client mgmt
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "c",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
        {description = "toggle fullscreen", group = "client"}),


        awful.key({ modkey }, "q",      function (c) c:kill() end,
                {description = "close", group = "client"}),

        awful.key({ modkey }, "x",  awful.client.floating.toggle,
                {description = "toggle floating", group = "client"}),


        awful.key({ modkey, ctrl }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),


        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),


        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),


        awful.key({ modkey,           }, "n",
            function (c)
                c.minimized = true
            end ,
        {description = "minimize", group = "client"}),


        awful.key({ modkey,           }, "z",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
        {description = "(un)maximize", group = "client"}),

    })

end)