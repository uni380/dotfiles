" -----------------------------------------------------------------------------
" Mappings - General

let mapleader=","

nnoremap <silent> <space>s :w<CR>

" j and k don't skip over wrapped lines in following FileTypes, unless given a count (helpful since I display relative line numbers in these file types)
autocmd FileType markdown nnoremap <expr> j v:count ? 'j' : 'gj'
autocmd FileType markdown nnoremap <expr> k v:count ? 'k' : 'gk'

" Move between split windows by using the four directions H, L, K, J
" nnoremap <silent> <C-h> <C-w>h
" nnoremap <silent> <C-l> <C-w>l
" nnoremap <silent> <C-k> <C-w>k
" nnoremap <silent> <C-j> <C-w>j

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

" -----------------------------------------------------------------------------
" Mappings - Abbreviations

"Abbreviations, trigger by typing the abbreviation and hitting space
abbr pry! require 'pry'; binding.pry

