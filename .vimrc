" =========== COLORS =========== 
syntax enable 			" Syntax theme
colorscheme onedark		" awesome colorscheme


" =========== SPACES & TABS =========== 
set tabstop=4			" Number of visual spaces per TAB
set softtabstop=4		" Number of spaces in tab when editing
set expandtab			" Tabs are spaces


" =========== UI CONFIG =========== 
set number			    " Add line numbers 
set showcmd			    " Show command in bottom bar
set cursorline			" Highlight current line
filetype indent on		" Load filetype-specific indent files
set wildmenu			" Visual autocomplete for command menu
set lazyredraw			" Redraw only when needed
set showmatch			" Highlight matching brackets


" =========== SEARCHING =========== 
set incsearch 			" Search as characters are typed
set hlsearch			" Hightlight matches
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>


" =========== FOLDING ===========
set foldenable 			" Enable folding
set foldlevelstart=10	" Open most folds by default
set foldnestmax=10		" 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level


" =========== MOVEMENT ===========
" Move vertically by visual line
nnoremap j gj
nnoremap k gk
" Move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ <nop>
nnoremap ^ <nop>


" =========== LEADER SHORTCUTS ===========
let mapleader=","       "Leader is comma


" =========== PLUGINS ===========
" Load plugins from /bundle
execute pathogen#infect() 
filetype plugin on 	    " Enable plugin

" Toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" Open NERDTree shortcut
map <C-n> :NERDTreeToggle<CR> 

" Open a NERDTree automatically if no file is specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" =========== FUNCTIONS =========== 
" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction


" =========== CALL FUNCTIONS =========== 
autocmd VimEnter * call ToggleNumber()


" =========== PLUGINS =========== 
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
