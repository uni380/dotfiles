" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" TODO K pluginum specifickym pro Neovim (napr. Deoplete) najit alternativu pro Vim

call plug#begin('~/.vim/plugged')
" General
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
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-scripts/ReplaceWithRegister'

" Search
" Plug 'justinmk/vim-sneak'
Plug 'rking/ag.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'Lokaltog/vim-easymotion'
Plug 'timakro/vim-searchant'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'rizzatti/dash.vim'

" Appearance
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'
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
Plug 'janko-m/vim-test'
Plug 'junegunn/gv.vim'

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'bootleq/vim-textobj-rubysymbol'           |  Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'                  |  Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'           |  Plug 'kana/vim-textobj-user'
Plug 'coderifous/textobj-word-column.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'
Plug 'AndrewRadev/dsf.vim'

" Code completion
if has('nvim')
  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction
  Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
else
  Plug 'Shougo/neocomplete.nvim'
end
Plug 'Shougo/neco-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()
