Plug 'dracula/vim', { 'as': 'dracula' }

augroup DraculaOverrides
    autocmd User PlugLoaded ++nested colorscheme dracula
augroup end
