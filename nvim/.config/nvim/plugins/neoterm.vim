Plug 'kassio/neoterm'

set nocompatible
filetype off

let &runtimepath.='~/.config/nvim/plugged/neoterm'
let g:neoterm_default_mod='vertical botright'

nnoremap <cr> :TREPLSendLine<cr>j " send current line and move down
vnoremap <cr> :TREPLSendSelection<cr> " send current selection
nnoremap <leader>T :Tnew<cr>" start new terminal in vertical split 
filetype plugin on

