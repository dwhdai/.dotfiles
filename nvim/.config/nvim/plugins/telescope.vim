Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" File picker commands
nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fF <cmd>Telescope git_files<cr>
nnoremap <leader>fb <cmd>Telescope file_browser<cr>

" Vim picker commands
nnoremap <leader>fsh <cmd>Telescope search_history<cr>
nnoremap <leader>fch <cmd>Telescope command_history<cr>

" LSP commands
nnoremap <leader>gr <cmd> Telescope lsp_references<cr>
nnoremap <leader>gd <cmd> Telescope lsp_definitions<cr>
nnoremap <leader>gD <cmd> Telescope diagnostics bufnr=0<cr>

" Git picker commands
nnoremap <leader>gb <cmd> Telescope git_branches<cr>
nnoremap <leader>gs <cmd> Telescope git_status<cr>
nnoremap <leader>gC <cmd> Telescope git_commits<cr>
nnoremap <leader>gc <cmd> Telescope git_bcommits<cr>

