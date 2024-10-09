local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

return function(s)
    return awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button(nil, 1, function(c)
                c:activate({ context = "tasklist", action = "toggle_minimization" })
            end),

            awful.button(nil, 3, function()
                awful.menu.client_list({ theme = { width = 250 } })
            end),

            awful.button(nil, 4, function()
                awful.client.focus.byidx(-1)
            end),

            awful.button(nil, 5, function()
                awful.client.focus.byidx(1)
            end),
        },

        style = {
            shape_border_width = 1,
            shape_border_color = beautiful.bg_focus,
            shape = gears.shape.rounded_bar,
        },

        layout = {
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,
        },

        widget_template = {
            {
                {
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                    },

                    margins = 2,
                    widget = wibox.container.margin,
                },

                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },

            id = "background_role",
            widget = wibox.container.background,
        },
    })
end
