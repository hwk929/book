local awful = require("awful")
local beautiful = require("beautiful")

local mod = require("binds.mod")
local modkey = mod.modkey

local apps = require("config.apps")

-- Global key bindings
awful.keyboard.append_global_keybindings({
    -- General Awesome keys
    awful.key({ modkey }, "/", require("awful.hotkeys_popup").show_help, { description = "Show help", group = "Awesome" }),
    awful.key({ modkey, mod.ctrl }, "r", awesome.restart, { description = "Reload awesome", group = "Awesome" }),
    awful.key({ modkey, mod.shift }, "q", awesome.quit, { description = "Quit awesome", group = "Awesome" }),

    -- Tags related launching
    awful.key({ modkey }, "Return", function()
        awful.spawn(apps.terminal)
    end, { description = "Open a terminal", group = "Launcher" }),

    -- Tags related keybindings
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "View previous", group = "Tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "View next", group = "Tag" }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "Go back", group = "Tag" }),

    -- Focus related keybindings
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "Focus next by index", group = "Client" }),

    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "Focus previous by index", group = "Client" }),

    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Go back", group = "Client" }),

    awful.key({ modkey, mod.ctrl }, "j", function()
        awful.screen.focus_relative(1)
    end, { description = "Focus the next screen", group = "Screen" }),

    awful.key({ modkey, mod.ctrl }, "k", function()
        awful.screen.focus_relative(-1)
    end, { description = "Focus the previous screen", group = "Screen" }),

    awful.key({ modkey, mod.ctrl }, "n", function()
        local c = awful.client.restore()

        if c then
            c:activate({ raise = true, context = "key.unminimize" })
        end
    end, { description = "Restore minimized", group = "Client" }),

    -- Layout related keybindings
    awful.key({ modkey, mod.shift }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "Swap with next client by index", group = "Client" }),

    awful.key({ modkey, mod.shift }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "Swap with previous client by index", group = "Client" }),

    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "Jump to urgent client", group = "Client" }),

    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "Increase master width factor", group = "Layout" }),

    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "Decrease master width factor", group = "Layout" }),

    awful.key({ modkey }, ";", function()
        awful.screen.focused().selected_tag.master_width_factor = beautiful.master_width_factor or 0.5
    end, { description = "Reset master width factor", group = "Layout" }),

    awful.key({ modkey, mod.shift }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "Increase the number of master clients", group = "Layout" }),

    awful.key({ modkey, mod.shift }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "Decrease the number of master clients", group = "Layout" }),

    awful.key({ modkey, mod.shift }, ";", function()
        awful.tag.object.set_master_count(awful.screen.focused().selected_tag, beautiful.master_count or 1)
    end, { description = "Reset the number of master clients", group = "Layout" }),

    awful.key({ modkey, mod.ctrl }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "Increase the number of columns", group = "Layout" }),

    awful.key({ modkey, mod.ctrl }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "Decrease the number of columns", group = "Layout" }),

    awful.key({ modkey, mod.ctrl }, ";", function()
        awful.tag.object.set_column_count(awful.screen.focused().selected_tag, beautiful.column_count or 1)
    end, { description = "Reset the number of columns", group = "Layout" }),

    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "Select next layout", group = "Layout" }),

    awful.key({ modkey, mod.shift }, "space", function()
        awful.layout.inc(-1)
    end, { description = "Select previous", group = "Layout" }),

    awful.key({
        modifiers = { modkey },
        keygroup = "numrow",
        description = "Only view tag",
        group = "Tag",

        on_press = function(index)
            local tag = awful.screen.focused().tags[index]
            if tag then
                tag:view_only()
            end
        end,
    }),

    awful.key({
        modifiers = { modkey, mod.ctrl },
        keygroup = "numrow",
        description = "Toggle tag",
        group = "Tag",

        on_press = function(index)
            local tag = awful.screen.focused().tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    }),

    awful.key({
        modifiers = { modkey, mod.shift },
        keygroup = "numrow",
        description = "Move focused client to tag",
        group = "Tag",

        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    }),

    awful.key({
        modifiers = { modkey, mod.ctrl, mod.shift },
        keygroup = "numrow",
        description = "Toggle focused client on tag",
        group = "Tag",

        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    }),

    awful.key({
        modifiers = { modkey },
        keygroup = "numpad",
        description = "Select layout directly",
        group = "Layout",

        on_press = function(index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }),
})
