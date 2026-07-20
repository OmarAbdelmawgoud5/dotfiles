return {
	{
		"rcasia/neotest-java",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-dap", -- for the debugger
			"rcarriga/nvim-dap-ui", -- recommended
			"theHamsta/nvim-dap-virtual-text", -- recommended
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-java")({

						junit_jar = nil, -- default: stdpath("data") .. /nvim/neotest-java/junit-platform-console-standalone-[version].jar
						incremental_build = true,
					}),
				},
			})
			local neotest = require("neotest")

			vim.keymap.set("n", "<leader>tr", function()
				neotest.run.run()
			end, { desc = "Run Nearest Test" })
			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Run File" })
			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Debug Nearest" })
			vim.keymap.set("n", "<leader>ts", function()
				neotest.run.stop()
			end, { desc = "Stop Test" })
			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end, { desc = "Show Output" })
			vim.keymap.set("n", "<leader>tS", function()
				neotest.summary.toggle()
			end, { desc = "Toggle Summary" })
		end,
	},
}
