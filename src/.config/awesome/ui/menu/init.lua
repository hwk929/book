local awful = require("awful")

-- Menu
local menu = {}
local apps = require("config.apps")
local hkey_popup = require("awful.hotkeys_popup")
local confpath = require("gears.filesystem").get_dir("config")

-- Create a main menu
menu.awesome = {
    {
        "Hotkeys",
        function()
            hkey_popup.show_help(nil, awful.screen.focused())
        end,
    },

    {
        "Help",
        {
            { "Manual", apps.terminal .. " -e man awesome" },
            { "Documentation", (os.getenv("BROWSER") or "firefox") .. " https://awesomewm.org/apidoc" },
        },
    },

    { "Edit Config", apps.editor_cmd .. " " .. confpath },
    { "Restart", awesome.restart },

    {
        "Quit",
        function()
            awesome.quit()
        end,
    },
}

menu.main = awful.menu({
    items = {
        { "Awesome", menu.awesome },
        { "Context", apps.context },
        { "Terminal", apps.terminal },
    },
})

return menu
