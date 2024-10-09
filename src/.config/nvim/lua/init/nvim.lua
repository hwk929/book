vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Used to display icons
vim.g.have_nerd_font = true

-- Load config
require("config.opt")
require("config.keymap")
require("config.usercommand")
require("config.autocommand")

-- Load plugins
require("util.lazy")({
    { import = "plugins" },
    { import = "themes" },
})
