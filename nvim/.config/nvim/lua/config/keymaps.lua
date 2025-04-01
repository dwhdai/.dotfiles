-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.api.nvim_set_keymap

local function nmap(lhs, rhs, opts)
	map("n", lhs, rhs, opts)
end

local function imap(lhs, rhs, opts)
	map("i", lhs, rhs, opts)
end

imap("jj", "<Esc>", { noremap = true, silent = true })
