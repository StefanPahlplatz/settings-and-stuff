" contents of minimal .vimrc
execute pathogen#infect()
filetype plugin indent on

" Open a NERDTree automatically if no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree shortcut
map <C-n> :NERDTreeToggle<CR>

" Syntax theme
syntax enable
set background=dark
colorscheme dracula

" Add line numbers
set number
