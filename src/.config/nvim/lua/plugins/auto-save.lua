-- Autosave
-- :help auto-save
return {
    "okuuva/auto-save.nvim",

    enabled = false,

    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {},
}
