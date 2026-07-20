-- LSP Configuration

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			-- LSP Attach Autocommand

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- Inlay hints toggle
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
					-- WARNING TOGGLE
					map("<leader>tw", function()
						-- Get the current global diagnostic configuration
						local current_config = vim.diagnostic.config()

						-- Check if we are currently hiding warnings (by checking if virtual_text is restricted to ERROR)
						local is_hiding_warnings = type(current_config.virtual_text) == "table"
							and current_config.virtual_text.severity == vim.diagnostic.severity.ERROR

						if is_hiding_warnings then
							-- TURN WARNINGS ON (Restores your original config)
							vim.diagnostic.config({
								virtual_text = { source = "if_many", spacing = 2 },
								signs = {
									text = {
										[vim.diagnostic.severity.ERROR] = "✖",
										[vim.diagnostic.severity.WARN] = "⚠",
										[vim.diagnostic.severity.HINT] = "⚡",
										[vim.diagnostic.severity.INFO] = "ℹ",
									},
								},
								underline = { severity = vim.diagnostic.severity.ERROR },
							})
							print("Warnings Enabled")
						else
							-- TURN WARNINGS OFF (Restricts diagnostics to Errors ONLY)
							vim.diagnostic.config({
								virtual_text = {
									severity = vim.diagnostic.severity.ERROR,
									source = "if_many",
									spacing = 2,
								},
								signs = { severity = vim.diagnostic.severity.ERROR },
								underline = { severity = vim.diagnostic.severity.ERROR },
							})
							print("Warnings Disabled")
						end
					end, "[T]oggle [W]arnings")
					-- Document highlight
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- Diagnostic Configuration
			vim.diagnostic.config({
				-- 1. Enable virtual text (the text next to the code)
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						return diagnostic.message
					end,
				},

				-- 2. The NEW WAY to set icons (prevents the deprecation warning)
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✖",
						[vim.diagnostic.severity.WARN] = "⚠",
						[vim.diagnostic.severity.HINT] = "⚡",
						[vim.diagnostic.severity.INFO] = "ℹ",
					},
				},

				-- 3. Other visual settings
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				update_in_insert = false,
			})
			-- Capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Server Configurations
			local servers = {
				clangd = {
					capabilities = capabilities,
					cmd = { "clangd", "--function-arg-placeholders=false" },
					flags = { debounce_text_changes = 150 },
				},
				lua_ls = {
					root_dir = require("lspconfig.util").root_pattern(".luarc.json", ".luacheckrc", ".git", "init.lua"),
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				},
				phpactor = {},
			}

			-- Mason Setup
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, { "stylua" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- LSP File Operations
			local ok, lsp_file_ops = pcall(require, "lsp-file-operations")
			local file_ops_caps = {}
			if ok and lsp_file_ops and lsp_file_ops.default_capabilities then
				file_ops_caps = lsp_file_ops.default_capabilities()
			end

			-- Mason LSP Config Setup
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					-- 1. Default handler for all servers (Python, Lua, etc.)
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,

					-- 2. SPECIFIC HANDLER FOR JAVA
					-- This function overwrites the default one above just for jdtls.
					-- By leaving it empty, we prevent Client 1 from ever starting.
				},
			})
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
