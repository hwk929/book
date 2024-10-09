local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local widgets = require("ui")

-- Attach tags and widgets to all screens
screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag(require("config.user").tags, s, awful.layout.layouts[1])
    widgets.wibar(s)
end)

-- Using the deprecated `gears.wallpaper`
screen.connect_signal("request::wallpaper", function(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper

        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end

        gears.wallpaper.maximized(wallpaper, s, true)
        return
    end

    gears.wallpaper.set(beautiful.bg_normal)
end)
