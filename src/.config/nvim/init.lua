local function init(config)
    for _, app in ipairs(config) do
        if app[2] then
            require("init." .. app[1])
            return
        end
    end

    require("init.nvim")
end

init({
    { "vscode", vim.g.vscode },
    { "fire", vim.g.started_by_firenvim },
})
