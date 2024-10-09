-- Autoformat
-- :help conform
return {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },

    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable for specific languages
            local disable_filetypes = { c = true, cpp = true }

            return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
        end,

        formatters_by_ft = {
            lua = { "stylua" },
            html = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettierd", "prettier", stop_after_first = true },
            javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}
