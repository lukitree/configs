#!/bin/bash
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install
{
	printf "Installing $1..."
	ln -s "$CONFIG_DIR/$1" ~/.$1

	if [ $1 = "vimrc" ]; then
		mkdir -p ~/.tmp
		git clone --quiet https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim > /dev/null
	fi

	if [ $1 = "zshrc" ]; then
		git clone --quiet https://github.com/zsh-users/antigen ~/.antigen > /dev/null
	fi

	printf "done\n"
}

install vimrc
install zshrc

echo "Installation Complete!"
