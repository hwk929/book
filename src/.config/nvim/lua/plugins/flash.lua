-- Improved Movement
-- :help flash
return {
    "folke/flash.nvim",

    opts = {
        modes = {
            char = { enabled = false },
        },
    },

    event = "VeryLazy",

    -- stylua: ignore
    keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
}
