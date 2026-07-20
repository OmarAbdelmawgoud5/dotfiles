-- Neovim Configuration Entry Point
-- Load configuration modules in order

-- 1. Load custom fixes first
require("custom.removeJavaNvimlspConfigDeprected")

-- 2. Load configuration files
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.highlights")

-- 3. Load plugins via lazy.nvim
require("plugins.init")
