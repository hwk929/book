-- Show pending keybinds
-- :help which-key
return {
    "folke/which-key.nvim",

    event = "VimEnter",
    config = function()
        require("which-key").setup()
        require("which-key").add({
            { "<leader>c", group = "[C]ode" },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>r", group = "[R]ename" },
            { "<leader>s", group = "[S]earch" },
            { "<leader>w", group = "[W]orkspace" },
            { "<leader>e", group = "[E]xplore" },
            { "<leader>t", group = "[T]erminal" },
            { "<leader>h", group = "[H]arpoon" },
        })
    end,
}
