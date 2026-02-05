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
	font_size = 16,
}
config.hide_tab_bar_if_only_one_tab = true

-- Dynamic padding: only apply on wide external monitors
local function apply_dynamic_padding(window)
	local overrides = window:get_config_overrides() or {}
	local dimensions = window:get_dimensions()

	if dimensions.pixel_width > 2000 then
		overrides.window_padding = {
			left = 100,
			right = 100,
			top = 0,
			bottom = 0,
		}
	else
		overrides.window_padding = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	end

	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, pane)
	apply_dynamic_padding(window)
end)

wezterm.on("window-config-reloaded", function(window, pane)
	apply_dynamic_padding(window)
end)

-- and finally, return the configuration to wezterm
return config
