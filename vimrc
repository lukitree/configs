" VUNDLE
set nocompatible
filetype plugin indent off
syntax off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
"Let Vundle manage vundle
Plugin 'VundleVim/Vundle.vim'

"Plugin List
" to install a plugin add it here and run :PluginInstall.
" to update the plugins run :PluginInstall! or :PluginUpdate
" to delete a plugin remove it here and run :PluginClean

Plugin 'universal-ctags/ctags'
Plugin 'majutsushi/tagbar'
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'

call vundle#end()

" Vim settings
behave mswin
filetype plugin indent on
syntax on
set encoding=utf-8
set relativenumber
set number
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4

" Fold Settings
set foldmethod=syntax
set foldlevelstart=20

" Hotkeys
let mapleader = ","
nmap <F1>			:NERDTreeToggle<CR>
nmap <F2>			:TagbarToggle<CR>
nmap <F5>			:!make run<CR>
nmap <F6>			:!make<CR>
nmap <F7>			:!make clean<CR>

nmap <leader>,		:bprev<CR>
nmap <leader>.		:bnext<CR>

nmap <C-s>			:w<CR>
nmap <C-S-s>		:wa<CR>

" YouCompleMe
let g:ycm_confirm_extra_conf = 0

"temp files
set directory=$HOME/.tmp//
set backupdir=$HOME/.tmp//
set undodir=$HOME/.tmp//

" ## AESTHETICS ##
if has("gui_running")
	set guifont=DejaVu_Sans_Mono_for_Powerline:h14:cANSI
	set background=light

	set guioptions-=T
else
	set background=dark
endif

" Solarized Color Scheme
colorscheme solarized

" Vim Airline Plugin
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = "solarized"
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#fnamemod = ':t'
