-- Packages
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/projekt0n/github-nvim-theme",
	"https://github.com/oskarnurm/koda.nvim",
	"https://github.com/slugbyte/lackluster.nvim",
	"https://github.com/savq/melange-nvim",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/mfussenegger/nvim-dap-python",
	"https://github.com/igorlfs/nvim-dap-view",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/kdheepak/lazygit.nvim",
	"https://github.com/linrongbin16/gitlinker.nvim",
	"https://github.com/mistweaverco/kulala.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/echasnovski/mini.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/iamcco/markdown-preview.nvim",
})

-- Theme
vim.cmd("colorscheme lackluster-hack")

-- which-key
local wk = require("which-key")
wk.setup()
wk.add({
	{ "<leader>c", group = "Code" },
	{ "<leader>d", group = "Debug" },
	{ "<leader>g", group = "Git" },
	{ "<leader>h", group = "HTTP/REST" },
	{ "<leader>m", group = "Markdown" },
	{ "<leader>t", group = "Terminal" },
})

-- flash.nvim
require("flash").setup()

-- nvim-autopairs
require("nvim-autopairs").setup({
	check_ts = false,
})

-- mini.completion
require("mini.completion").setup()

-- render-markdown
require("render-markdown").setup()

vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown Render" })
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Browser Preview" })

-- toggleterm
require("toggleterm").setup({
	direction = "float",
	float_opts = {
		border = "curved",
	},
	open_mapping = [[<C-t>]],
})

-- nvim-tree

-- first, disable the built-in filetree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
	view = {
		width = 35,
	},
	renderer = {
		group_empty = true,
		icons = {
			show = {
				file = false,
				folder = false,
				folder_arrow = true,
				git = false,
			},
		},
	},
	filters = {
		dotfiles = false,
	},
	hijack_directories = {
		enable = false,
	},
})

-- General nvim settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true
vim.opt.foldmethod = "manual"
vim.opt.swapfile = false

-- Filetype associations
vim.filetype.add({
	extension = {
		jsonl = "json",
	},
})

-- Window resize behavior: equalize widths only (horizontal)
vim.opt.equalalways = true
vim.opt.eadirection = "hor"

-- Auto-reload files when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	command = "if mode() != 'c' | checktime | endif",
})

-- Equalize window widths when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	command = "wincmd =",
})

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Explorer" })
vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files({
		cmd = "fd --type f --exec-batch ls -1t",
	})
end, { desc = "FzfLua: Find Files (cwd)" })
vim.keymap.set("n", "<leader>fa", function()
	require("fzf-lua").files({ cmd = "fd --type f --hidden --no-ignore" })
end, { desc = "FzfLua: Find ALL Files (including ignored)" })
vim.keymap.set("n", "<leader>fF", function()
	require("fzf-lua").files({ cwd = vim.env.HOME })
end, { desc = "FzfLua: Find Files (home)" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FzfLua: Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FzfLua: Buffers" })
vim.keymap.set("n", "<leader>fs", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "FzfLua: Document Symbols" })
vim.keymap.set("n", "<leader>fS", function()
	require("fzf-lua").lsp_live_workspace_symbols()
end, { desc = "FzfLua: Workspace Symbols" })

vim.keymap.set("n", "<leader>r", "<cmd>source $MYVIMRC<CR>", { silent = false, desc = "Reload Neovim Config" })

-- Toggleterm keymap
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- Flash keymaps
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "LSP: Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true, desc = "LSP: Go to References" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "Code Action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { silent = true, desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>xx", vim.diagnostic.open_float, { silent = true, desc = "Show Diagnostics" })
vim.keymap.set("n", "<leader>xq", vim.diagnostic.setqflist, { silent = true, desc = "Send Diagnostics to Quickfix" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Go to Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Go to Next Diagnostic" })

-- Tmux navigator
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true, desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true, desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true, desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true, desc = "Navigate Right" })
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { silent = true, desc = "Navigate Previous" })

-- gitlinker
require("gitlinker").setup({
	message = false, -- Don't show message in command line
})

vim.keymap.set({ "n", "v" }, "<leader>gy", "<cmd>GitLink<cr>", { silent = true, desc = "Copy Git Link" })
vim.keymap.set({ "n", "v" }, "<leader>go", "<cmd>GitLink!<cr>", { silent = true, desc = "Open Git Link" })

-- lazygit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { silent = true, desc = "LazyGit" })
vim.keymap.set("n", "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", { silent = true, desc = "LazyGit Current File" })

-- treesitter: ensure http parser is installed
local ts_installed = require("nvim-treesitter").get_installed("parsers")
if not vim.tbl_contains(ts_installed, "http") then
	require("nvim-treesitter").install({ "http" })
end

-- kulala.nvim (HTTP client)
require("kulala").setup({
	split_direction = "vertical",
	ui = {
		max_response_size = 50 * 1024 * 1024, -- 50MB
	},
})

vim.keymap.set("n", "<leader>hr", function()
	require("kulala").run()
end, { desc = "HTTP: Run Request" })

vim.keymap.set("n", "<leader>hi", function()
	require("kulala").inspect()
end, { desc = "HTTP: Inspect Request/Response" })

vim.keymap.set("n", "<leader>hc", function()
	require("kulala").copy()
end, { desc = "HTTP: Copy as cURL" })

vim.keymap.set("n", "<leader>ht", function()
	require("kulala").toggle_view()
end, { desc = "HTTP: Toggle Headers/Body" })

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
		python = {
			pythonPath = vim.fn.exepath("python3"),
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

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	root_markers = { "tsconfig.json", "package.json", ".git" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	init_options = {
		-- Large monorepos (e.g. hightouch) blow past tsserver's default ~3GB heap
		-- and the server silently OOMs, breaking go-to-definition. Bump it.
		maxTsServerMemory = 8192,
	},
})
vim.lsp.enable("ts_ls")

require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_organize_imports", "ruff_format" },
		lua = { "stylua" },
		json = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
	},
	format_after_save = function(bufnr)
		-- Disable autoformat on save for http files
		if vim.bo[bufnr].filetype == "http" then
			return
		end
		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
})

-- nvim-dap/debugging
-- Resolve the project-local venv python, falling back to $HOME/.venv/bin/python
local function get_python_path()
	local venv = os.getenv("VIRTUAL_ENV")
	if venv then
		return venv .. "/bin/python"
	end
	local cwd_venv = vim.fn.getcwd() .. "/.venv/bin/python"
	if vim.fn.executable(cwd_venv) == 1 then
		return cwd_venv
	end
	return vim.fn.expand("$HOME/.venv/bin/python")
end

require("dap-python").setup(get_python_path())
require("dap-python").resolve_python = get_python_path

-- nvim-dap-view setup
require("dap-view").setup({
	windows = {
		terminal = {
			start_hidden = false,
		},
	},
})
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

vim.keymap.set("n", "<leader>dc", function()
	require("dap").continue()
end, {
	noremap = true,
	silent = true,
	desc = "DAP Continue",
})

vim.keymap.set("n", "<leader>dr", function()
	require("dap").restart()
end, {
	noremap = true,
	silent = true,
	desc = "DAP Restart Session",
})

vim.keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
end, {
	noremap = true,
	silent = true,
	desc = "DAP Terminate Session",
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
