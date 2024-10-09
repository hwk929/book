-- awesome_mode: api-level=4:screen=on
pcall(require, "luarocks.loader")

-- Error handling
local naughty = require("naughty")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Awesome - An error occurred" .. (startup and " during startup" or ""),
        message = message,
    })
end)

-- Automatically focus a client & startup script
require("awful.autofocus")
require("awful.spawn").with_shell(require("gears.filesystem").get_dir("config") .. "bin/autostart")

require("theme")
require("signal")
require("binds")

-- Load all client rules
require("config.rules")
