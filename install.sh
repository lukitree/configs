#!/bin/bash
echo Vim Config
if [ -e "~/.vimrc" ] then
	echo "Previous Vim configuration file exists, making a backup copy."
	cp ~/.vimrc ~/.vimrc.bak
fi
cp vimrc ~/.vimrc

echo ""
echo Z-Shell Config
if [ -e "~/.zshrc" ] then
	echo "Previous Z-Shell configuration exists, making a backup copy."
	cp ~/.zshrc ~/.zshrc.bak
fi
cp zshrc ~/.zshrc

echo
echo "Done!"
