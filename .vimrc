"General
"-------
syntax on
set background=dark
set hlsearch
set number
set numberwidth=5
set ts=4
set expandtab
set tabstop=4
set autoindent
let base16colorspace=256

set nocompatible
filetype off

"Enable Vundle
"-------------
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

"Vundle Plugins
"--------------
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'chriskempson/base16-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'gilligan/vim-lldb'

"Vundle Cleanup
"--------------
call vundle#end()
filetype plugin indent on
set laststatus=2
set ttimeoutlen=50
let g:airline_powerline_fonts=1

let g:EditorConfig_core_mode = 'external_command'

"Color
"-----
colorscheme base16-eighties

