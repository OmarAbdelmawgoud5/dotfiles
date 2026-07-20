-- Completion Configuration (blink.cmp)

return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
		},
		opts = {
			keymap = {
				preset = "default",
				["<TAB>"] = { "accept", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						score_offset = 90,
						transform_items = function(_, items)
							table.sort(items, function(a, b)
								local a_label = a.label or ""
								local b_label = b.label or ""

								local line = vim.api.nvim_get_current_line()
								local col = vim.api.nvim_win_get_cursor(0)[2]
								local prefix = string.sub(line, 1, col):match("[%w_]*$") or ""

								if prefix == "" then
									return false
								end

								local a_starts = a_label:lower():find("^" .. prefix:lower()) == 1
								local b_starts = b_label:lower():find("^" .. prefix:lower()) == 1

								if a_starts and not b_starts then
									return true
								elseif b_starts and not a_starts then
									return false
								end

								local kind_priority = {
									[1] = 10,
									[2] = 9,
									[3] = 9,
									[4] = 8,
									[5] = 7,
									[6] = 7,
									[7] = 6,
									[8] = 6,
									[9] = 5,
									[10] = 5,
									[11] = 4,
									[12] = 3,
									[13] = 2,
									[14] = 4,
									[15] = 1,
								}

								local a_priority = kind_priority[a.kind] or 0
								local b_priority = kind_priority[b.kind] or 0

								if a_priority ~= b_priority then
									return a_priority > b_priority
								end

								return #a_label < #b_label
							end)
							return items
						end,
					},
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},
}
