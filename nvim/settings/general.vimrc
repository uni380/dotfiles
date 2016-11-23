" -----------------------------------------------------------------------------
" Options - Appearance

" set relativenumber
set number
set list listchars=tab:\ \ ,trail:·

if exists("neovim_dot_app")
  "tell the term has 256 colors
  set t_Co=256
elseif has("nvim")
  set termguicolors
else
  let g:CSApprox_loaded = 1
endif

" colorscheme is configured in plugins.vimrc

" -----------------------------------------------------------------------------
" Options - Behaviour

autocmd BufRead * filetype detect

set hidden
set autoread
set nowrap
autocmd FileType markdown setlocal wrap

" if no filetype specified, set ft=markdown (alternative would be text)
autocmd BufEnter * if &filetype == "" | setlocal ft=markdown | endif

autocmd BufRead,BufNewFile *.bork set filetype=sh

if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

set noswapfile
set nobackup
set nowb

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

set splitbelow
set splitright

" FIXME The following condition does not work in terminal NeoVim (VimR is OK)
" if has('nvim')
"   set inccommand=nosplit
" endif

" -----------------------------------------------------------------------------
" Options - Indents and Tabs

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" -----------------------------------------------------------------------------
" Options - Searching

set gdefault
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

