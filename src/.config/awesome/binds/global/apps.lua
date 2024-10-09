local awful = require("awful")
local gears = require("gears.table")

local mod = require("binds.mod")
local modkey = mod.modkey

local apps = require("config.apps")
local app_binds = {}

-- Application shortcuts - Read from app.shortcuts & bind them
local function init_shortcuts()
    for _, shortcut in pairs(apps.shortcuts) do
        for _2, bind in pairs(shortcut.binds) do
            awful.keyboard.append_global_keybinding(awful.key(gears.join({ modkey }, bind.alt), bind.key, function()
                awful.spawn.with_shell(bind.cmd)
            end, { description = bind.title, group = shortcut.group }))
        end
    end
end

-- Application keybinds - Set keybinds based on active window (usually the F1-F12 keys)
local function init_keybinds()
    for _, shortcut in pairs(apps.active) do
        for _, bind in pairs(shortcut.binds) do
            app_binds[#app_binds + 1] = awful.key(gears.join({ modkey }, bind.alt), bind.key, function()
                awful.spawn.with_shell(bind.cmd)
            end, { description = bind.title, group = shortcut.group })
        end
    end
end

local function get_binds(name)
    for _, shortcut in pairs(apps.active) do
        if gears.hasitem(shortcut.class, name) then
            return shortcut.group
        end
    end

    return nil
end

local function set_app(e)
    local app = get_binds(e.class)

    if not app then
        return
    end

    for _, bind in pairs(app_binds) do
        if bind.group == app then
            awful.keyboard.append_client_keybinding(bind)
        end
    end
end

local function remove_apps()
    for _, bind in pairs(app_binds) do
        awful.keyboard.remove_client_keybinding(bind)
    end
end

-- Set the keybinds
awesome.connect_signal("startup", function()
    init_shortcuts()
    init_keybinds()
end)

client.connect_signal("focus", function(e)
    remove_apps()
    set_app(e)
end)
