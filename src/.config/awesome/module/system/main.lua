local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local ICON_DIR = gears.filesystem.get_dir("config") .. "module/system/icons/"
local BIN_DIR = gears.filesystem.get_dir("config") .. "module/system/bin/"

local CMD = {
    { name = "Lock", icon = ICON_DIR .. "lock.svg", cmd = BIN_DIR .. "lock" },
    { name = "Reboot", icon = ICON_DIR .. "reboot.svg", cmd = BIN_DIR .. "reboot" },
    { name = "Power Off", icon = ICON_DIR .. "power.svg", cmd = BIN_DIR .. "power" },
}

-- Helper functions
local rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

local generate_items = function(txt, pop)
    local system_items = { layout = wibox.layout.fixed.vertical }

    for _, item in ipairs(CMD) do
        local row = wibox.widget({
            {
                {
                    {
                        image = item.icon,
                        resize = false,
                        widget = wibox.widget.imagebox,
                    },

                    {
                        text = item.name,
                        font = font,
                        widget = wibox.widget.textbox,
                    },

                    spacing = 12,
                    layout = wibox.layout.fixed.horizontal,
                },

                margins = 8,
                layout = wibox.container.margin,
            },

            bg = beautiful.bg_normal,
            widget = wibox.container.background,
        })

        row:connect_signal("mouse::enter", function(c)
            c:set_bg(beautiful.bg_focus)
        end)

        row:connect_signal("mouse::leave", function(c)
            c:set_bg(beautiful.bg_normal)
        end)

        row:buttons(awful.util.table.join(awful.button({}, 1, function()
            pop.visible = not pop.visible
            txt:set_bg("#00000000")

            awful.spawn.with_shell(item.cmd)
        end)))

        table.insert(system_items, row)
    end

    return system_items
end

-- Main widgets
local system = wibox.widget({
    {
        {
            image = ICON_DIR .. "icon.svg",
            resize = true,
            widget = wibox.widget.imagebox,
        },

        margins = 4,
        layout = wibox.container.margin,
    },

    shape = rounded,
    widget = wibox.container.background,
})

local system_pop = awful.popup({
    ontop = true,
    visible = false,
    border_width = 1,
    border_color = beautiful.bg_focus,
    widget = {},
    shape = rounded,
})

system_pop:setup(generate_items(system, system_pop))

-- Handle popup
system:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        system_pop.visible = not system_pop.visible
        system_pop.screen = awful.screen.focused()

        if system_pop.visible then
            awful.placement.top_right(system_pop, {
                margins = { top = 30, right = 5 },
                parent = awful.screen.focused(),
            })

            system:set_bg(beautiful.bg_focus)
        else
            system:set_bg("#00000000")
        end
    end
end)

awful.placement.top_right(system_pop, {
    margins = { top = 30, right = 5 },
    parent = awful.screen.focused(),
})

return system
