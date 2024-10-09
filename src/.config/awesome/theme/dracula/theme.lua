local gears = require("gears")
local rnotification = require("ruled.notification")
local dpi = require("beautiful.xresources").apply_dpi

local theme = {}
local themes_path = gears.filesystem.get_dir("config") .. "theme/dracula/"

theme.wallpaper = nil
theme.font = "FreeMono 8"
theme.font_bold = "FreeMono Bold 8"

local function bg_check(name)
    local f = io.open(name, "r")

    if f ~= nil then
        io.close(f)
        return true
    end

    return false
end

-- https://github.com/dracula/dracula-theme
theme.bg_normal = "#1e2029"
theme.bg_focus = "#282a36"
theme.bg_urgent = "#ff5555"
theme.bg_minimize = "#000000"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#f8f8f2"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#f8f8f2"

-- Borders
theme.useless_gap = dpi(6)
theme.border_width = dpi(2)
theme.border_color_normal = theme.bg_normal
theme.border_color_active = "#bd93f9" -- "#6272a4"
theme.border_color_marked = "#ff79c6"

-- Titlebars
theme.titlebar_bg_focus = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_focus
theme.taglist_bg_focus = theme.bg_normal

-- Hotkeys
theme.hotkeys_modifiers_fg = "#adadad"
theme.hotkeys_border_color = theme.border_color_active

-- Menu
theme.menu_height = dpi(25)
theme.menu_width = dpi(125)

-- Icons
theme.taglist_squares_sel = themes_path .. "taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "taglist/squarez.png"
-- theme.taglist_squares_resize = "false"

-- Layout
theme.layout_tile = themes_path .. "layouts/tile.png"
theme.layout_tileleft = themes_path .. "layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "layouts/tilebottom.png"
theme.layout_tiletop = themes_path .. "layouts/tiletop.png"
theme.layout_fairv = themes_path .. "layouts/fairv.png"
theme.layout_fairh = themes_path .. "layouts/fairh.png"
theme.layout_spiral = themes_path .. "layouts/spiral.png"
theme.layout_dwindle = themes_path .. "layouts/dwindle.png"
theme.layout_max = themes_path .. "layouts/max.png"
theme.layout_fullscreen = themes_path .. "layouts/fullscreen.png"
theme.layout_magnifier = themes_path .. "layouts/magnifier.png"
theme.layout_floating = themes_path .. "layouts/floating.png"
theme.layout_cornernw = themes_path .. "layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "layouts/cornerse.png"

-- Set different colors for urgent notifications
rnotification.connect_signal("request::rules", function()
    rnotification.append_rule({
        rule = { urgency = "critical" },
        properties = { bg = theme.bg_urgent, fg = theme.fg_urgent },
    })

    rnotification.append_rule({
        rule = { urgency = "low" },
        properties = { bg = theme.bg_focus .. "90", fg = theme.fg_urgent },
    })
end)

-- Set the background if the image exists
if bg_check(themes_path .. "bg") then
    theme.wallpaper = themes_path .. "/bg"
end

return theme
