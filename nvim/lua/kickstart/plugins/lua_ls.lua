return {

	vim.lsp.config("lua-ls", {
		settings = {
			Lua = {
				-- 1) Tell the server which Lua version you use (Neovim runs on LuaJIT)
				runtime = {
					version = "LuaJIT",
					-- Make the server aware of your package.path
					path = vim.split(package.path, ";"),
				},
				-- 2) Register the `vim` global so diagnostics won’t complain
				diagnostics = {
					globals = { "vim" },
				},
				-- 3) Make the server load Neovim runtime files so it knows about all the vim.* APIs
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false, -- prevent prompting to install additional working sets
				},
				telemetry = {
					enable = false,
				},
			},
		},
	}),
}
