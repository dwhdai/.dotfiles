Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'akinsho/bufferline.nvim'

" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
nnoremap <silent><A-[> :BufferLineCyclePrev<CR>
nnoremap <silent><A-]> :BufferLineCycleNext<CR>

" Re-order to previous/next
nnoremap <silent><A-{> :BufferLineMovePrev<CR>
nnoremap <silent><A-}> :BufferLineMoveNext<CR>

" Select a buffer to be closed
nnoremap <silent><A-w> :BufferLinePickClose<CR>
