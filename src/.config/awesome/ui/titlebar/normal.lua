local awful = require("awful")
local wibox = require("wibox")

-- The titlebar to be used on normal clients
return function(c)
    awful.titlebar(c, { position = "top", size = 30 }).widget = wibox.widget({
        {
            {
                awful.titlebar.widget.iconwidget(c),
                layout = wibox.layout.fixed.horizontal(),
            },

            layout = wibox.container.margin,
            left = 10,
            right = 10,
            top = 8,
            bottom = 8,
        },

        {
            {
                widget = awful.titlebar.widget.titlewidget(c),
                halign = "center",
            },

            layout = wibox.layout.flex.horizontal,
        },

        layout = wibox.layout.align.horizontal,
        expand = "none",
    })
end
