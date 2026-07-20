-- Vim Options Configuration

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Font
vim.g.have_nerd_font = true

-- Completion
vim.o.completeopt = "menu,menuone,noselect"

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Mouse
vim.o.mouse = "a"

-- Mode display
vim.o.showmode = false

-- Clipboard
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Indentation
vim.o.breakindent = true

-- Undo
vim.o.undofile = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sign column
vim.o.signcolumn = "yes"

-- Update timing
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Virtual editing
vim.o.virtualedit = "all"

-- Whitespace display
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "⣾" }

-- Command preview
vim.o.inccommand = "split"

-- Cursor line
vim.o.cursorline = true

-- Scroll offset
vim.o.scrolloff = 10

-- Confirm unsaved changes
vim.o.confirm = true

-- Terminal colors
vim.o.termguicolors = true
