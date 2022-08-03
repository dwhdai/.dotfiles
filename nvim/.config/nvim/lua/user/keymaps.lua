local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Edit/source neovim config
keymap("n", "<Leader>vr", ":source $MYVIMRC<CR>", {}) 
keymap("n", "<Leader>ve", ":edit $MYVIMRC<CR>", {}) 

--Yank to clipboard
keymap("v", "<Leader>y", '\"+y', {})

--Paste from clipboard
keymap("n", "<Leader>p", '\"+gp', {})

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-up>", ":resize +2<CR>", opts)
keymap("n", "<C-down>", ":resize -2<CR>", opts)
keymap("n", "<C-left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-right>", ":vertical resize +2<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope --
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files({ hidden = false }, require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fF", "<cmd>lua require'telescope.builtin'.find_files({ hidden = true }, require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Bufferline
keymap("n", "<A-[>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<A-]>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<A-w>", ":BufferLinePickClose<CR>", opts)

-- Gitsigns
keymap("n", "<leader>Gb", ":Gitsigns blame_line<CR>", opts)
keymap("n", "<leader>Ga", ":Gitsigns stage_hunk<CR>", opts)
keymap("n", "<leader>Gu", ":Gitsigns undo_stage_hunk<CR>", opts)
keymap("n", "<leader>Gd", ":Gitsigns diffthis<CR>", opts)
keymap("n", "<leader>Gh", ":Gitsigns preview_hunk<CR>", opts)
keymap("n", "<leader>Gn", ":Gitsigns next_hunk<CR>", opts)
keymap("n", "<leader>GN", ":Gitsigns prev_hunk<CR>", opts)
