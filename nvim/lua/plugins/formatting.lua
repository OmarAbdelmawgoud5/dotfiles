-- Formatting Configuration (conform.nvim)

return {
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			formatters = {
				["sql-formatter"] = {
					command = "sql-formatter",
					stdin = true,
				},
				shfmt = {
					args = { "-i", "2" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				java = { "google-java-format" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				sql = { "sql-formatter" },
				python = { "black" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				less = { "prettierd" },
				html = { "prettierd" },
				markdown = { "prettierd" },
				yaml = { "prettierd" },
				xml = { "xmlformat" },
			},
		},
	},
}
