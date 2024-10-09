local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local ICON_DIR = gears.filesystem.get_dir("config") .. "module/packages/icons/"
local BIN_DIR = gears.filesystem.get_dir("config") .. "module/packages/bin/"

-- Helper functions
local rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

-- Main widgets
local count = wibox.widget.textbox("<span weight='bold'> .. </span>")
local count_list = wibox.widget.textbox("")
local count_container = wibox.widget({
    {
        {
            {
                image = ICON_DIR .. "package.svg",
                widget = wibox.widget.imagebox,
            },

            margins = 2,
            widget = wibox.container.margin,
        },

        count,
        layout = wibox.layout.fixed.horizontal,
    },

    shape = rounded,
    widget = wibox.container.background,
})

local count_pop = awful.popup({
    ontop = true,
    visible = false,
    border_width = 1,
    border_color = beautiful.bg_focus,
    widget = {
        {
            count_list,

            margins = 10,
            widget = wibox.container.margin,
        },

        strategy = "min",
        width = 350,
        widget = wibox.container.constraint,
    },

    shape = rounded,
})

-- Track updates
local update = function()
    count.markup = "<span weight='bold'> .. </span>"

    awful.spawn.easy_async_with_shell(BIN_DIR .. "check", function(stdout)
        local u = tonumber(stdout)

        if u ~= nil then
            count.markup = "<span weight='bold'> " .. tostring(u) .. "x </span>"
        end
    end)
end

awesome.connect_signal("signal::packages_upgrade", update)
awful.placement.top_right(count_pop, {
    margins = { top = 30, right = 10 },
    parent = awful.screen.focused(),
})

gears.timer({
    timeout = 120,
    call_now = true,
    autostart = true,
    callback = update,
})

-- Handle popup
count_container:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        count_pop.visible = not count_pop.visible
        count_pop.screen = awful.screen.focused()

        if count_pop.visible then
            awful.placement.top_right(count_pop, {
                margins = { top = 30, right = 10 },
                parent = awful.screen.focused(),
            })

            count_container:set_bg(beautiful.bg_focus)
            count_list.markup = "..."

            awful.spawn.easy_async_with_shell(BIN_DIR .. "list", function(stdout)
                count_list.markup = stdout
            end)
        else
            count_container:set_bg("#00000000")
        end
    elseif button == 3 then
        update()
    end
end)

return count_container
