Plug 'puremourning/vimspector'

let g:vimspector_enable_mappings = 'HUMAN'

nnoremap <leader>dc :call win_gotoid(g:vimspector_session_windows.code)<CR>
nnoremap <leader>do :call win_gotoid(g:vimspector_session_windows.output)<CR>
nnoremap <leader>dw :call win_gotoid(g:vimspector_session_windows.watches)<CR>
nnoremap F7 :call vimspector#RunToCursor()<CR>
nnoremap <leader>dq :call vimspector#Reset()<CR>
