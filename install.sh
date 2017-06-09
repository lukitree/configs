#!/bin/bash
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CONFIGS=( vimrc zshrc screenrc gitconfig )
OTHER_FILES=("$HOME/.config/nvim/init.vim" "$HOME/bin/git_diff_wrapper")

# Terminal colors
_RED=$(tput setaf 1)
_GREEN=$(tput setaf 2)
_YELLOW=$(tput setaf 3)
_NORMAL=$(tput sgr0)

# Check system for a program
function require
{
	if ! hash $1 > /dev/null 2>&1; then
		echo "echo Please install $1. && echo && exit"
	fi
}

function sym_link
{
	if [ -z "${2}" ]; then LINK_LOCATION="$HOME/.$1"; else LINK_LOCATION="${2}"; fi
	SOURCE_LOCATION="$CONFIG_DIR/$1"
	ln -sf $SOURCE_LOCATION $LINK_LOCATION
}

function git_download
{
	if [ ! -d "$2" ]; then
		$(git clone --quiet "${1}" "${2}")
	else
		cd ${2} && git pull > /dev/null 2>&1
	fi
}

# Perform install functions for various rc files
function bootstrap
{
	printf "${_GREEN}* Installing $1...${_RED}"

	case "$1" in
		vimrc)
			mkdir -p "$HOME/.tmp"
			mkdir -p "$HOME/.vim/bundle/"
			mkdir -p "$HOME/.config/nvim"

			git_download "https://github.com/VundleVim/Vundle.vim" "$HOME/.vim/bundle/Vundle.vim"
			sym_link bootstrap/vimrc .vimrc
			printf "${_GREEN}plugins...${_RED}"
			$(vim -c 'PluginInstall' -c 'qa!' > /dev/null 2>&1)
			sym_link vimrc
			printf "${_GREEN}YCM...${RED}"
			$(cd "$HOME/.vim/bundle/YouCompleteMe" && ./install.py --clang-completer > /dev/null 2>&1)

			sym_link vimrc "$HOME/.config/nvim/init.vim"
			;;
		gitconfig)
			mkdir -p "$HOME/bin"

			sym_link gitconfig
			sym_link "libs/git_diff_wrapper" "$HOME/bin/git_diff_wrapper"
			;;
		*)
			sym_link "${1}"
			;;
	esac

	echo "${_GREEN}done.${_NORMAL}"
}

# Check for required programs
require git

# Prompt user
FILE_REPLACE_LIST=()
for i in "${CONFIGS[@]}"; do
	FILE="${HOME}/.${i}"
	if [ -f "$FILE" ] && [ ! -L "$FILE" ]; then
		FILE_REPLACE_LIST+=("${i}")
	fi
done

for i in "${OTHER_FILES[@]}"; do
	if [ -f "${i}" ] && [ ! -L "${i}" ]; then
		FILE_REPLACE_LIST+=("${i}")
	fi
done

if [ "${#FILE_REPLACE_LIST[@]}" -gt 0 ]; then
	echo "${_YELLOW}The following config files will be replaced: ${_NORMAL}"
	for i in "${FILE_REPLACE_LIST[@]}"; do
		echo "${_RED}~/.${i}${_NORMAL}"
	done
	echo
	read -p "${_YELLOW}Are you sure you want to continue? [Y/n]:${_NORMAL} " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Nn]$ ]]; then
		echo && exit
	fi
fi

# Install configs
for i in ${CONFIGS[@]}; do bootstrap "${i}"; done
printf "\n${_GREEN}Process Complete!${_NORMAL}\n\n"
