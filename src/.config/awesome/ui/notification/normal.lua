local awful = require("awful")
local naughty = require("naughty")
local ruled = require("ruled")

local beautiful = require("beautiful")
local wibox = require("wibox")

ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule({
        rule = nil,
        properties = {
            screen = awful.screen.preferred,
            implicit_timeout = 5,
            border_width = 0,
            widget_template = {
                {
                    {
                        -- Titlebar
                        {
                            {
                                halign = "center",
                                wrap = "word_char",
                                widget = naughty.widget.title,
                            },

                            widget = wibox.container.margin,
                            margins = 8,
                        },

                        -- Message box
                        {
                            {
                                {
                                    {
                                        naughty.widget.icon,
                                        forced_height = 48,
                                        halign = "center",
                                        valign = "center",
                                        widget = wibox.container.place,
                                    },

                                    {
                                        naughty.widget.message,
                                        left = 5,
                                        right = 5,
                                        widget = wibox.container.margin,
                                    },

                                    widget = wibox.layout.fixed.horizontal,
                                },

                                margins = beautiful.notification_margin or 4,
                                widget = wibox.container.margin,
                            },

                            bg = beautiful.titlebar_bg_normal,
                            widget = wibox.container.background,
                        },

                        widget = wibox.layout.fixed.vertical,
                    },

                    id = "background_role",
                    widget = naughty.container.background,
                },

                strategy = "min",
                width = 350,
                forced_width = 350,
                widget = wibox.container.constraint,
            },
        },
    })
end)

-- Defines the default notification layout
naughty.connect_signal("request::display", function(n)
    naughty.layout.box({ notification = n })
end)
