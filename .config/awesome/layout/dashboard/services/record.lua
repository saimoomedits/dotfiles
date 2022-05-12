
-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local rubato = require("mods.rubato")


-- misc/vars
-- ~~~~~~~~~

local service_name = "Record"
local service_icon = ""

-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget{
    font = beautiful.icon_var .. "13",
    markup = helpers.colorize_text(service_icon, beautiful.fg_color),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "left"
}

-- name
local name = wibox.widget{
    font = beautiful.font_var .. "12",
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(service_name, beautiful.fg_color),
    valign = "center",
    align = "left"
}

-- animation :love:
local circle_animate = wibox.widget{
	widget = wibox.container.background,
	shape = gears.shape.rounded_bar,
	bg = beautiful.accent,
	forced_width = 0,
	forced_height = 0,
}

-- mix those
local alright = wibox.widget{
    {
		{
			nil,
			{
				circle_animate,
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal,
			expand = "none"
		},
        {
            {
                icon,
                name,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(8)
            },
            margins = {left = dpi(20)},
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
    forced_width = dpi(167),
    forced_height = dpi(58),
    bg = beautiful.bg_2
}



-- button press animation
  local animation_button = rubato.timed{
      pos = 0,
      rate = 60,
      intro = 0.02,
      duration = 0.14,
      awestore_compat = true,
      subscribed = function(pos)
		circle_animate.forced_width = pos
		circle_animate.forced_height = pos
      end
  }
  local animation_button_opacity = rubato.timed{
      pos = 0,
      rate = 60,
      intro = 0.08,
      duration = 0.3,
      awestore_compat = true,
      subscribed = function(pos)
		circle_animate.opacity = pos
      end
  }



  -- function that updates everything
  local function update_everything(value)
    if value then
        icon.markup = helpers.colorize_text(service_icon, beautiful.bg_color)
        name.markup = helpers.colorize_text(service_name, beautiful.bg_color)
        animation_button:set(alright.forced_width)
        animation_button_opacity:set(1)
    else
        icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color)
        name.markup = helpers.colorize_text(service_name, beautiful.fg_color)
        animation_button:set(0)
        animation_button_opacity:set(0)
    end

  end



  -- recorder script
  -- created by manilarome

-- Status variables
local status_recording = false
local status_audio = true

-- User preferences
local user_preferences = {
	save_directory = "$HOME/Videos/Recordings/",
	offset = "0,0",
	resolution = "1600x900",
	audio = true,
	mic_lvl = "100",
	fps = "40",
}


-- create local directory
local create_save_directory = function()
	local create_dir_cmd = [[
	dir="]] .. user_preferences.save_directory .. [["
	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
	fi
	]]

	awful.spawn.easy_async_with_shell(create_dir_cmd, function(stdout) end)
end

create_save_directory()

local kill_existing_recording_ffmpeg = function()
	awful.spawn.easy_async_with_shell(
		[[
		ps x | grep 'ffmpeg -video_size' | grep -v grep | awk '{print $1}' | xargs kill
		]],
		function(stdout) end
	)
end

kill_existing_recording_ffmpeg()

local turn_on_the_mic = function()
	awful.spawn.easy_async_with_shell([[
		amixer set Capture cap
		amixer set Capture ]] .. user_preferences.mic_lvl .. [[%
		]], function() end)
end

local ffmpeg_stop_recording = function()
	awful.spawn.easy_async_with_shell(
		[[
		ps x | grep 'ffmpeg -video_size' | grep -v grep | awk '{print $1}' | xargs kill -2
		]],
		function(stdout) end
	)
end


local ffmpeg_start_recording = function(audio, filename)
	local add_audio_str = " "

	if audio then
		turn_on_the_mic()
		add_audio_str = "-f pulse -ac 2 -i default"
	end

	ffmpeg_pid = awful.spawn.easy_async_with_shell([[		
		file_name=]] .. filename .. [[
		ffmpeg -video_size ]] .. user_preferences.resolution .. [[ -framerate ]] .. user_preferences.fps .. [[ -f x11grab \
		-i :0.0+]] .. user_preferences.offset .. " " .. add_audio_str .. [[ -c:v libx264 -crf 20 -profile:v baseline -level 3.0 -pix_fmt yuv420p $file_name
		]], function(stdout, stderr)
		if stderr and stderr:match("Invalid argument") then
			return
		end
	end)
end

local create_unique_filename = function(audio)
	awful.spawn.easy_async_with_shell([[
		dir="]] .. user_preferences.save_directory .. [["
		date=$(date '+%Y-%m-%d_%H-%M-%S')
		format=.mp4
		echo "${dir}${date}${format}" | tr -d '\n'
		]], function(stdout)
		local filename = stdout
		ffmpeg_start_recording(audio, filename)
	end)
end

local start_recording = function(audio_mode)
	create_save_directory()
	create_unique_filename(audio_mode)
end

local stop_recording = function()
	ffmpeg_stop_recording()
end

-- Start Recording
local sr_recording_start = function()
	status_recording = true
	update_everything(true)
	start_recording(status_audio)
	dash_toggle()
end

-- Stop Recording
local sr_recording_stop = function()
	status_audio = false
	status_recording = false
	update_everything(false)
	stop_recording()
end

awesome.connect_signal("widget::screen_recorder", function()
	sr_recording_stop()
end)

local status_checker = function()
	if status_recording then
		sr_recording_stop()
		return
	else
		sr_recording_start()
		return
	end
end

alright:buttons(gears.table.join(
	awful.button({}, 1, nil, function()
	status_checker()
end)))



return alright