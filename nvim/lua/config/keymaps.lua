-- Basic Keymaps (not plugin-specific)

-- Clear highlights on search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymap
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Center screen on C-d and C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Split navigation (CTRL + hjkl)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- LSP Restart
vim.keymap.set("n", "<leader>lr", function()
	vim.cmd("LspRestart")
end, { desc = "Restart LSP" })

-- Rename in function (treesitter-based)
local function rename_in_function()
	local ts = vim.treesitter
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	local word = vim.fn.expand("<cword>")
	if word == "" then
		print("No word under cursor")
		return
	end

	if not pcall(require, "nvim-treesitter") then
		print("nvim-treesitter not available")
		return
	end

	local ok, parser = pcall(ts.get_parser, 0, "cpp")
	if not ok then
		ok, parser = pcall(ts.get_parser, 0, "c")
	end

	if not ok then
		print("No C/C++ parser available")
		return
	end

	local trees = parser:parse()
	if not trees or #trees == 0 then
		print("Could not parse buffer")
		return
	end

	local root = trees[1]:root()

	local function get_node_range(node)
		if node.range then
			return node:range()
		elseif ts.get_node_range then
			return ts.get_node_range(node)
		else
			return nil
		end
	end

	local function_node = nil
	local best_range = nil

	local function find_function_node(node)
		if not node then
			return
		end

		local node_type = node:type()
		if node_type == "function_definition" or node_type == "function_declarator" or node_type == "declaration" then
			local start_row, start_col, end_row, end_col = get_node_range(node)
			if start_row and start_row <= row and row <= end_row then
				if not best_range or (start_row > best_range[1] or end_row < best_range[3]) then
					function_node = node
					best_range = { start_row, start_col, end_row, end_col }
				end
			end
		end

		for child in node:iter_children() do
			find_function_node(child)
		end
	end

	find_function_node(root)

	if not function_node or not best_range then
		print("Not inside a function")
		return
	end

	local new_name = vim.fn.input("Rename '" .. word .. "' to: ")
	if new_name == "" then
		return
	end

	local start_line = best_range[1] + 1
	local end_line = best_range[3] + 1

	local cmd = string.format(":%d,%ds/\\<%s\\>/%s/gc", start_line, end_line, word, new_name)
	vim.cmd(cmd)
end

vim.keymap.set("n", "<leader>R", rename_in_function, { desc = "Rename in function" })
