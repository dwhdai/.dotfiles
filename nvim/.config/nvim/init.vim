" --------------------------------
" General settings
" --------------------------------

syntax on

set cursorline
set expandtab
set shiftwidth=4
set tabstop=4
set hidden
set relativenumber
set number
set termguicolors
set undofile
set list
set listchars=tab:▸\ ,trail:·
set title
set ignorecase
set smartcase
set nowrap
set mouse=a
set scrolloff=8
set sidescrolloff=8
set splitbelow
set splitright
set nobackup
set encoding=UTF-8
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files

" Line width indication
augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength guibg=#FCBE7A
  autocmd BufEnter * match OverLength /\%100v.*/
augroup END

" -------------------------------
"  Keymaps
" -------------------------------
let mapleader = "\<space>"
nnoremap <C-s> :w<CR>

" window management
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-c> <C-w>c
nnoremap <C-w>> :vertical resize +5<CR>
nnoremap <C-w>< :vertical resize -5<CR>
nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>

" Allow gf to open non-existent files
map gf :edit <cfile><cr>

" Quicky escape to normal mode
imap jj <esc>

"--------------------------------------------------------------------------
" Plugins 
"--------------------------------------------------------------------------

call plug#begin("~/.config/nvim/plugged")

source ~/.config/nvim/plugins/sonokai.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/dracula.vim
source ~/.config/nvim/plugins/floaterm.vim
source ~/.config/nvim/plugins/lsp-config.vim
source ~/.config/nvim/plugins/nvim-compe.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/surround.vim
source ~/.config/nvim/plugins/vimspector.vim
source ~/.config/nvim/plugins/vim-maximizer.vim
source ~/.config/nvim/plugins/autopairs.vim
source ~/.config/nvim/plugins/bufferline.vim
source ~/.config/nvim/plugins/lualine.vim
source ~/.config/nvim/plugins/telescope.vim


call plug#end()
doautocmd User PlugLoaded
lua require'lspconfig'.pyright.setup{}
lua require('nvim-autopairs').setup{}
lua require("bufferline").setup{}
lua require'lualine'.setup()
