-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.window_decorations = "RESIZE"
config.font_size = 20
-- For example, changing the color scheme:
config.color_scheme = "duskfox"
config.window_background_opacity = 1.0
config.window_frame = {
	font_size = 16,
}
-- and finally, return the configuration to wezterm
return config
