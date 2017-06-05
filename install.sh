#!/bin/bash
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ERRORS=0
ERROR_MSG=()
HAS_GIT=0

_ERR=$(tput setaf 1)
_GOOD=$(tput setaf 2)
_WARN=$(tput setaf 3)
_NORMAL=$(tput sgr0)

function install
{
	printf $_GOOD
	local ERROR=0

	# Symbolic link to config file
	printf "Installing $1..."
	if [ ! -e ~/.$1 ]; then
		ln -s "$CONFIG_DIR/$1" ~/.$1
	fi

	# Install dependencies
	case "$1" in
		vimrc)
			mkdir -p ~/.tmp

			# Grab vundle
			if [ "$HAS_GIT" -gt 0 ]; then
				git clone --quiet https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim > /dev/null 2>&1
			else
				((ERROR++))
			fi

			# If neovim is installed, create config for it
			if hash nvim > /dev/null 2>&1; then
				NVIM_CONF_DIR=~/.config/nvim
				mkdir -p $NVIM_CONF_DIR
				ln -s "$CONFIG_DIR/$1" $NVIM_CONF_DIR/init.vim > /dev/null 2>&1
			fi
			;;
		zshrc)
			if [ "$HAS_GIT" -gt 0 ]; then
				git clone --quiet https://github.com/zsh-users/antigen ~/.antigen > /dev/null 2>&1
			else
				((ERROR++))
			fi
			;;
		*)
			printf "Not installing $1..."
			;;
	esac

	if [ "$ERROR" -gt 0 ]; then
		echo ${_ERR}error${_NORMAL}
	else
		printf "done\n"
	fi

	printf $_NORMAL
}

# Check for git
if hash git > /dev/null 2>&1; then
	HAS_GIT=1
else
	HAS_GIT=0
	ERROR_MSG[ERRORS]="Please install git"
	((ERRORS++))
fi

# Install configs
install vimrc
install zshrc

# Output any error messages
if [ $ERRORS -gt 0 ]; then
	printf $_ERR
	tput smul
	echo
	(>&2 echo "!!! $ERRORS Error(s) !!!")
	tput rmul
	(>&2 printf '* %s\n' "${ERROR_MSG[@]}")
	echo
	tput sgr0
fi

printf $_GOOD
echo "Process Complete!"
printf $_NORMAL
