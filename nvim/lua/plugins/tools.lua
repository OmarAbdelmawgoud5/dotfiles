-- Development Tools

return {
	-- Code Runner
	{
		"CRAG666/code_runner.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("code_runner").setup({
				mode = "term",
				focus = true,
				filetype = {
					java = [[
if [ -f "pom.xml" ]; then
    if grep -q "spring-boot" "pom.xml"; then
        mvn spring-boot:run
    else
        PKG=$(echo "$dir" | sed 's|.*/src/main/java/||;s|/$||' | tr '/' '.' | tr -d "'")
        NAME=$(echo "$fileNameWithoutExt" | tr -d "'")
        if [ -n "$PKG" ]; then
            FQCN="$PKG.$NAME"
        else
            FQCN="$NAME"
        fi
        echo "Running standard Maven class: $FQCN"
        mvn compile exec:java -Dexec.mainClass="$FQCN"
    fi
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    if echo "$dir" | grep -q 'src/main/java'; then
        APP_DIR=$(echo "$dir" | sed 's|/src/main/java.*||')
        cd "$APP_DIR" && gradle bootRun
    else
        gradle bootRun
    fi
else
    cd "$dir"
    javac "$fileName"
    java "$fileNameWithoutExt"
fi
]],
					python = "python3 -u",
					typescript = "deno run",
					rust = {
						"cd $dir &&",
						"rustc $fileName &&",
						"$dir/$fileNameWithoutExt",
					},
					go = "cd $dir && go run $fileName",
				},
			})

			vim.keymap.set("n", "<leader>r", function()
				vim.cmd("write")
				vim.cmd("RunCode")
				vim.defer_fn(function()
					local current_buf = vim.api.nvim_get_current_buf()
					local buf_name = vim.api.nvim_buf_get_name(current_buf)
					local buf_type = vim.api.nvim_get_option_value("buftype", { buf = current_buf })

					if buf_type == "terminal" or string.match(buf_name, "term://") then
						vim.cmd("startinsert")
					end
				end, 100)
			end, { desc = "Save and run code" })
		end,
	},

	-- Neotest (Testing)
	require("kickstart.plugins.debug"),

	-- Linting
	require("kickstart.plugins.lint"),

	-- Go.nvim
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		config = function(lp, opts)
			require("go").setup(opts)
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").goimports()
				end,
				group = format_sync_grp,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},
	-- PHPActor (PHP)
	{
		"gbprod/phpactor.nvim",
		ft = "php",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.phpactor.setup({
				cmd = { "phpactor", "language-server" },
				filetypes = { "php" },
				root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
			})
		end,
	},
	-- {
	--	"folke/noice.nvim",
	--       event = "VeryLazy",
	--      opts = {
	-- add any options here
	--     },
	--    dependencies = {
	-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	--   	"MunifTanjim/nui.nvim",
	-- OPTIONAL:
	--   `nvim-notify` is only needed, if you want to use the notification view.
	--   If not available, we use `mini` as the fallback
	--  	"rcarriga/nvim-notify",
	-- },
	--},

	-- Molten (Jupyter Notebooks)
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
		end,
		config = function()
			vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize Molten" })
			vim.keymap.set(
				"n",
				"<leader>e",
				":MoltenEvaluateOperator<CR>",
				{ silent = true, desc = "Evaluate selection" }
			)
			vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Evaluate line" })
			vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "Re-evaluate cell" })
			vim.keymap.set(
				"v",
				"<localleader>r",
				":<C-u>MoltenEvaluateVisual<CR>gv",
				{ silent = true, desc = "Evaluate visual" }
			)
		end,
	},

	-- Jupytext
	{ "GCBallesteros/jupytext.nvim", config = true },

	-- Guess Indent
	"NMAC427/guess-indent.nvim",

	-- Vim Be Good (Vim Game)
	"ThePrimeagen/vim-be-good",

	-- Text Objects
	"kana/vim-textobj-user",
	{
		"kana/vim-textobj-function",
		dependencies = { "kana/vim-textobj-user" },
	},

	-- Plenary (Utility)
	{ "nvim-lua/plenary.nvim" },
}
