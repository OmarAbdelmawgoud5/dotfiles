-- Global Autocommands

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Show diagnostics on cursor hold
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("show-diagnostics", { clear = true }),
	callback = function()
		vim.diagnostic.show()
	end,
})

-- SQL specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	group = vim.api.nvim_create_augroup("sql-keymaps", { clear = true }),
	callback = function()
		local keys = { "R", "L", "l", "c", "v", "p", "t", "s", "T", "o", "f", "k", "a" }
		for _, k in ipairs(keys) do
			pcall(vim.keymap.del, "i", "<C-C>" .. k, { buffer = true })
		end
		vim.keymap.set("i", "<C-c>", "<Esc>", { buffer = true, noremap = true })
	end,
})
