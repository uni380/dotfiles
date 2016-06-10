colorscheme desert

let mapleader=","

set number
set hidden
set autoread
set gdefault

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ==============================
" Window/Tab/Split Manipulation
" ==============================

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" ============================
" Shortcuts for everyday tasks
" ============================

"Clear current search highlight by double tapping //
nmap <silent> // :nohlsearch<CR>

" Type ,hl to toggle highlighting on/off, and show current value.
noremap ,hl :set hlsearch! hlsearch?<CR>

"(v)im (r)eload
nmap <silent> ,vr :so %<CR>

" ,qc to close quickfix window (where you have stuff like Ag)
" ,qo to open it back up (rare)
nmap <silent> ,qc :cclose<CR>
nmap <silent> ,qo :copen<CR>

" Navigation
nnoremap <silent> <leader>e :b#<CR>

" easy expansion of the active file directory (from the 'Practical Vim' book)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap <expr>y "my\"" . v:register . "y`y"
