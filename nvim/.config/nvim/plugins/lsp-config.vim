Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim'

" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> rr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)

