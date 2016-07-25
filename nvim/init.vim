"
" ~/config/nvim/init.vim
" vim:filetype=vim:foldmethod=marker:foldenable

" Options - Appearance {{{
" -----------------------------------------------------------------------------

set relativenumber
set number
set list listchars=tab:\ \ ,trail:·

if exists("neovim_dot_app")
  "tell the term has 256 colors
  set t_Co=256
else
  let g:CSApprox_loaded = 1
endif

" }}}
" Options - Behaviour {{{
" -----------------------------------------------------------------------------

set hidden
set autoread
set nowrap
autocmd FileType markdown setlocal wrap

" if no filetype specified, set ft=markdown (alternative would be text)
autocmd BufEnter * if &filetype == "" | setlocal ft=markdown | endif

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

" }}}
" Options - Folding {{{
" -----------------------------------------------------------------------------


" }}}
" Options - GUI {{{
" -----------------------------------------------------------------------------


" }}}
" Options - Indents and Tabs {{{
" -----------------------------------------------------------------------------

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" }}}
" Options - Searching {{{
" -----------------------------------------------------------------------------

set gdefault
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" }}}
" Mappings - General {{{
" -----------------------------------------------------------------------------

let mapleader=","

" j and k don't skip over wrapped lines in following FileTypes, unless given a count (helpful since I display relative line numbers in these file types)
autocmd FileType markdown nnoremap <expr> j v:count ? 'j' : 'gj'
autocmd FileType markdown nnoremap <expr> k v:count ? 'k' : 'gk'

" Move between split windows by using the four directions H, L, K, J
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-j> <C-w>j

" Resize windows with arrow keys
nnoremap <D-Up> <C-w>+
nnoremap <D-Down> <C-w>-
nnoremap <D-Left> <C-w><
nnoremap <D-Right>  <C-w>>

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

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
nnoremap <silent> <leader><space> :b#<CR>

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

" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
inoremap <C-e> <C-o>$

" Have the indent commands re-highlight the last visual selection to make
" multiple indentations easier
vnoremap > >gv
vnoremap < <gv

" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
noremap gV `[v`]

" Allows you to easily replace the current word and all its occurrences.
nnoremap <Leader>rw :%s/\<<C-r><C-w>\>/
vnoremap <Leader>rw y:%s/<C-r>"/

" Allows you to easily change the current word and all occurrences to something
" else. The difference between this and the previous mapping is that the mapping
" below pre-fills the current word for you to change.
nnoremap <Leader>cw :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cw y:%s/<C-r>"/<C-r>"

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

" }}}
" Mappings - Abbreviations {{{
" -----------------------------------------------------------------------------

"Abbreviations, trigger by typing the abbreviation and hitting space
abbr pry! require 'pry'; binding.pry

" }}}
" Plugins Install {{{
" -----------------------------------------------------------------------------

" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

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
Plug 'Townk/vim-autoclose'
Plug 'FooSoft/vim-argwrap'

" Search
Plug 'justinmk/vim-sneak'
Plug 'rking/ag.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'Lokaltog/vim-easymotion'
Plug 'timakro/vim-searchant'

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
Plug 'ekalinin/Dockerfile.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-endwise'
Plug 'airblade/vim-gitgutter'

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'bootleq/vim-textobj-rubysymbol'           |  Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'                  |  Plug 'kana/vim-textobj-user'
Plug 'lucapette/vim-textobj-underscore'         |  Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'           |  Plug 'kana/vim-textobj-user'
Plug 'coderifous/textobj-word-column.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'briandoll/change-inside-surroundings.vim'
Plug 'michaeljsmith/vim-indent-object'

" Code completion
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'Shougo/neco-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
call plug#end()

" }}}
" Plugin Settings - Colorscheme {{{

" XXX Don't know why but base16 dark colorschemes don't work with Neovim.app
if exists("neovim_dot_app")
  set background=dark
  let g:gruvbox_contrast_dark="hard"
  colorscheme gruvbox
else
  " http://johnmorales.com/blog/2015/01/09/base16-shell-tmux-vim-color-switching-dead-simple/
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif
endif

" }}}
" Plugin Settings - Airline {{{
" -----------------------------------------------------------------------------

let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" }}}
" Plugin Settings - CtrlP {{{
" -----------------------------------------------------------------------------

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
nnoremap <silent> <leader>t :CtrlP<CR>

" Additional mapping for buffer search
nnoremap <silent> <leader>b :CtrlPBuffer<cr>

" Cmd-Shift-P to clear the cache
nnoremap <silent> <D-P> :ClearCtrlPCache<cr>

"Cmd-Shift-(M)ethod - jump to a method (tag in current file)
"Ctrl-m is not good - it overrides behavior of Enter
nnoremap <silent> <D-M> :CtrlPBufTag<CR>
nnoremap <silent> <leader>m :CtrlPBufTag<cr>

let g:ctrlp_root_markers=['.ctrlp']

" }}}
" Plugin Settings - Startify {{{
" -----------------------------------------------------------------------------

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
  \ {'t': '~/.tmux.conf'},
  \ ]

" }}}
" Plugin Settings - Showmarks {{{
" -----------------------------------------------------------------------------

" Tell showmarks to not include the various brace marks (),{}, etc
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY"

" }}}
" Plugin Settings - Sneak {{{
" -----------------------------------------------------------------------------

nmap <Space> <Plug>SneakForward

" }}}
" Plugin Settings - Ag {{{
" -----------------------------------------------------------------------------

" Open the Ag command and place the cursor into the quotes
nmap ,ag :Ag ""<Left>
nmap ,af :AgFile ""<Left>

" }}}
" Plugin Settings - AutoTag {{{
" -----------------------------------------------------------------------------

" Seems to have problems with some vim files
let g:autotagExcludeSuffixes="tml.xml.text.txt.vim"

" }}}
" Plugin Settings - EasyMotion {{{
" -----------------------------------------------------------------------------

" These keys are easier to type than the default set
" We exclude semicolon because it's hard to read and
" i and l are too easy to mistake for each other slowing
" down recognition. The home keys and the immediate keys
" accessible by middle fingers are available
let g:EasyMotion_keys='asdfjkoweriop'
nmap ,<ESC> ,,w
nmap ,<S-ESC> ,,b

" }}}
" Plugin Settings - Fugitive {{{
" -----------------------------------------------------------------------------

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

" }}}
" Plugin Settings - tComment {{{
" -----------------------------------------------------------------------------

" extensions for tComment plugin. Normally
" tComment maps 'gcc' to comment current line
" this adds 'gcp' comment current paragraph (block)
" using tComment's built in <c-_>p mapping
nmap <silent> gcp <c-_>p

" }}}
" Plugin Settings - Unimpaired {{{
" -----------------------------------------------------------------------------

" https://github.com/carlhuda/janus/blob/master/vimrc

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" }}}
" Plugin Settings - Indent Guides {{{
" -----------------------------------------------------------------------------

let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" }}}
" Plugin Settings - Surround {{{
" -----------------------------------------------------------------------------

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

" }}}
" Plugin Settings - SplitJoin {{{
" -----------------------------------------------------------------------------

nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" }}}
" Plugin Settings - YankRing {{{
" -----------------------------------------------------------------------------

let g:yankring_history_file = '.yankring-history'
nnoremap ,yr :YRShow<CR>
nnoremap C-y :YRShow<CR>

" }}}
" Plugin Settings - Deoplete {{{
" -----------------------------------------------------------------------------

let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:deoplete#sources = {}
let g:deoplete#sources._ = ['buffer']

" }}}
" Plugin Settings - FZF {{{
" -----------------------------------------------------------------------------

nnoremap <silent> <leader>zf :Files<cr>
nnoremap <silent> <leader>zb :Buffers<cr>
nnoremap <silent> <leader>zt :BTags<cr>

" }}}
" Plugin Settings - ArgWrap {{{
" -----------------------------------------------------------------------------

nnoremap <silent> <leader>a :ArgWrap<CR>

" }}}
