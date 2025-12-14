-- Packages
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/projekt0n/github-nvim-theme",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/mfussenegger/nvim-dap-python",
	"https://github.com/igorlfs/nvim-dap-view",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/folke/flash.nvim",
})

-- Theme
vim.cmd("colorscheme github_dark_dimmed")

-- which-key
local wk = require("which-key")
wk.setup()

-- flash.nvim
require("flash").setup()

-- General nvim settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true

-- Auto-reload files when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	command = "if mode() != 'c' | checktime | endif",
})

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FzfLua: Find Files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FzfLua: Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FzfLua: Live Grep" })

vim.keymap.set("n", "<leader>r", "<cmd>source $MYVIMRC<CR>", { silent = false, desc = "Reload Neovim Config" })

-- Flash keymaps
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "LSP: Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true, desc = "LSP: Go to Definition" })

-- Tmux navigator
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true, desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true, desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true, desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true, desc = "Navigate Right" })
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { silent = true, desc = "Navigate Previous" })

-- LSP and formatters
vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	filetypes = { "python" },
	settings = {
		basedpyright = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "standard",
				inlayHints = {
					callArgumentNames = false,
				},
			},
		},
	},
})
vim.lsp.enable("basedpyright")

vim.lsp.config("ruff", {
	cmd = { "ruff", "server", "--preview" },
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	filetypes = { "python" },
})
vim.lsp.enable("ruff")

require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_organize_imports", "ruff_format" },
		lua = { "stylua" },
	},
	format_after_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- nvim-dap/debugging
require("dap-python").setup("$HOME/.venv/bin/python")
vim.keymap.set("n", "<leader>dn", "<Cmd>DapNew<CR>", {
	noremap = true,
	silent = true,
	desc = "DAP New Session (Launch/Attach)",
})

vim.keymap.set("n", "<leader>db", "<Cmd>DapToggleBreakpoint<CR>", {
	noremap = true,
	silent = true,
	desc = "DAP Toggle Breakpoint",
})
vim.keymap.set("n", "<F6>", "<Cmd>DapStepOver<CR>", {
	noremap = true,
	silent = true,
	desc = "Dap stepover",
})

vim.keymap.set("n", "<F7>", "<Cmd>DapStepInto<CR>", {
	noremap = true,
	silent = true,
	desc = "Dap into",
})
vim.keymap.set("n", "<F5>", "<Cmd>DapContinue<CR>", {
	noremap = true,
	silent = false,
	desc = "Dap continue",
})
vim.keymap.set("n", "<F4>", "<Cmd>DapRestartFrame<CR>", {
	noremap = true,
	silent = false,
	desc = "Dap restart frame",
})
vim.keymap.set("n", "<F19>", "<Cmd>DapStepOut<CR>", {
	noremap = true,
	silent = true,
	desc = "Dap out",
})

vim.keymap.set("n", "<leader>dv", "<Cmd>DapViewToggle<CR>", {
	noremap = true,
	silent = true,
	desc = "Toggle Dap View",
})
