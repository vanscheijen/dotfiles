" Use all (neo)vim capabilities
set nocompatible

" Enables 24-bit RGB color in the TUI
if has("termguicolors")
    set termguicolors
endif

" Disable modelines, workaround for CVE-2019-12735
set modelines=0
set nomodeline

" Auto utf8 enconding when supported
set encoding=utf-8
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set fileencodings=ucs-bom,utf-8,latin1
endif

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Keep 50 lines of command line history
set history=50
" Show the cursor position all the time
set ruler
" Always show statusline
set laststatus=2

" Indentation and Tab settings
set autoindent
set copyindent
set expandtab
set nosmarttab
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Automatically re-read file if a change was detected outside of vim
set autoread

" Hide buffers instead of closing them
set hidden

" no sound
set noerrorbells

" set window title
set title

" Special Neovim options
if has("nvim")
    " Transparent popups
    set pumblend=25
    " Neovim feature that enable live substitution
    set inccommand=nosplit

    "Neovide support
    " set guioptions-=m
    " set guioptions-=T
    " set guioptions-=r
    " set guioptions-=L
    set guifont=SauceCodePro\ Nerd\ Font:h18
endif

" command-line completion operates in an enhanced mode
set wildmenu
set wildchar=<Tab>
set wildmode=full
set wildignore+=*.dll,*.o,*.pyc,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*$py.class,*.class,*/*.dSYM/*,*.dylib,*/venv,*/target

" No wrapping
set nowrap
set textwidth=80
" Highlight 81th column if used
highlight ColorColumn ctermbg=blue
call matchadd('ColorColumn', '\%81v', 100)
" Increase textwidth for certain files
autocmd FileType text,markdown,tex setlocal textwidth=120

" Make tabs, trailing whitespace, and non-breaking spaces visible

nnoremap <silent> F :call ListToggle()<cr>
function! ListToggle()
    "set invlist
    if &list
        set nolist
        set autoindent
        set copyindent
        set expandtab
        set softtabstop=4
    else
        set noautoindent
        set nocopyindent
        set noexpandtab
        set softtabstop=0
        set showbreak=↪\  " Do not strip trailing whitespace here
        set listchars=tab:▶⭬,nbsp:‡,space:•,extends:❯,precedes:❮,eol:↲
        set list
    endif
endfunction

" Print syntax highlighting (to pdf/html/printer)
set printoptions+=syntax:y

" Show matching parenthesis
set showmatch

" Always have 5 lines above and below, and 5 columns to the side
set scrolloff=5
set sidescrolloff=5

" Enable mouse for all modes, use Shift to delegate to terminal emulator
set mouse=a

" Synchronize clipboard with yank buffer
set clipboard+=unnamedplus

" Enable spell-checking for certain files
autocmd FileType text,markdown setlocal spell

" Highlight search patterns
set hlsearch
set incsearch "show matches as you type
set gdefault "g flag on by default when searching
set ignorecase "case insensitive search by default
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
set smartcase "the search result will only be case sensitive if the query contains uppercase

" Set leader to space bar
let mapleader="\<space>"
let maplocalleader=","
" Longer leader key timeout
set timeout timeoutlen=1000

" Semicolon is same as colon
nnoremap ; :
vnoremap ; :

" Use Ctrl-C to switch between normal and insert mode
nnoremap <C-c> a
inoremap <C-c> <ESC>

" No text wrapping while typing
set formatoptions-=t

" Folding
set foldenable
set foldnestmax=1
nnoremap <silent> f :call FoldColumnToggle()<cr>
function! FoldColumnToggle()
    if &foldcolumn
        exec "normal zR"
        set foldmethod=manual
        setlocal foldcolumn=0
    else
        exec "normal zM"
        set foldmethod=indent
        setlocal foldcolumn=2
    endif
endfunction

" Line number column
" set relativenumber number
set cpoptions+=n
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
noremap <silent> <F3> :set invrelativenumber invnumber<CR>
inoremap <silent> <F3> <C-O>:set invrelativenumber invnumber<CR>
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * if &number | set relativenumber | endif
    autocmd FocusLost,InsertEnter * if &number | set norelativenumber | endif
augroup END

set pastetoggle=<F6>

" Fix identation with one key
map <F7> ggVG=

" remap shift+y to function like shift+d (i. e. Yank until the end of the line)
map Y y$

" Use control-arrow to move through windows
map <C-left> <C-w>h
map <C-down> <C-w>j
map <C-up> <C-w>k
map <C-right> <C-w>l

" Use control-tab to move through buffers
map <C-i> :bn<CR>

function! StripTrailingWhitespace()
    " Indentation and Tab settings
    set autoindent
    set copyindent
    set expandtab
    set nosmarttab
    set shiftround
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction
nnoremap <silent> <leader>sw :call StripTrailingWhitespace()<CR>

" Plugins "
"""""""""""

if !empty(glob("~/.vim/plugins"))
    set runtimepath+=$HOME/.vim
    runtime! plugins/*.vim
endif

" https://github.com/jiangmiao/auto-pairs (Ctrl-p)
let b:autopairs_enabled = 0
let g:AutoPairsShortcutToggle="<C-p>"
let g:AutoPairsFlyMode=1
let g:AutoPairsMapBS=0
au FileType html let b:AutoPairs=AutoPairsDefine({'<!--' : '-->'})
au FileType php let b:AutoPairs=AutoPairsDefine({'<?' : '?>', '<?php': '?>'})
au FileType ruby let b:AutoPairs=AutoPairsDefine({'\v(^|\W)\zsbegin': 'end//n'})
au FileType rust let b:AutoPairs=AutoPairsDefine({'\w\zs<': '>'})

" gcc to comment a line
" autocmd FileType apache setlocal commentstring=#\ %s

" dragvisuals plugin
vmap <expr> <S-LEFT>  DVB_Drag('left')
vmap <expr> <S-RIGHT> DVB_Drag('right')
vmap <expr> <S-DOWN>  DVB_Drag('down')
vmap <expr> <S-UP>    DVB_Drag('up')
vmap <expr> D         DVB_Duplicate()

" vmath plugin
vmap <expr> ++        VMATH_YankAndAnalyse()
nmap        ++        vip++

" https://vimways.org/2019/personal-notetaking-in-vim/
func ZettelEdit(...)
    " build the file name
    let l:sep = ''
    if len(a:000) > 0
        let l:sep = '-'
    endif
    let l:fname = expand('~/Documents/zettel/') . strftime("%F-%H%M") . l:sep . join(a:000, '-') . '.md'

    " edit the new file
    exec "e " . l:fname

    " enter the title and timestamp (using ultisnips) in the new file
    if len(a:000) > 0
        exec "normal ggO\<c-r>=strftime('%Y-%m-%d %H:%M')\<cr> " . join(a:000) . "\<cr>\<esc>G"
    else
        exec "normal ggO\<c-r>=strftime('%Y-%m-%d %H:%M')\<cr>\<cr>\<esc>G"
    endif
endfunc
command! -nargs=* Zet call ZettelEdit(<f-args>)
map <silent> <leader>fz :FZF ~/Documents/zettel<cr>

" Simple wrapper around the internal profiler
func Profile()
    profile start ~/vim-profile.log

    profile file *
    autocmd QuitPre * profile stop
endfunc
command! Profile call Profile()

if !empty(glob("~/.vim/plugged"))
    call plug#begin('~/.vim/plugged')
    " :StartupTime
    Plug 'dstein64/vim-startuptime'

    " colorschemes
    Plug 'morhetz/gruvbox'

    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

    " Doesn't play nice with Clap
    " Plug 'camspiers/animate.vim'
    " Plug 'camspiers/lens.vim'

    " https://github.com/vim-airline/vim-airline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    "https://github.com/ryanoasis/vim-devicons
    Plug 'ryanoasis/vim-devicons'

    " https://github.com/vim-syntastic/syntastic
    Plug 'scrooloose/syntastic'

    " https://github.com/majutsushi/tagbar
    Plug 'majutsushi/tagbar'

    " https://github.com/kien/rainbow_parentheses.vim
    Plug 'junegunn/rainbow_parentheses.vim'

    Plug 'scrooloose/nerdtree'

    Plug 'mbbill/undotree'

    " https://github.com/terryma/vim-multiple-cursors
    " <C-n> or <A-n>
    Plug 'terryma/vim-multiple-cursors'
    " Plug 'mg979/vim-visual-multi', {'branch': 'master'}

    " <leader>gm
    Plug 'rhysd/git-messenger.vim'

    Plug 'sirver/ultisnips'
    Plug 'honza/vim-snippets'

    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh' }
    Plug 'junegunn/fzf'

    " deoplete/nvim-completion-manager v2
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-ultisnips'
    Plug 'filipekiss/ncm2-look.vim'

    Plug 'sheerun/vim-polyglot'
    Plug 'arzg/vim-rust-syntax-ext'

    " https://github.com/chrisbra/csv.vim
    Plug 'chrisbra/csv.vim'

    Plug 'liuchengxu/vim-clap'

    Plug 'machakann/vim-highlightedyank'

    " https://github.com/segeljakt/vim-isotope
    Plug 'segeljakt/vim-isotope'
    call plug#end()

    let g:gruvbox_contrast_dark='hard'
    colorscheme gruvbox

    " vim-which-key
    autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')

    nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
    nnoremap <silent> <localleader> :WhichKey '<localleader>'<CR>

    " Define prefix dictionary
    let g:which_key_map =  {}

    " Second level dictionaries:
    " 'name' is a special field. It will define the name of the group, e.g., leader-f is the "+file" group.
    " Unnamed groups will show a default empty string.

    " =======================================================
    " Create menus based on existing mappings
    " =======================================================
    " You can pass a descriptive text to an existing mapping.

    nnoremap <silent> <leader>c :Clap<CR>
    let g:which_key_map.c = 'clap'

    let g:which_key_map.f = { 'name' : '+file' }

    nnoremap <silent> <leader>fs :update<CR>
    let g:which_key_map.f.s = 'save-file'

    nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
    let g:which_key_map.f.d = 'open-vimrc'

    nnoremap <silent> <leader>ff :FZF<CR>
    let g:which_key_map.f.f = 'FZF'

    nnoremap <silent> <leader>oq  :copen<CR>
    nnoremap <silent> <leader>ol  :lopen<CR>
    let g:which_key_map.o = {
                \ 'name' : '+open',
                \ 'q' : 'open-quickfix'    ,
                \ 'l' : 'open-locationlist',
                \ }

    " =======================================================
    " Create menus not based on existing mappings:
    " =======================================================
    " Provide commands(ex-command, <Plug>/<C-W>/<C-d> mapping, etc.) and descriptions for existing mappings
    let g:which_key_map.b = {
                \ 'name' : '+buffer' ,
                \ '1' : ['b1'        , 'buffer 1']        ,
                \ '2' : ['b2'        , 'buffer 2']        ,
                \ 'd' : ['bd'        , 'delete-buffer']   ,
                \ 'f' : ['bfirst'    , 'first-buffer']    ,
                \ 'h' : ['Startify'  , 'home-buffer']     ,
                \ 'l' : ['blast'     , 'last-buffer']     ,
                \ 'n' : ['bnext'     , 'next-buffer']     ,
                \ 'p' : ['bprevious' , 'previous-buffer'] ,
                \ '?' : ['Buffers'   , 'fzf-buffer']      ,
                \ }

    let g:which_key_map.g = {
                \ 'name' : '+git',
                \ }

    nnoremap <silent> <leader>lr :RustFmt<CR>
    let g:which_key_map.l = {
                \ 'name' : '+lsp',
                \ 'r' : 'RustFmt',
                \ }

    let g:which_key_map.s = {
                \ 'name' : '+strip',
                \ 'w' : 'whitespace',
                \ }

    " More examples:
    " https://github.com/liuchengxu/space-vim/blob/master/core/autoload/spacevim/map/leader.vim

    " Airline settings
    let g:airline_highlighting_cache=1
    let g:airline_powerline_fonts=1
    let g:airline_skip_empty_sections=1
    let g:airline_theme='gruvbox'

    " Don't display mode in command line (airline already shows it)
    set noshowmode

    " airline extensions
    let g:airline#extensions#tabline#enabled=1
    let g:airline#extensions#ale#enabled=1
    let g:airline#extensions#coc#enabled=1
    let g:airline#extensions#unicode#enabled=1
    let g:airline#extensions#branch#enabled=1
    let g:airline#extensions#vista#enabled=1
    let g:airline#extensions#hunks#enabled=1

    " airline extension settings
    let g:airline#extensions#branch#format=2
    let g:airline#extensions#hunks#hunk_symbols=[':', ':', ':']
    let g:airline#extensions#tabline#formatter='unique_tail'

    " Devicons
    let g:webdevicons_enable=1
    let g:webdevicons_enable_unite=1
    let g:webdevicons_enable_denite=1
    let g:webdevicons_enable_nerdtree=1
    let g:webdevicons_enable_airline_tabline=1
    let g:webdevicons_enable_vimfiler=1
    let g:WebDevIconsUnicodeDecorateFileNodes=1
    let g:WebDevIconsUnicodeDecorateFolderNodes=1
    let g:WebDevIconsUnicodeGlyphDoubleWidth=1
    let g:webdevicons_enable_airline_statusline=1
    let g:WebDevIconsNerdTreeGitPluginForceVAlign=1
    let g:WebDevIconsUnicodeGlyphDoubleWidth=1
    let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol=''
    let g:DevIconsDefaultFolderOpenSymbol=''

    " Syntastic syntax checker
    let g:syntastic_always_populate_loc_list=1
    let g:syntastic_auto_loc_list=1
    let g:syntastic_check_on_open=1
    let g:syntastic_check_on_wq=0
    let g:syntastic_aggregate_errors = 1
    let g:syntastic_python_flake8_args='--ignore=W391,E501,E402,E265,E221,E722,E115'
    let g:syntastic_sh_checkers = ['bashate', 'sh']
    let g:syntastic_sh_bashate_args='--ignore=E006,E043'

    " NERDtree
    nnoremap <silent> <F2> :NERDTreeToggle<CR>

    " Undotree
    nnoremap <silent> <F5> :UndotreeToggle<CR>
    if has("persistent_undo")
        set undodir=~/.vim/undodir/
        set undofile
    endif

    " Tagbar settings
    nnoremap <silent> <F8> :TagbarToggle<CR>

    " Rainbow parentheses
    let g:rainbow#pairs=[['(', ')'], ['[', ']'], ['{', '}']]
    autocmd FileType * RainbowParentheses

    " Multiple cursors
    " Search and then press alt-j to cursor on all results
    " vnoremap <silent> <A-j> :MultipleCursorsFind <C-R>/<CR>
    " nnoremap <silent> <A-j> :MultipleCursorsFind <C-R>/<CR>

    " UltiSnips
    let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"

    " LanguageClient-Neovim
    let g:LanguageClient_autoStart=0
    let g:LanguageClient_serverCommands={'python': ['~/.local/bin/pyls'], 'rust': ['rls']}
    " let g:LanguageClient_loggingFile='/tmp/LanguageClient.log'
    " let g:LanguageClient_loggingLevel='DEBUG'

    nnoremap <silent> <leader>lcs :LanguageClientStart<CR>

    function LC_maps()
        if has_key(g:LanguageClient_serverCommands, &filetype)
            set completefunc=LanguageClient#complete
            set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

            nnoremap <silent> <F4> :call LanguageClient_contextMenu()<CR>
        endif
    endfunction
    autocmd FileType * call LC_maps()

    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()

    " IMPORTANT: :help Ncm2PopupOpen for more information
    au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
    au User Ncm2PopupClose set completeopt=menuone

    set shortmess+=c

    au TextChangedI * call ncm2#auto_trigger()

    inoremap <expr> <CR> (pumvisible() ? "\<C-y>\<CR>" : "\<CR>")
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

    autocmd FileType text let b:ncm2_look_enabled=1
else
    " when no colorscheme is used
    set background=dark

    " call plug#end() already does this, so only do when not using it
    filetype plugin indent on
    syntax on

    " Very simple nerdtree replacement
    nnoremap <silent> <F2> :20vs .<CR>

    " Replace airline with comprehensive statusline
    set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
    "              | | | | |  |   |      |  |     |    |
    "              | | | | |  |   |      |  |     |    +-- current column
    "              | | | | |  |   |      |  |     +-- current line
    "              | | | | |  |   |      |  +-- current % into file
    "              | | | | |  |   |      +-- current syntax
    "              | | | | |  |   +-- current fileformat
    "              | | | | |  +-- number of lines
    "              | | | | +-- preview flag in square brackets
    "              | | | +-- help flag in square brackets
    "              | | +-- readonly flag in square brackets
    "              | +-- rodified flag in square brackets
    "              +-- full path to file in the buffer
endif

