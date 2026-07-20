require("lspconfig").sqls.setup({
	settings = {
		sqls = {
			connections = {
				{
					driver = "mysql", -- or 'mysql', 'sqlite3'
					dataSourceName = "host=127.0.0.1 port=3306 user=root password=pass dbname=bookstore",
				},
			},
		},
	},
})
