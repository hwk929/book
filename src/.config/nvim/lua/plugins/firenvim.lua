-- Embedded neovim in Firefox
-- :help firenvim
return {
    "glacambre/firenvim",

    lazy = not vim.g.started_by_firenvim,
    build = function()
        vim.fn["firenvim#install"](0)
    end,
}
