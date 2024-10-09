local awful = require("awful")
local wibox = require("wibox")

local module = require(... .. ".module")

local taskbar = require("module.taskbar.main")
local notifications = require("module.notification.main")
local ping = require("module.ping.main")
local volume = require("module.volume.main")
local packages = require("module.packages.main")
local time = require("module.time.main")
local system = require("module.system.main")

return function(s)
    s.mywibox = awful.wibar({
        position = "top",
        height = 30,
        screen = s,
    })

    s.mywibox:setup({
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",

            {
                layout = wibox.layout.fixed.horizontal,

                module.layoutbox(s),
                module.taglist(s),
            },

            module.tasklist(s),

            {
                layout = wibox.layout.fixed.horizontal,

                wibox.container.margin(taskbar, 4, 4),
                wibox.container.margin(notifications, 4, 4),
                wibox.container.margin(ping, 4, 4),
                wibox.container.margin(volume, 4, 4),
                wibox.container.margin(packages, 4, 4),
                wibox.container.margin(wibox.widget.textbox("<span weight='bold'> - </span>"), 2, 4),
                wibox.container.margin(time, 4, 4),
                wibox.container.margin(system, 2, 2),
            },
        },

        widget = wibox.container.margin,
        margins = 5,
    })
end
