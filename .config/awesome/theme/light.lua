----------------------------------------------
--              LIGHT AWESOME THEME         --
----------------------------------------------

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local images_path = os.getenv("HOME") .. "/.config/awesome/images"
local helpers = require("helpers")

local theme = {}


-- colors
theme.bg_color = "#e0e0e0"
theme.bg_alt = "#1e1e1e"
theme.bg_alt_dark = "#f5f5f5"
theme.bg_light = "#bdbdbd"
theme.bg_light_alt = "#e0e0e0"

theme.fg_color = "#000000"

theme.black_color = "#121212"
theme.red_color = "#ff5252"
theme.green_color = "#69f0ae"
theme.yellow_color = "#ffd740"
theme.blue_color = "#448aff"
theme.magenta_color = "#7c4dff"
theme.cyan_color = "#18ffff"


theme.dark_blue_color = "#447c9c"
theme.dark_red_color = "#cc5e5e"
theme.dark_green_color = "#8bb06b"
theme.dark_magenta_color = "#be89c4"

-- wallpaper
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/images/wall-light.jpg"

-- font
theme.font_var      = "Roboto Regular "
theme.font          = theme.font_var .. "12"

theme.bg_normal     = theme.bg_color
theme.bg_focus      = theme.bg_light
theme.bg_urgent     = theme.yellow_color
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.fg_color
theme.fg_focus      = theme.fg_color
theme.fg_urgent     = theme.bg_color
theme.fg_minimize   = theme.bg_light

-- gaps thing
theme.useless_gap         = dpi(7)
theme.border_width        = 1
theme.border_color_normal = theme.bg_color
theme.border_color_active = theme.bg_color



-- notifs
theme.notification_icon = os.getenv("HOME") .. "/.config/awesome/images/notification.png"
theme.notification_font = theme.font_var .. "12"
theme.notification_spacing = 10
theme.notification_border_radius = dpi(2)
theme.notification_border_width = dpi(0)


-- titlebar
theme.titlebar_bg_normal = theme.bg_color
theme.titlebar_bg_focus = theme.bg_color
theme.titlebars_enabled = true
theme.titlebar_close_button_normal = images_path .. "/titlebar/close_unfocus.png"
theme.titlebar_close_button_focus  = images_path .. "/titlebar/close.png"

theme.titlebar_minimize_button_normal = images_path .. "/titlebar/minimize_unfocus.png"
theme.titlebar_minimize_button_focus  = images_path .. "/titlebar/minimize.png"

theme.titlebar_maximized_button_normal_inactive = images_path .. "/titlebar/maximize_unfocus.png"
theme.titlebar_maximized_button_focus_inactive  = images_path .. "/titlebar/maximize.png"
theme.titlebar_maximized_button_normal_active = images_path .. "/titlebar/maximize_unfocus.png"
theme.titlebar_maximized_button_focus_active  = images_path .. "/titlebar/maximize_on.png"


-- You can use your own layout icons like this:
theme.layout_floating  = gears.color.recolor_image(themes_path.."default/layouts/floatingw.png", theme.fg_color)
theme.layout_tile = gears.color.recolor_image(themes_path.."default/layouts/tilew.png", theme.fg_color)
theme.layout_spiral  = gears.color.recolor_image(themes_path.."default/layouts/spiralw.png", theme.fg_color)
theme.layout_fairh = gears.color.recolor_image(themes_path.."default/layouts/fairhw.png", theme.fg_color)
theme.layout_fairv = gears.color.recolor_image(themes_path.."default/layouts/fairvw.png", theme.fg_color)

-- not in use layouts
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"

-- Generate Awesome icon:
theme.awesome_icon = images_path .. "/awesome_alt.png"


-- Task Preview
theme.task_preview_widget_border_radius = 4
theme.task_preview_widget_bg = theme.bg_normal
theme.task_preview_widget_font = theme.font_var .. "2"
theme.task_preview_widget_border_color = "#ffffff"
theme.task_preview_widget_border_width = 0
theme.task_preview_widget_margin = dpi(20)


theme.tag_preview_client_bg = theme.bg_color
theme.tag_preview_client_border_color = theme.bg_light
theme.tag_preview_client_border_radius = 8
theme.tag_preview_widget_border_radius = 8
theme.tag_preview_client_border_width = 3
theme.tag_preview_widget_bg = "#000000"
theme.tag_preview_widget_border_color = theme.bg_light
theme.tag_preview_widget_border_width = 0
theme.tag_preview_widget_margin = dpi(5)


theme.menu_font = theme.font_var .. "9"
theme.menu_bg_focus = theme.bg_alt_dark
theme.menu_fg_focus = theme.fg_normal
theme.menu_submenu_icon = os.getenv("HOME") .. "/.config/awesome/images/menu/arrow.png"
theme.menu_height = dpi(30)
theme.menu_border_radius = 200
theme.menu_width = dpi(200)

-- edge snap
theme.snap_bg = theme.bg_light
theme.snap_shape = helpers.rrect(4)


-- tasklist
theme.tasklist_bg_minimize = theme.bg_alt_dark
theme.tasklist_bg_focus = theme.bg_light_alt .. "E0"


-- Tooltips
theme.tooltip_bg = theme.bg_color
theme.tooltip_fg = theme.fg_color
theme.tooltip_border_width = 0
theme.tooltip_align = "top"
theme.tooltip_margin = "top"


theme.fade_duration = 250


return theme