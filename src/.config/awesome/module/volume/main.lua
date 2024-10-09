local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

local bin = require("module.volume.bin")

local ICON_DIR = gears.filesystem.get_dir("config") .. "module/volume/icons/"

-- Helper functions
local rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

-- Main widgets
local volume = wibox.widget.textbox("<span weight='bold'> 0% </span>")
local volume_icon = wibox.widget.imagebox(ICON_DIR .. "on.svg")
local volume_slider = wibox.widget({
    bar_shape = gears.shape.rounded_rect,
    bar_height = 3,
    bar_color = beautiful.border_color_active,
    handle_color = beautiful.bg_normal,
    handle_shape = gears.shape.circle,
    handle_border_color = beautiful.border_color_active,
    handle_border_width = 1,

    value = 25,
    minimum = 0,
    maximum = 100,
    forced_height = 25,
    forced_width = 150,
    widget = wibox.widget.slider,
})

local volume_container = wibox.widget({
    {
        {
            volume_icon,
            margins = 2,
            widget = wibox.container.margin,
        },

        volume,
        layout = wibox.layout.fixed.horizontal,
    },

    shape = rounded,
    widget = wibox.container.background,
})

local volume_pop = awful.popup({
    ontop = true,
    visible = false,
    border_width = 1,
    border_color = beautiful.bg_focus,
    widget = {
        {
            {
                {
                    volume_icon,

                    strategy = "max",
                    height = 25,
                    width = 25,
                    widget = wibox.container.constraint,
                },

                {
                    volume_slider,

                    right = 5,
                    left = 5,
                    widget = wibox.container.margin,
                },

                volume,

                layout = wibox.layout.fixed.horizontal,
            },

            margins = 10,
            widget = wibox.container.margin,
        },

        strategy = "max",
        width = 250,
        height = 250,
        widget = wibox.container.constraint,
    },

    shape = rounded,
})

-- Track updates
local set_volume = function(vol)
    volume.markup = "<span weight='bold'> " .. tostring(vol) .. "% </span>"
    volume_slider.value = tonumber(vol)

    bin.set_volume(vol)
end

local set_mute = function(mute)
    local ico = "on.svg"

    if mute then
        ico = "off.svg"
    end

    volume_icon.image = ICON_DIR .. ico
    bin.set_mute(mute)
end

local inc_vol = function(n)
    local v = bin.get_volume() + n

    if v >= 100 or v <= 0 then
        return
    end

    set_volume(v)
end

local update = function()
    set_volume(bin.get_volume())
    set_mute(bin.get_mute())
end

gears.timer({
    timeout = 20,
    autostart = true,
    callback = update,
})

awful.placement.top_right(volume_pop, {
    margins = { top = 30, right = 10 },
    parent = awful.screen.focused(),
})

-- Handle popup
volume_container:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        volume_pop.visible = not volume_pop.visible
        volume_pop.screen = awful.screen.focused()

        if volume_pop.visible then
            awful.placement.top_right(volume_pop, {
                margins = { top = 30, right = 10 },
                parent = awful.screen.focused(),
            })

            volume_pop:move_next_to(mouse.current_widget_geometry)
            volume_container:set_bg(beautiful.bg_focus)
        else
            volume_container:set_bg("#00000000")
        end
    end
end)

volume_slider:connect_signal("property::value", function(_, new_value)
    set_volume(new_value)
end)

volume_icon:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        set_mute(not bin.get_mute())
    end
end)

volume_slider:buttons(awful.util.table.join(
    awful.button({}, 4, function()
        inc_vol(-1)
    end),

    awful.button({}, 5, function()
        inc_vol(1)
    end)
))

volume:buttons(awful.util.table.join(
    awful.button({}, 4, function()
        inc_vol(-5)
    end),

    awful.button({}, 5, function()
        inc_vol(5)
    end)
))

awesome.connect_signal("signal::volume_update", update)

return volume_container
