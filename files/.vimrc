"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Personal vim rice
" 
" Sections:
"   General
"   UI
"   Colors & Fonts
"   Spaces & Tabs
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
let mapleader=","           " Leader is comma

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
set number			        " Add line numbers 
set showcmd			        " Show command in bottom bar
set cursorline			    " Highlight current line
filetype indent on		    " Load filetype-specific indent files
set wildmenu			    " Visual autocomplete for command menu
set lazyredraw			    " Redraw only when needed
set showmatch			    " Highlight matching brackets
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

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable 			    " Syntax theme
colorscheme onedark		    " awesome colorscheme

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spaces & Tabs 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4			    " Number of visual spaces per TAB
set softtabstop=4		    " Number of spaces in tab when editing
set expandtab			    " Tabs are spaces


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
set incsearch 			    " Search as characters are typed
set hlsearch			    " Hightlight matches
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable 			    " Enable folding
set foldlevelstart=10	    " Open most folds by default
set foldnestmax=10		    " 10 nested fold max
" space open/closes folds
nnoremap <space> za
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

Plug 'scrooloose/nerdtree'                  " A tree explorer plugin for vim
Plug 'sjl/gundo.vim'                        " Gundo.vim is Vim plugin to visualize your Vim undo tree.
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' } " Autocomplete
Plug 'junegunn/goyo.vim'                    " Distraction free mode
Plug 'itchyny/lightline.vim'                " A light and configurable statusline/tabline plugin for Vim
Plug 'maxbrunsfeld/vim-yankstack'           " Maintains a history of previous yanks
Plug 'tpope/vim-commentary'                 " Comment stuff
Plug 'joshdick/onedark.vim'                 " Colorscheme
Plug 'danro/rename.vim'                     " Rename files
Plug 'leafgarland/typescript-vim'           " Syntax highlighting for ts files
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'} " Go

call plug#end()

" Install the colorscheme
if empty(glob("~/.vim/autoload/onedark.vim"))
    execute 'cp ~/.vim/bundle/onedark.vim/colors/onedark.vim ~/.vim/colors/onedark.vim && cp ~/.vim/bundle/onedark.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim'
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on 	            " Enable plugin

" Open NERDTree with Control + n
map <C-n> :NERDTreeToggle<CR> 

" Open a NERDTree automatically if no file is specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle gundo with ,u
nnoremap <leader>u :GundoToggle<CR>

" Load goyo
autocmd! User goyo.vim echom 'Goyo is now loaded!'

" Yankstack binds
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
