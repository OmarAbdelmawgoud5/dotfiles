-- Editor Enhancement Plugins

return {
	-- Comments
	{
		"numToStr/Comment.nvim",
		opts = {},
	},

	-- Git Signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Autopairs
	require("kickstart.plugins.autopairs"),

	-- Autocomplete additions
	{
		"stevearc/conform.nvim",
		opts = {},
	},
}
