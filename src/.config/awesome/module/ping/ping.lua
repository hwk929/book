local awful = require("awful")
local gears = require("gears")

local BIN_DIR = gears.filesystem.get_dir("config") .. "module/ping/bin/"
local hosts = {}

local function update_status(url, status)
    for i, v in pairs(hosts) do
        if v.host == url then
            hosts[i].status = status
            break
        end
    end
end

local function get_status(url, count)
    awful.spawn.easy_async_with_shell(BIN_DIR .. "ping " .. url .. " " .. count, function(stdout)
        local u = tonumber(stdout)

        if u ~= nil then
            update_status(url, u)
            awesome.emit_signal("signal::ping_update", hosts)
        end
    end)

    return 0
end

local function init(list, count)
    hosts = {}

    for _, v in pairs(list) do
        hosts[#hosts + 1] = {
            name = v.name,
            host = v.host,
            status = -1,
        }

        get_status(v.host, count)
    end

    return hosts
end

return init
