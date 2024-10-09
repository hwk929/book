-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Paste in insert mode
vim.keymap.set("i", "<C-v>", function()
    vim.cmd([[norm P]])
end, { desc = "Paste in insert mode" })

-- Better split navigation keymaps
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Terminal keymaps
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- default is <C-\><C-n>
vim.keymap.set("n", "<leader>tt", ":tab term<CR>", { desc = "Open terminal in a new tab" })
vim.keymap.set("n", "<leader>tj", function()
    vim.cmd.new()
    vim.cmd.wincmd("J")

    vim.api.nvim_win_set_height(0, 10)
    vim.wo.winfixheight = true

    vim.cmd.term()
end, { desc = "Open terminal on the bottom" })

-- Split keymaps
vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<M-]>", "<C-W>+")
vim.keymap.set("n", "<M-[>", "<C-W>-")

-- Move lines with ALT j/k
vim.keymap.set("n", "<M-j>", function()
    if vim.opt.diff:get() then
        vim.cmd([[normal! ]c]])
    else
        vim.cmd([[m .+1<CR>==]])
    end
end)

vim.keymap.set("n", "<M-k>", function()
    if vim.opt.diff:get() then
        vim.cmd([[normal! [c]])
    else
        vim.cmd([[m .-2<CR>==]])
    end
end)
