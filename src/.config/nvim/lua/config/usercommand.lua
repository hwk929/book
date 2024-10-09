-- Toggle word wrapping and remap jk
local wrapped = false

vim.api.nvim_create_user_command("WordWrapToggle", function()
    wrapped = not wrapped -- vim.opt.wrap returns a table, not a boolean
    vim.opt.wrap = wrapped

    if wrapped then
        vim.keymap.set("n", "j", "gj")
        vim.keymap.set("n", "k", "gk")

        return
    end

    vim.keymap.del("n", "j")
    vim.keymap.del("n", "k")
end, { desc = "Toggle word wrapping on a file" })
