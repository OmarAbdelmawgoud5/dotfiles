-- Lazy.nvim Plugin Manager Setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Load all plugin specifications
local specs = {}

vim.list_extend(specs, require("plugins.lsp"))
vim.list_extend(specs, require("plugins.javaConf"))
vim.list_extend(specs, require("plugins.neotest"))
vim.list_extend(specs, require("plugins.completion"))
vim.list_extend(specs, require("plugins.formatting"))
vim.list_extend(specs, require("plugins.treesitter"))
vim.list_extend(specs, require("plugins.ui"))
vim.list_extend(specs, require("plugins.editor"))
vim.list_extend(specs, require("plugins.tools"))
vim.list_extend(specs, require("plugins.database"))
vim.list_extend(specs, require("plugins.toggleTerm"))
vim.list_extend(specs, require("plugins.ecelog"))
vim.list_extend(specs, require("plugins.pets"))
vim.list_extend(specs, require("plugins.maven"))
-- Lazy.nvim setup
require("lazy").setup(specs, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠 ",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝 ",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
require("plugins.vite")
require("plugins.sqlls")
require("plugins.gotest")
