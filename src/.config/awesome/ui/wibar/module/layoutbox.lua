local awful = require("awful")
local wibox = require("wibox")

return function(s)
    return {
        awful.widget.layoutbox({
            screen = s,
            buttons = {
                awful.button(nil, 1, function()
                    awful.layout.inc(1)
                end),

                awful.button(nil, 3, function()
                    awful.layout.inc(-1)
                end),

                awful.button(nil, 4, function()
                    awful.layout.inc(-1)
                end),

                awful.button(nil, 5, function()
                    awful.layout.inc(1)
                end),
            },
        }),

        left = 10,
        right = 10,
        widget = wibox.container.margin,
    }
end
