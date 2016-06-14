let mapleader=","

" vim-plug (https://github.com/junegunn/vim-plug) settings {{{
" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" ================ Plugins ==========================

call plug#begin('~/.vim/plugged')
" General
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-startify'
Plug 'tomtom/tcomment_vim'
Plug 'skwp/YankRing.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/AutoTag'

" Search
Plug 'justinmk/vim-sneak'
Plug 'rking/ag.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'Lokaltog/vim-easymotion'

" Appearance
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
Plug 'sts10/vim-mustard'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'xsunsmile/showmarks'
" Required for Gblame in terminal vim
Plug 'godlygeek/csapprox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Languages and Syntax highlighting
Plug 'vim-ruby/vim-ruby'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'ck3g/vim-change-hash-syntax'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
" Plug 'sheerun/vim-polyglot'
Plug 'ekalinin/Dockerfile.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-endwise'

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'bootleq/vim-textobj-rubysymbol'           |  Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'                  |  Plug 'kana/vim-textobj-user'
Plug 'lucapette/vim-textobj-underscore'         |  Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'           |  Plug 'kana/vim-textobj-user'
Plug 'coderifous/textobj-word-column.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'briandoll/change-inside-surroundings.vim'
call plug#end()

" }}}

" ================ Basic settings ===================

" set relativenumber
set number
set hidden
set autoread
set gdefault

" By default don't wrap lines
set nowrap

" But do wrap on these types of files...
autocmd FileType markdown setlocal wrap

" j and k don't skip over wrapped lines in following FileTypes, unless given a count (helpful since I display relative line numbers in these file types)
autocmd FileType markdown nnoremap <expr> j v:count ? 'j' : 'gj'
autocmd FileType markdown nnoremap <expr> k v:count ? 'k' : 'gk'

" if no filetype specified, set ft=markdown (alternative would be text)
autocmd BufEnter * if &filetype == "" | setlocal ft=markdown | endif

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

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

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

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

"Move back and forth through previous and next buffers
"with ,y and ,x (I'm using qwertz keyboard)
nnoremap <silent> ,y :bp<CR>
nnoremap <silent> ,x :bn<CR>

" Navigation
nnoremap <silent> <leader>e :b#<CR>

" easy expansion of the active file directory (from the 'Practical Vim' book)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap <expr>y "my\"" . v:register . "y`y"

"make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" gary bernhardt's hashrocket
imap <c-l> <space>=><space>

" These are very similar keys. Typing 'a will jump to the line in the current
" file marked with ma. However, `a will jump to the line and column marked
" with ma.  It’s more useful in any case I can imagine, but it’s located way
" off in the corner of the keyboard. The best way to handle this is just to
" swap them: http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '

"Go to last edit location with ,.
nnoremap ,. '.

" Have the indent commands re-highlight the last visual selection to make
" multiple indentations easier
vnoremap > >gv
vnoremap < <gv

" via: http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap ,w :StripTrailingWhitespaces<CR>

" ================ Appearance =======================

" Make it beautiful - colors and fonts

if has("gui_running")
  "tell the term has 256 colors
  set t_Co=256
  " set guifont=Anonymice\ Powerline,Anonymous\ Pro:h12
else
  let g:CSApprox_loaded = 1
endif

" http://johnmorales.com/blog/2015/01/09/base16-shell-tmux-vim-color-switching-dead-simple/
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" ================ Airline ==========================

let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" ================ CtrlP ============================

if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
    \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
else
  " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

" Don't jump to already open window. This is annoying if you are maintaining
" several Tab workspaces and want to open two windows into the same file.
let g:ctrlp_switch_buffer = 0

" We don't want to use Ctrl-p as the mapping because
" it interferes with YankRing (paste, then hit ctrl-p)
let g:ctrlp_map = ',t'
nnoremap <silent> ,t :CtrlP<CR>

" Additional mapping for buffer search
nnoremap <silent> ,b :CtrlPBuffer<cr>

" Cmd-Shift-P to clear the cache
nnoremap <silent> <D-P> :ClearCtrlPCache<cr>

"Cmd-Shift-(M)ethod - jump to a method (tag in current file)
"Ctrl-m is not good - it overrides behavior of Enter
nnoremap <silent> <D-M> :CtrlPBufTag<CR>

let g:ctrlp_root_markers=['.ctrlp']

" ================ Abbreviations ====================

"Abbreviations, trigger by typing the abbreviation and hitting space
abbr pry! require 'pry'; binding.pry

" ================ Startify =========================

nnoremap <silent> <leader>st :Startify<CR>

function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction
let g:startify_custom_header = s:filter_header([
  \ ' _____             _       ',
  \ '|   | |___ ___ _ _|_|_____ ',
  \ '| | | | -_| . | | | |     |',
  \ '|_|___|___|___|\_/|_|_|_|_|',
  \ '',
  \ '',
  \ ])
let g:startify_bookmarks = [
  \ {'v': '~/.config/nvim/init.vim'},
  \ {'b': '~/Dropbox/Work/inbox.txt'},
  \ {'u': '~/.uu/config/uu-client.properties'},
  \ {'y': '~/.pry_history'},
  \ {'h': '~/.hammerspoon/init.lua'},
  \ ]

" ================ Showmarks ========================

" Tell showmarks to not include the various brace marks (),{}, etc
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY"

" ================ Sneak ============================

nmap <Space> <Plug>SneakForward

" ================ Ag ===============================

" Open the Ag command and place the cursor into the quotes
nmap ,ag :Ag ""<Left>
nmap ,af :AgFile ""<Left>

" ================ AutoTag ==========================

" Seems to have problems with some vim files
let g:autotagExcludeSuffixes="tml.xml.text.txt.vim"

" ================ EasyMotion =======================

" These keys are easier to type than the default set
" We exclude semicolon because it's hard to read and
" i and l are too easy to mistake for each other slowing
" down recognition. The home keys and the immediate keys
" accessible by middle fingers are available
let g:EasyMotion_keys='asdfjkoweriop'
nmap ,<ESC> ,,w
nmap ,<S-ESC> ,,b

" ================ Fugitive =========================

" The tree buffer makes it easy to drill down through the directories of your
" git repository, but it’s not obvious how you could go up a level to the
" parent directory. Here’s a mapping of .. to the above command, but
" only for buffers containing a git blob or tree
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Every time you open a git object using fugitive it creates a new buffer.
" This means that your buffer listing can quickly become swamped with
" fugitive buffers. This prevents this from becomming an issue:

autocmd BufReadPost fugitive://* set bufhidden=delete

" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> ,dg :diffget<CR>
nnoremap <silent> ,dp :diffput<CR>

" ================ tComment =========================

" extensions for tComment plugin. Normally
" tComment maps 'gcc' to comment current line
" this adds 'gcp' comment current paragraph (block)
" using tComment's built in <c-_>p mapping
nmap <silent> gcp <c-_>p

" ================ Unimpaired =======================

" https://github.com/carlhuda/janus/blob/master/vimrc

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" ================ Indent Guides ====================

let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" ================ Surround =========================

" ,# Surround a word with #{ruby interpolation}
map ,# ysiw#
vmap ,# c#{<C-R>"}<ESC>

" ," Surround a word with "quotes"
map ," ysiw"
vmap ," c"<C-R>""<ESC>

" ,' Surround a word with 'single quotes'
map ,' ysiw'
vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>

map ,` ysiw`

" ================ SplitJoin ========================

nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" ================ YankRing =========================

let g:yankring_history_file = '.yankring-history'
nnoremap ,yr :YRShow<CR>
nnoremap C-y :YRShow<CR>
" vim:foldmethod=marker:foldenable
