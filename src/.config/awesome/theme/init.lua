local beautiful = require("beautiful")
local gears = require("gears")

-- Themes define colors, icons, font and wallpapers
beautiful.init(gears.filesystem.get_dir("config") .. "theme/dracula/theme.lua")
