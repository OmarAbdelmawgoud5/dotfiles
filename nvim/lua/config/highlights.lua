-- Highlights and Colorscheme Configuration
-- Note: Colorscheme setup happens in plugins/ui.lua after plugins are loaded

-- Transparent background (can be set before colorscheme loads)
vim.api.nvim_set_hl(0, "Normal", { fg = nil, bg = "none" })

-- Set these after colorscheme loads
vim.schedule(function()
	vim.cmd([[
  highlight Normal   guibg=none ctermbg=none
  highlight NormalNC guibg=none ctermbg=none
  highlight SignColumn guibg=none ctermbg=none
  highlight EndOfBuffer guibg=none ctermbg=none
]])
end)
