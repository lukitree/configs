autocmd!

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
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'othree/csscomplete.vim'
Plugin 'shawncplus/phpcomplete.vim'

call vundle#end()

" Vim Settings
behave mswin
filetype plugin indent on
syntax on
set encoding=utf-8
set relativenumber
set number
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4
set backspace=indent,eol,start
set spelllang=en_us

"Folding
set foldmethod=syntax
set foldlevelstart=20

" Shortcuts
"Leader
let mapleader = ","
nmap <F1>			:NERDTreeToggle<CR>
nmap <F2>			:TagbarToggle<CR>
nmap <F5>			:!make run<CR>
nmap <F6>			:!make<CR>
nmap <F7>			:!make clean<CR>

"Buffer
nmap <leader>,		:bprev<CR>
nmap <leader>.		:bnext<CR>
nmap <leader>/		:noh<CR>

"Quick Exit
nmap <leader>wq		:wqa<CR>
nmap <leader>qq		:qa<CR>

"Ctrl + S Saving
nmap <C-s>			:w<CR>
imap <C-s>			<C-o>:w<CR>
nmap <C-S-s>		:wa<CR>
imap <C-S-s>		<C-o>:wa<CR>

" YouCompleteMe (Plugin)
let g:ycm_confirm_extra_conf = 0

" Temporary file locations
set directory=$HOME/.tmp//
set backupdir=$HOME/.tmp//
set undodir=$HOME/.tmp//

" AESTHETICS
if has("gui_running")
	set guifont=DejaVu_Sans_Mono_for_Powerline:h12:cANSI
	set background=light

	set guioptions-=T
	set guioptions-=L
else
	set background=dark
endif

" Solarized Color Scheme
colorscheme solarized

" Tagbar
let g:tagbar_ctags_bin="~/.vim/ext/ctags/ctags.exe"
autocmd VimEnter * nested :call tagbar#autoopen(1)

" Vim Airline Plugin
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = "solarized"
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#fnamemod = ':t'

" Table Mode
let table_mode_corner = '|'

" Markdown Files
autocmd FileType markdown setlocal spell

" CSS Files
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
