-- Packages
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/projekt0n/github-nvim-theme",
})

-- Theme
vim.cmd('colorscheme github_dark_dimmed')

-- General nvim settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('n', '<leader>ff', function()
  require('fzf-lua').files()
end, { desc = 'FzfLua: Find Files' })
vim.keymap.set('n', '<leader>fg', function()
  require('fzf-lua').live_grep()
end, { desc = 'FzfLua: Live Grep' })

-- LSP and formatters
vim.lsp.config("basedpyright", {cmd={"true"}})
vim.lsp.enable("basedpyright")
vim.lsp.config("ruff", {cmd={"true"}})
vim.lsp.enable("ruff")

require("conform").setup({
	formatters_by_ft = {
		python = {"ruff_organize_imports", "ruff_format"},
	},
	format_after_save = {},
})
