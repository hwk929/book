local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

math.randomseed(os.time())

local ICON_DIR = gears.filesystem.get_dir("config") .. "module/notification/icons/"
local WIDTH, HEIGHT = 500, 500
local MAX_NOTIFICATIONS = 5

local notify_list = { layout = wibox.layout.fixed.vertical }

-- Helper functions
local rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

local function uuid()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

    return string.gsub(template, "[xy]", function(c)
        return string.format("%x", (c == "x") and math.random(0, 0xf) or math.random(8, 0xb))
    end)
end

-- Main widgets
local notif_header = wibox.widget.textbox("...")
local clear_button = wibox.widget({
    {
        {
            markup = "<span weight='bold'>x</span>",
            align = "center",
            forced_width = 20,
            widget = wibox.widget.textbox,
        },

        forced_height = 20,
        layout = wibox.layout.fixed.horizontal,
    },

    shape = rounded,
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
})

-- Main functions
local function remove(id)
    local notify_new = { layout = wibox.layout.fixed.vertical }

    for key in pairs(notify_list) do
        if key ~= "layout" and tonumber(key) ~= nil and notify_list[key]._ID ~= id then
            notify_new[#notify_new + 1] = notify_list[key]
        end
    end

    notify_list = notify_new
    awesome.emit_signal("signal::notification_redraw")
end

local function add(n)
    local title = n.title
    local message = n.message

    local id = uuid()
    local time = os.time()
    local close_button = wibox.widget({
        {
            {
                markup = "<span weight='bold'>  Close  </span>",
                align = "center",
                widget = wibox.widget.textbox,
            },

            forced_height = 25,
            layout = wibox.layout.fixed.horizontal,
        },

        bg = beautiful.bg_focus .. "44",
        widget = wibox.container.background,
    })

    local icon = {
        wibox.widget.imagebox(n.icon),

        forced_height = 48,
        forced_width = 48,
        halign = "center",
        valign = "center",
        widget = wibox.container.place,
    }

    if title == "" then
        title = "Awesome - No Title"
    end
    if message == "" then
        message = "..."
    end
    if not n.icon then
        icon = nil
    end

    -- Animations
    close_button:connect_signal("mouse::enter", function()
        close_button.bg = beautiful.bg_focus
    end)
    close_button:connect_signal("mouse::leave", function()
        close_button.bg = beautiful.bg_focus .. "44"
    end)
    close_button:connect_signal("button::press", function(_, _1, _2, button)
        if button == 1 then
            remove(id)
        end
    end)

    table.insert(notify_list, 1, {
        _ID = id,
        _DATE = time,

        {
            {
                -- Titlebar
                {
                    {
                        {
                            wrap = "word_char",
                            text = title,
                            widget = wibox.widget.textbox,
                        },

                        widget = wibox.container.margin,
                        margins = 8,
                    },

                    bg = beautiful.titlebar_bg_normal .. "44",
                    widget = wibox.container.background,
                },

                -- Message box
                {
                    {
                        {
                            icon,

                            {
                                wibox.widget.textbox(n.message),

                                left = 5,
                                right = 5,
                                widget = wibox.container.margin,
                            },

                            widget = wibox.layout.fixed.horizontal,
                        },

                        margins = 4,
                        widget = wibox.container.margin,
                    },

                    bg = beautiful.titlebar_bg_normal,
                    widget = wibox.container.background,
                },

                -- Time
                {
                    close_button,
                    nil,

                    {
                        {
                            {
                                markup = "<span>" .. os.date("%I:%M%p", time) .. "  </span>",
                                align = "right",
                                forced_width = WIDTH,
                                widget = wibox.widget.textbox,
                            },

                            forced_height = 25,
                            layout = wibox.layout.fixed.horizontal,
                        },

                        bg = beautiful.bg_focus .. "44",
                        widget = wibox.container.background,
                    },

                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },

                widget = wibox.layout.fixed.vertical,
            },

            strategy = "min",
            width = WIDTH,
            forced_width = WIDTH,
            widget = wibox.container.constraint,
        },

        top = 10,
        bottom = 10,
        widget = wibox.container.margin,
    })
end

local function clear()
    notify_list = { layout = wibox.layout.fixed.vertical }

    awesome.emit_signal("signal::notification_redraw")
    awesome.emit_signal("signal::notification_close")
end

local function generate_popup()
    local notify_result = notify_list
    local overflow = nil

    notif_header = wibox.widget.textbox("<span weight='ultrabold'>Notifications</span> <span>(" .. tostring(#notify_list) .. ")</span>")

    if #notify_list == 0 then
        notify_result = {
            {
                {
                    {
                        image = ICON_DIR .. "empty.svg",

                        forced_height = 80,
                        forced_width = 80,

                        halign = "center",
                        valign = "center",

                        widget = wibox.widget.imagebox,
                    },

                    top = HEIGHT / 10,
                    widget = wibox.container.margin,
                },

                {
                    {
                        markup = "<span weight='ultrabold' size='x-large'>You don't have any notifications!</span>",
                        align = "center",
                        widget = wibox.widget.textbox,
                    },

                    top = 15,
                    bottom = 15,
                    widget = wibox.container.margin,
                },

                layout = wibox.layout.align.vertical,
            },

            strategy = "max",
            height = HEIGHT,
            layout = wibox.container.constraint,
        }
    elseif #notify_list > MAX_NOTIFICATIONS then
        notify_result = { layout = wibox.layout.fixed.vertical }
        overflow = {
            text = "And " .. tostring(#notify_list - MAX_NOTIFICATIONS) .. " more...",
            align = "center",

            widget = wibox.widget.textbox,
        }

        -- Only display the last 5 notifications
        for key in pairs(notify_list) do
            local kk = tonumber(key)

            if key ~= "layout" and kk ~= nil and kk < MAX_NOTIFICATIONS then
                notify_result[#notify_result + 1] = notify_list[key]
            end
        end
    end

    return {
        {
            {
                {

                    {
                        notif_header,
                        nil,
                        clear_button,

                        expand = "none",
                        layout = wibox.layout.align.horizontal,
                    },

                    notify_result,
                    overflow,

                    widget = wibox.layout.fixed.vertical,
                },

                margins = 10,
                widget = wibox.container.margin,
            },

            strategy = "max",
            forced_width = WIDTH,
            layout = wibox.container.constraint,
        },

        strategy = "min",
        height = HEIGHT,
        layout = wibox.container.constraint,
    }
end

local function generate_count()
    return #notify_list
end

-- Animations
clear_button:connect_signal("mouse::enter", function()
    clear_button.bg = beautiful.bg_focus
end)

clear_button:connect_signal("mouse::leave", function()
    clear_button.bg = beautiful.bg_normal
end)

clear_button:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        clear()
    end
end)

return {
    add = add,
    remove = remove,
    rounded = rounded,
    generate_count = generate_count,
    generate_popup = generate_popup,
}
