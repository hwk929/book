-- Set theme
-- :Telescope colorscheme
local theme = require("themes.dracula")
local colorscheme = "dracula"

theme.init = function()
    vim.cmd.colorscheme(colorscheme)
end

return theme
