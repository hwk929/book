-- Tree file view :help nvim-tree
-- :help nvim-tree
return {
    "nvim-tree/nvim-tree.lua",

    opts = {
        sort = { sorter = "case_sensitive" },
        view = { width = 40, side = "right" },
        renderer = { group_empty = false },
        filters = {
            dotfiles = false,
            git_ignored = false,
        },
    },

    config = function(_, opts)
        local tree = require("nvim-tree")

        vim.keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "[E]xplore nvim-tree" })
        vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "[F]ocus file" })

        tree.setup(opts)
    end,
}
