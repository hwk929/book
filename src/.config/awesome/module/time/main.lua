local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

-- Helper functions
local rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
end

local set_style = function(check, widget, markup)
    if check and widget.get_text and widget.set_markup then
        widget:set_markup(markup .. widget:get_text() .. "</span>")
    end
end

local set_month = function(cal, pop, n)
    cal.date.month = n
    pop:set_widget(wibox.container.margin(cal, 10, 10, 10, 10))
end

-- Main widgets
local time = wibox.widget.textclock("<span weight='ultrabold'> %a, %l:%M%P </span>")
local clock = wibox.container.background(time, "#00000000", rounded)

local calendar = {
    date = os.date("*t"),
    font = beautiful.get_font(),
    long_weekdays = true,
    start_sunday = true,
    week_numbers = false,
    fn_embed = function(widget, flag, _)
        set_style(flag == "monthheader" or flag == "header" or flag == "weekday", widget, "<span weight='ultrabold'>")

        return widget
    end,

    widget = wibox.widget.calendar.month,
}

local calendar_pop = awful.popup({
    ontop = true,
    visible = false,
    border_width = 1,
    border_color = beautiful.bg_focus,
    widget = wibox.container.margin(calendar, 10, 10, 10, 10),
    shape = rounded,
})

-- Align popup and add event listeners
awful.placement.top_right(calendar_pop, {
    margins = { top = 30, right = 10 },
    parent = awful.screen.focused(),
})

calendar_pop:buttons(awful.util.table.join(
    awful.button({}, 4, function()
        set_month(calendar, calendar_pop, calendar.date.month - 1)
    end),

    awful.button({}, 5, function()
        set_month(calendar, calendar_pop, calendar.date.month + 1)
    end)
))

time:connect_signal("button::press", function(_, _1, _2, button)
    if button == 1 then
        calendar.date = os.date("*t")
        calendar_pop.visible = not calendar_pop.visible
        calendar_pop.screen = awful.screen.focused()

        set_month(calendar, calendar_pop, calendar.date.month)

        if calendar_pop.visible then
            awful.placement.top_right(calendar_pop, {
                margins = { top = 30, right = 10 },
                parent = awful.screen.focused(),
            })

            clock:set_bg(beautiful.bg_focus)
        else
            clock:set_bg("#00000000")
        end
    end
end)

return clock
