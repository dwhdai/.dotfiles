" --------------------------------
" General settings
" --------------------------------

syntax on

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
set splitright
set nobackup
set encoding=UTF-8
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files

" -------------------------------
"  Keymaps
" -------------------------------
let mapleader = "\<space>"

nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vc :edit ~/.config/nvim/coc-settings.json<cr>
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
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/dracula.vim
source ~/.config/nvim/plugins/floaterm.vim
source ~/.config/nvim/plugins/coc.vim

call plug#end()
doautocmd User PlugLoaded

