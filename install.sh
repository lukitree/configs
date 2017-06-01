#!/bin/bash
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install
{
	printf "Installing $1..."
	ln -s "$CONFIG_DIR/$1" ~/.$1
	printf "done\n"
}

install vimrc
install zshrc

echo "Installation Complete!"
