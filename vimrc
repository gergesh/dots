call plug#begin('~/.config/nvim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
if file_readable('/usr/share/vim/vimfiles/plugin/fzf.vim')
    Plug '/usr/share/vim/vimfiles/'
else
    Plug 'junegunn/fzf', { 'do': './install --bin' }
endif
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-sandwich'
if executable('node')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

set nocompatible
set number
set backspace=indent,eol,start
set mouse+=a
set showcmd
set nowrap
set nomodeline
set splitbelow splitright
set expandtab shiftwidth=4 tabstop=4
set autoindent
set list listchars=tab:>\ ,trail:-,nbsp:+
set synmaxcol=0

syntax on
filetype plugin indent on
colorscheme nord

" Only add closing pairs for braces, brackets and parentheses
let g:AutoPairs = {'{': '}', '(': ')', '[': ']'}

" Run xrdb automatically when editing X config files
au BufWritePost *Xresources !xrdb %

" Jump to last position when opening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g'\"" | endif

" vim-tmux-navigator keybindings
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-Left>  :TmuxNavigateLeft<cr>
inoremap <silent> <C-Left>  <C-o>:TmuxNavigateLeft<cr>
nnoremap <silent> <C-Down>  :TmuxNavigateDown<cr>
inoremap <silent> <C-Down>  <C-o>:TmuxNavigateDown<cr>
nnoremap <silent> <C-Up>    :TmuxNavigateUp<cr>
inoremap <silent> <C-Up>    <C-o>:TmuxNavigateUp<cr>
nnoremap <silent> <C-Right> :TmuxNavigateRight<cr>
inoremap <silent> <C-Right> <C-o>:TmuxNavigateRight<cr>

" Disable annoying ex mode misclick
nnoremap Q <Nop>
