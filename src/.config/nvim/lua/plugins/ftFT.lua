-- Highlight unique f/t & F/T
-- :help ftFT
return {
    "gukz/ftFT.nvim",

    opts = {
        keys = { "f", "t", "F", "T" },
        modes = { "n", "v" },
        hl_group = "Search",
        sight_hl_group = "",
    },

    config = true,
}
