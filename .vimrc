set nocompatible

"" use vim-plug for plugin management
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

"" Declare the list of plugins.
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'moll/vim-bbye'
Plug 'Shougo/deoplete.nvim'
Plug 'preservim/nerdtree'
Plug 'edkolev/tmuxline.vim'
Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'craigemery/vim-autotag'
Plug 'tpope/vim-commentary'
Plug 'sainnhe/everforest'
Plug 'tpope/vim-fugitive'
Plug 'fladson/vim-kitty'
Plug 'sickill/vim-pasta'
Plug 'junegunn/vim-peekaboo'
Plug 'wlangstroth/vim-racket'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

"" template files
augroup templates
    autocmd BufNewFile *.c 0r ~/.vim/templates/skeleton.c
augroup END

"" user color customizations
augroup CustomColors
    autocmd!
    autocmd ColorScheme * hi Search cterm=NONE ctermfg=15 ctermbg=69
                      \ | hi IncSearch cterm=NONE ctermfg=15 ctermbg=69
                      \ | hi Visual cterm=NONE ctermfg=238 ctermbg=214
                      \ | hi CursorLine cterm=NONE ctermbg=236
                      \ | hi CursorLineNr cterm=NONE ctermfg=250 ctermbg=236
                      \ | hi LineNr cterm=NONE ctermfg=242
                      \ | hi SignColumn ctermbg=235
augroup END

"" everforest colortheme settings

"" For dark version.
set background=dark

"" Set contrast.
"" This configuration option sould be placed before `colorscheme everforest`.
"" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'medium'
let g:everforest_enable_italic = 0
let g:everforest_disable_italic_comment = 1

colorscheme everforest

"" autoformat on save with vim-autoformat (I'm using ALE for this now)
"" au BufWrite * :Autoformat

"" vim-autoformat settings
"" let g:formatters_python = ['yapf']
"" let g:autoformat_autoindent = 0
"" let g:autoformat_retab = 0
"" let g:autoformat_remove_trailing_spaces = 0


set hidden
set wildmenu
set showcmd

set hlsearch
set incsearch
nnoremap <Space> :nohl<CR>

set backspace=start

set ignorecase
set smartcase

set ruler
set cursorline

set laststatus=2

set confirm

set cmdheight=2

set number

set pastetoggle=<F9>

"" indentation settings
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent

"" use real tabs in makefiles
autocmd FileType make set noexpandtab ts=8

"" easily run python files
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>

nnoremap <C-m> maO<Esc>`a
nnoremap <C-n> mao<Esc>`a

"" change buffers with gn and gp
"" delete buffer with gd
nnoremap <silent> gn :bn<CR>
nnoremap <silent> gp :bp<CR>
nnoremap <silent> gd :Bdelete<CR>

"" save file with <C-S>
nmap <C-S> :w<CR>

"" commentary settings for this file
autocmd FileType vim setlocal commentstring=\"\"\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType python setlocal commentstring=#\ %s

"" syntastic settings (I'm using ALE instead rn)
"" set statusline+=%#warningmsg#
"" set statusline+=%{SyntasticStatuslineFlag()}
"" set statusline+=%*

"" let g:syntastic_enable_highlighting = 0
"" let g:syntastic_always_populate_loc_list = 1
"" let g:syntastic_auto_loc_list = 2
"" let g:syntastic_check_on_open = 1
"" let g:syntastic_check_on_wq = 0
"" let g:syntastic_enable_balloons = 1
"" let g:syntastic_enable_racket_racket_checker = 1

"" ale settings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> gt <Plug>(ale_go_to_definition)

let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_lint_delay = 300
let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'python': ['pylsp'],
\   'c': ['cc'],
\}

let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'python': ['yapf'],
\   'c': ['clang-format'],
\}

"" beep

"" ultisnips settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"" airline settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='everforest'
let g:airline_section_b=airline#section#create(['%{FugitiveStatusline()}'])
let g:airline_section_z=airline#section#create_right(['%p%%', '%l/%L'])
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#show_line_numbers = 0

"" tmux-navigator settings
let g:tmux_navigator_no_mappings = 1

set mouse=a

"" deoplete settings
let g:deoplete#enable_at_startup = 1
"" disable suggestions based on local buffer
"" call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer']})

if !has('nvim')
    " M sends ^[ which is Esc, this disables M and similar keys in insert mode
    " effectively making it instant to leave insert mode, while allowing
    " remapping of alt to allow its use in windows terminal
    " this also unfortunately breaks arrow key functionality in insert mode
    set noesckeys
    set notimeout ttimeout ttimeoutlen=50

    set <M-h>=h
    set <M-j>=j
    set <M-k>=k
    set <M-l>=l
    set <M-\>=\
    "
    " enable mouse
    set ttymouse=xterm2
endif

nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>

"" source explorer settings (I think this plugin is old so I'm phasing it out)
"" nmap <F12> :SrcExplToggle<CR>
"" let g:SrcExpl_jumpKey = ""
"" let g:SrcExpl_gobackKey = ""
"" let g:SrcExpl_nextDefKey = ""
"" let g:SrcExpl_prevDefKey = ""

"" let g:SrcExpl_winHeight = 20
"" let g:SrcExpl_isUpdateTags = 0
"" let g:SrcExpl_nestedAutoCmd = 1
"" let g:SrcExpl_searchLocalDef = 0

"" let g:SrcExpl_colorSchemeList = [
""             \ "Red",
""             \ "Cyan",
""             \ "Green",
""             \ "Yellow",
""             \ "Magenta",
"" \ ]

"" NERDtree settings
nmap <F8> :NERDTreeToggle<CR>
"" open automatically on startup
"" autocmd VimEnter * NERDTree | wincmd p

"" vim-grepper settings
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

"" autopairs settings
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'
