local awful = require("awful")
local gears = require("gears")

local mod = require("binds.mod")
local modkey = mod.modkey
local mamt = 5 -- Amount in px

local function move_client_to_screen(c, s)
    -- Move screen
    local index = c.first_tag.index
    c:move_to_screen(s)

    -- Move tag
    local tag = c.screen.tags[index]
    c:move_to_tag(tag)

    if tag then
        tag:view_only()
    end
end

local function move_floating(c, x, y)
    local g = c:geometry()

    if c.floating or awful.layout.get(c.screen) == awful.layout.suit.floating then
        g.x = g.x + (x * mamt)
        g.y = g.y + (y * mamt)
    end

    c:geometry(g)
end

local function resize_floating(c, w, h)
    local g = c:geometry()

    if c.floating or awful.layout.get(c.screen) == awful.layout.suit.floating then
        local gx = g.width + (w * mamt)
        local gy = g.height + (h * mamt)

        if gx > 0 and gy > 0 then
            g.width = gx
            g.height = gy
        end
    end

    c:geometry(g)
end

-- Client keybindings
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        -- Client state management
        awful.key({ modkey, mod.shift }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "Toggle fullscreen", group = "Client" }),

        awful.key({ modkey, mod.shift }, "c", function(c)
            c:kill()
        end, { description = "Close", group = "Client" }),

        awful.key({ modkey, mod.ctrl }, "space", awful.client.floating.toggle, { description = "Toggle Floating", group = "Client" }),

        awful.key({ modkey }, "n", function(c)
            c.minimized = true
        end, { description = "Minimize", group = "Client" }),

        awful.key({ modkey }, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "(un)maximize", group = "Client" }),

        -- Client position in tiling management
        awful.key({ modkey, mod.ctrl }, "Return", function(c)
            c:swap(awful.client.getmaster())
        end, { description = "Move to master", group = "Client" }),

        awful.key({ modkey }, "o", function(c)
            c:move_to_screen()
        end, { description = "Move to screen", group = "Client" }),

        awful.key({ modkey, mod.shift }, "o", function(c)
            move_client_to_screen(c, gears.math.cycle(screen:count(), c.screen.index - 1))
        end, { description = "Move to previous screen", group = "Client" }),

        -- Client position for floating management
        awful.key({ modkey, mod.shift }, "Up", function(c)
            move_floating(c, 0, -1)
        end, { description = "Move floating client up", group = "Client" }),

        awful.key({ modkey, mod.shift }, "Down", function(c)
            move_floating(c, 0, 1)
        end, { description = "Move floating client down", group = "Client" }),

        awful.key({ modkey, mod.shift }, "Left", function(c)
            move_floating(c, -1, 0)
        end, { description = "Move floating client left", group = "Client" }),

        awful.key({ modkey, mod.shift }, "Right", function(c)
            move_floating(c, 1, 0)
        end, { description = "Move floating client right", group = "Client" }),

        awful.key({ modkey, mod.ctrl, mod.shift }, "Up", function(c)
            resize_floating(c, 0, -1)
        end, { description = "Decrease floating client height", group = "Client" }),

        awful.key({ modkey, mod.ctrl, mod.shift }, "Down", function(c)
            resize_floating(c, 0, 1)
        end, { description = "Incraese floating client height", group = "Client" }),

        awful.key({ modkey, mod.ctrl, mod.shift }, "Left", function(c)
            resize_floating(c, -1, 0)
        end, { description = "Decrease floating client width", group = "Client" }),

        awful.key({ modkey, mod.ctrl, mod.shift }, "Right", function(c)
            resize_floating(c, 1, 0)
        end, { description = "Increase floating client width", group = "Client" }),
    })
end)
