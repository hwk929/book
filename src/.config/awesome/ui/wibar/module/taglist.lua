local awful = require("awful")
local wibox = require("wibox")

local mod = require("binds.mod")
local modkey = mod.modkey

local function createFade(self, c3, index, objects)
    local sel = 1
    local weight = "normal"
    local fade = {
        "#ffffff",
        "#a5a6a9",
        "#78797f",
        "#4b4d54",
        "#34363e",
        "#30323a",
        "#2b2d36",
        "#272932",
        "#22242d",
    }

    for i in pairs(objects) do
        if objects[i].selected then
            sel = objects[i].index
        end
    end

    if c3.selected then
        weight = "ultrabold"
    end

    self:get_children_by_id("index_role")[1].markup = "<span weight='" .. weight .. "' color='" .. fade[math.abs(index - sel) + 1] .. "' font_desc='FreeMono 8'>" .. index .. "</span>"
end

return function(s)
    return awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button(nil, 1, function(t)
                t:view_only()
            end),

            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),

            awful.button(nil, 3, awful.tag.viewtoggle),

            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),

            awful.button(nil, 4, function(t)
                awful.tag.viewprev(t.screen)
            end),

            awful.button(nil, 5, function(t)
                awful.tag.viewnext(t.screen)
            end),
        },

        widget_template = {
            {
                {
                    {
                        id = "index_role",
                        widget = wibox.widget.textbox,
                    },

                    layout = wibox.layout.fixed.horizontal,
                },

                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },

            id = "background_role",
            widget = wibox.container.background,
            create_callback = createFade,
            update_callback = createFade,
        },
    })
end
