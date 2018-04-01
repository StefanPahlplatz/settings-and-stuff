"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Personal vim rice
"
" Sections:
"   General
"   Spaces & Tabs
"   UI
"   Colors & Fonts
"   Searching
"   Folding
"   Movement
"   Functions
"   Plugins
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" =>  GENERAL
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=700             " Sets how many lines vim has to remember
set autoread                " Set to auto read when a file is changed from the outside
set ignorecase
set smartcase
set hidden
let mapleader=","           " Leader is comma
set backspace=indent,eol,start
set confirm
set encoding=UTF-8
map Y y$

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev Q q
cnoreabbrev Qall qall

" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spaces & Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4               " Number of visual spaces per TAB
set softtabstop=4           " Number of spaces in tab when editing
set expandtab               " Tabs are spaces


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                  " Add line numbers
set showcmd                 " Show command in bottom bar
set cursorline              " Highlight current line
filetype indent on          " Load filetype-specific indent files
set wildmenu                " Visual autocomplete for command menu
set lazyredraw              " Redraw only when needed
set showmatch               " Highlight matching brackets
set foldcolumn=1            " Add a margin to the left
set laststatus=2            " Size for the status bar
set noshowmode              " Hides the mode below the status line

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
        set wildignore+=.git\*,.hg\*,.svn\*
else
        set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Colour correction or something
if (empty($TMUX))
        if (has("nvim"))
                let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif
        if (has("termguicolors"))
                set termguicolors
        endif
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable               " Syntax theme
colorscheme onedark         " awesome colorscheme

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
        set t_Co=256
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch               " Search as characters are typed
set hlsearch                " Hightlight matches
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable              " Enable folding
set foldlevelstart=10       " Open most folds by default
set foldnestmax=10          " 10 nested fold max
set foldmethod=indent       " fold based on indent level


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move vertically by visual line
nnoremap j gj
nnoremap k gk
" Move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ <nop>
nnoremap ^ <nop>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Use tab to switch tabs
nnoremap <Tab> gt

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pasting shortcut
set pastetoggle=<F3>

" Toggle between number and relativenumber
function! ToggleNumber()
        if(&relativenumber == 1)
                set norelativenumber
                set number
        else
                set relativenumber
        endif
endfunc

" Strips trailing whitespace at the end of files. This
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

autocmd VimEnter * call ToggleNumber()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Download vim-plug if it's not installed yet
if empty(glob("~/.vim/autoload/plug.vim"))
        execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/bundle')

" Workflow
Plug 'scrooloose/nerdtree'                  " A tree explorer plugin for vim
Plug 'Valloric/YouCompleteMe'               " Autocomplete
Plug 'junegunn/goyo.vim'                    " Distraction free mode
Plug 'itchyny/lightline.vim'                " A light and configurable statusline/tabline plugin for Vim
Plug 'maxbrunsfeld/vim-yankstack'           " Maintains a history of previous yanks
Plug 'tpope/vim-commentary'                 " Comment stuff
Plug 'joshdick/onedark.vim'                 " Colorscheme
Plug 'danro/rename.vim'                     " Rename files
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'} " Go
Plug 'sheerun/vim-polyglot'                 " A collection of language packs for Vim.
Plug 'Chiel92/vim-autoformat'               " Autoformat
Plug 'dkprice/vim-easygrep'                 " Refactoring
Plug 'jistr/vim-nerdtree-tabs'              " Nerdtree tabs
Plug 'davidhalter/jedi-vim'                 " Python autocomplete
Plug 'ryanoasis/vim-devicons'               " Nerdtree icons

call plug#end()

" Install the colorscheme
if empty(glob("~/.vim/autoload/onedark.vim"))
        execute 'cp ~/.vim/bundle/onedark.vim/colors/onedark.vim ~/.vim/colors/onedark.vim && cp ~/.vim/bundle/onedark.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim'
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on              " Enable plugin

" nerdtree
map <C-n> :NERDTreeTabsToggle<CR>
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

" Open a NERDTree automatically if no file is specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" goyo.vim
autocmd! User goyo.vim echom 'Goyo is now loaded!'

" Yankstack binds
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" vim-go
let g:go_disable_autoinstall = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" lightline
let g:lightline = {
                        \ 'colorscheme': 'onedark',
                        \ }

" Autoformat settings
let g:formatter_yapf_style = 'pep8'
noremap <space> :Autoformat<CR>

" vim-easygrep
let g:EasyGrepCommand=1
