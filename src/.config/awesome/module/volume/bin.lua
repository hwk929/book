local gears = require("gears")

local BIN_DIR = gears.filesystem.get_dir("config") .. "module/volume/bin/"
local bin = {}

local function popen_and_return(cmd)
    local handle = io.popen(cmd)

    if handle == nil then
        return ""
    end

    local result = handle:read("*a")
    handle:close()

    return result
end

function bin.get_volume()
    local stdout = popen_and_return(BIN_DIR .. "get-volume")
    local volsum, volcnt = 0, 0

    for vol in string.gmatch(stdout, "(%d?%d?%d)%%") do
        local vvol = tonumber(vol)

        if vvol ~= nil then
            volsum = volsum + vvol
            volcnt = volcnt + 1
        end
    end

    if volcnt == 0 then
        return nil
    end

    return volsum / volcnt
end

function bin.set_volume(vol)
    return popen_and_return(BIN_DIR .. "set-volume " .. tostring(vol))
end

function bin.get_mute()
    local stdout = popen_and_return(BIN_DIR .. "get-mute")

    return not not string.find(stdout, "yes")
end

function bin.set_mute(mute)
    return popen_and_return(BIN_DIR .. "set-mute " .. tostring(mute))
end

return bin
