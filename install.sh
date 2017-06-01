#!/bin/bash
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install
{
	printf "Installing $1..."
	ln -s "$CONFIG_DIR/$1" ~/.$1
	printf "done\n"

	if [ $1 = "vimrc" ]; then
		mkdir -p ~/.tmp
		git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	fi
}

install vimrc
install zshrc

echo "Installation Complete!"
