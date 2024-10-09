-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Allow mouse & hide mode
vim.opt.mouse = "a"
vim.opt.showmode = false

-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show sign column for git
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Display whitespace
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
}

-- Preview substitutions
vim.opt.inccommand = "split"
vim.opt.cursorline = true

-- Max scroll distance
vim.opt.scrolloff = 10

-- Word wrapping
vim.opt.breakindent = false
vim.opt.linebreak = false
vim.opt.wrap = false

-- Tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enable terminal colors
vim.opt.termguicolors = true

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Tree style for netrw (if enabled)
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
