#!/bin/bash
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ERRORS=()
WARNS=()

_ERR=$(tput setaf 1)
_GOOD=$(tput setaf 2)
_WARN=$(tput setaf 3)
_NORMAL=$(tput sgr0)

function check
{
	if hash $1 > /dev/null 2>&1; then
		echo "HAS_$1=1"
	fi
}

function install
{
	printf $_GOOD
	local ERROR=()
	local WARN=()

	# Create symbolic link to config file
	printf "Installing $1..."
	ln -s "$CONFIG_DIR/$1" ~/.$1 > /dev/null 2>&1 || ERROR+=("Could not create symbolic link to $1")

	# Install dependencies
	case "$1" in
		vimrc)
			mkdir -p ~/.tmp

			# Grab vundle
			if [ -z "$HAS_git" ]; then
				git clone --quiet https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim > /dev/null 2>&1 || ERROR+=("Could not download Vundle ")
			else
				WARN+=("vimrc: Could not find 'git'")
			fi

			# If neovim is installed, create config for it
			if [ -z "$HAS_nvim" ]; then
				NVIM_CONF_DIR=~/.config/nvim
				mkdir -p $NVIM_CONF_DIR
				ln -s "$CONFIG_DIR/$1" $NVIM_CONF_DIR/init.vim > /dev/null 2>&1 || ERROR+=("Could not setup symbolic link for nvim's config ")
			fi
			;;
		zshrc)
			if [ -z "$HAS_git" ]; then
				git clone --quiet https://github.com/zsh-users/antigen ~/.antigen > /dev/null 2>&1
			else
				WARN+=("zsh: Could not find 'git'")
				printf " "
			fi
			;;
	gitconfig)
			mkdir -p ~/bin
			ln -s "$CONFIG_DIR/libs/git_diff_wrapper" ~/bin/git_diff_wrapper > /dev/null 2>&1
			;;
	esac

	if [ "${#ERROR[@]}" -gt 0 ]; then
		echo ${_ERR}error${_GOOD}
		ERRORS+=("$ERROR")
	elif [ "${#WARN[@]}" -gt 0 ]; then
		echo ${_WARN}warning${_GOOD}
		WARNS+=("$WARN")
	else
		printf "done\n"
	fi


	printf $_NORMAL
}

# Check for git
eval $(check git)
eval $(check nvim)

# Install configs
install vimrc
install zshrc
install gitconfig
install screenrc

# Output any error messages
#if [ $ERRORS -gt 0 ]; then
#	printf $_ERR
#	tput smul
#	echo
#	(>&2 echo "!!! $ERRORS Error(s) !!!")
#	tput rmul
#	(>&2 printf '* %s\n' "${ERRORS[@]}")
#	echo
#	tput sgr0
#fi

if [ "${#ERRORS[@]}" -gt 0 ]; then
	printf $_ERR
	tput smul
	echo
	echo "!!! ${#ERRORS[@]} Error(s) !!!"
	tput rmul
	printf '* %s\n' "${ERRORS[@]}"
	echo
	tput sgr0
fi

if [ "${#WARNS[@]}" -gt 0 ]; then
	printf $_WARN
	tput smul
	echo
	echo "!!! ${#WARNS[@]} Warning[(s) !!!"
	tput rmul
	printf '* %s\n' "${WARNS[@]}"
	echo
	tput sgr0
fi

printf $_GOOD
echo "Process Complete!"
printf $_NORMAL
