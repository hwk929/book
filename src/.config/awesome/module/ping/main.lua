local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ping_exec = require("module.ping.ping")
local ping_list = require("module.ping.list")

local ICON_DIR = gears.filesystem.get_dir("config") .. "module/ping/icons/"

-- Helper functions
local rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

-- Main widgets
local ping = wibox.widget.textbox("<span weight='bold'> ?/? </span>")
local ping_container = wibox.widget({
    {
        {
            {
                image = ICON_DIR .. "connection.png",
                widget = wibox.widget.imagebox,
            },

            margins = 2,
            widget = wibox.container.margin,
        },

        ping,
        layout = wibox.layout.fixed.horizontal,
    },

    shape = rounded,
    widget = wibox.container.background,
})

local ping_pop = awful.popup({
    ontop = true,
    visible = false,
    border_width = 1,
    border_color = beautiful.bg_focus,
    offset = { y = 5 },
    widget = {},

    shape = rounded,
})

local hosts_container = { layout = wibox.layout.fixed.vertical }
local refresh_button = wibox.widget({
    {
        {
            markup = "<span weight='bold'>Refresh All</span>",
            align = "center",
            forced_width = 200,
            widget = wibox.widget.textbox,
        },

        forced_height = 25,
        layout = wibox.layout.fixed.horizontal,
    },

    bg = beautiful.bg_focus,
    widget = wibox.container.background,
})

-- Track updates
local function update_hosts()
    ping_pop:setup({
        hosts_container,
        refresh_button,

        layout = wibox.layout.fixed.vertical,
    })
end

awesome.connect_signal("signal::ping_update", function(hosts)
    local failed = 0
    local finished = false
    local icons = {
        [-1] = ICON_DIR .. "loading.png",
        [0] = ICON_DIR .. "connected.png",
        [1] = ICON_DIR .. "disconnected.png",
    }

    hosts_container = { layout = wibox.layout.fixed.vertical }

    for _, v in pairs(hosts) do
        local ico = v.status
        local txt = ""

        if v.status < -1 or v.status > 1 then
            ico = 1
        end

        if v.status ~= 0 and v.status ~= -1 then
            txt = " (" .. v.status .. ")"
            failed = failed + 1
        end

        hosts_container[#hosts_container + 1] = {
            {
                {
                    image = icons[ico],
                    widget = wibox.widget.imagebox,
                },

                margins = 4,
                widget = wibox.container.margin,
            },

            {
                markup = "<span weight='bold'> " .. v.name .. txt .. " </span>",
                widget = wibox.widget.textbox,
            },

            forced_height = 25,
            forced_width = 200,
            layout = wibox.layout.fixed.horizontal,
        }

        finished = v.status ~= -1
    end

    if ping_pop.visible then
        update_hosts()
    end
    if finished then
        ping.markup = "<span weight='bold'> " .. (#ping_list.list - failed) .. "/" .. #ping_list.list .. " </span>"
        return
    end

    ping.markup = "<span weight='bold'> ?/" .. #ping_list.list .. " </span>"
end)

-- Handle popup
ping_container:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        ping_pop.visible = not ping_pop.visible
        ping_pop.screen = awful.screen.focused()

        if ping_pop.visible then
            awful.placement.top_right(ping_pop, {
                margins = { top = 30, right = 10 },
                parent = awful.screen.focused(),
            })

            ping_pop:move_next_to(mouse.current_widget_geometry)
            ping_container:set_bg(beautiful.bg_focus)
            update_hosts()
        else
            ping_container:set_bg("#00000000")
        end
    end
end)

refresh_button:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        ping_exec(ping_list.list, ping_list.amt)
    end
end)

awful.placement.top_right(ping_pop, {
    margins = { top = 30, right = 10 },
    parent = awful.screen.focused(),
})

-- Animations
refresh_button:connect_signal("mouse::enter", function()
    refresh_button.bg = beautiful.bg_normal
end)
refresh_button:connect_signal("mouse::leave", function()
    refresh_button.bg = beautiful.bg_focus
end)
refresh_button:connect_signal("button::press", function()
    refresh_button.bg = beautiful.bg_focus
end)
refresh_button:connect_signal("button::release", function()
    refresh_button.bg = beautiful.bg_normal
end)

-- Create timer
gears.timer({
    timeout = ping_list.freq,
    autostart = true,
    callback = function()
        ping_exec(ping_list.list, ping_list.amt)
    end,
})

ping_exec(ping_list.list, ping_list.amt)

return ping_container
