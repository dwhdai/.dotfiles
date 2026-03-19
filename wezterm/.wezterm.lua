-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.window_decorations = "RESIZE"
config.font_size = 20
-- For example, changing the color scheme:
config.color_scheme = "GitHub Dark"
config.window_background_opacity = 1.0
config.window_frame = {
	font_size = 14,
}
config.hide_tab_bar_if_only_one_tab = true

-- Allow shift+enter (for Claude Code newline in tmux)
config.keys = {
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\x1b[13;2u"),
	},
}
-- Dynamic padding: only apply on external monitors wider than 3000px
-- local function apply_dynamic_padding(window)
-- 	local overrides = window:get_config_overrides() or {}
--
-- 	local use_padding = false
-- 	local success, screens = pcall(wezterm.gui.screens)
-- 	if success then
-- 		local screen = screens.active
-- 		local dims = window:get_dimensions()
-- 		use_padding = not screen.name:find("Built%-in") and dims.pixel_width > 3000
-- 	end
--
-- 	if use_padding then
-- 		overrides.window_padding = {
-- 			left = 100,
-- 			right = 100,
-- 			top = 0,
-- 			bottom = 0,
-- 		}
-- 	else
-- 		overrides.window_padding = {
-- 			left = 0,
-- 			right = 0,
-- 			top = 0,
-- 			bottom = 0,
-- 		}
-- 	end
--
-- 	window:set_config_overrides(overrides)
-- end
--
-- wezterm.on("window-resized", function(window, pane)
-- 	apply_dynamic_padding(window)
-- end)
--
-- wezterm.on("window-config-reloaded", function(window, pane)
-- 	apply_dynamic_padding(window)
-- end)

-- and finally, return the configuration to wezterm
return config
