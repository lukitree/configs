#!/bin/bash
function install
{
	echo "Installing .$1"
	if [ -e ~/.$1 ]; then
		echo "Previous $1 configuration file exists, making a backup copy."
		cp ~/.$1 ~/.$1.bak
	fi
	cp $1 ~/.$1
}

install vimrc
install zshrc

echo
echo "Done!"
