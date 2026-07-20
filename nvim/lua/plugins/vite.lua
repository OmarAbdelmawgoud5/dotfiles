local status_ok, Terminal = pcall(require, "toggleterm.terminal")
if not status_ok then
	vim.notify("toggleterm not found", vim.log.levels.ERROR)
	return
end

local pnpm_dev = Terminal.Terminal:new({
	cmd = "pnpm dev -- --open",
	hidden = true,
	direction = "float",
})

vim.keymap.set("n", "<leader>v", function()
	pnpm_dev:toggle()
end, { noremap = true, silent = true })
