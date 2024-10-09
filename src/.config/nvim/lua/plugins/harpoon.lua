-- File manager
-- :help harpoon
return {
    "ThePrimeagen/harpoon",

    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "j-hui/fidget.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local fidget = require("fidget")

        harpoon:setup()

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
            fidget.notify("[harpoon] file added.")
        end, { desc = "Add file to harpoon menu" })

        vim.keymap.set("n", "<leader>hh", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle harpoon menu" })

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-M-k>", function()
            harpoon:list():prev()
        end, { desc = "Previous item in harpoon" })

        vim.keymap.set("n", "<C-M-j>", function()
            harpoon:list():next()
        end, { desc = "Next item in harpoon" })
    end,
}
