CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ERROR_MESSAGES=()
WARNING_MESSAGES=()

# Terminal colors
_ERROR=$(tput setaf 1)
_GOOD=$(tput setaf 2)
_WARN=$(tput setaf 3)
_NORMAL=$(tput sgr0)

# Check system for a program
function check
{
	if hash $1 > /dev/null 2>&1; then
		echo "HAS_$1=1"
	fi
}

function sym_link
{
	if [ -z "${2}" ]; then
		LINK_LOCATION="$HOME/.$1"
	else
		LINK_LOCATION="${2}"
	fi
	SOURCE_LOCATION="$CONFIG_DIR/$1"
	if [ -f "$LINK_LOCATION" ]; then
		if [ -L "$LINK_LOCATION" ]; then
			ln -sf $SOURCE_LOCATION $LINK_LOCATION
		else
			ERROR+=("$1: Could not create symlink - $LINK_LOCATION already exists")
		fi
	else
		ln -s "$SOURCE_LOCATION" "$LINK_LOCATION"
	fi
}

function git_download
{
	eval $(check git)
	if [ "${HAS_git}" -gt 0 ]; then
		if [ -f "$2" ]; then
			git clone --quiet "${1}" "${2}" || ERROR+=("Failed to download \"$1\"")
		else
			git -C "$2" pull > /dev/null
		fi
	else
		ERROR+=("Could not find \"git\" - make sure it is in your PATH")
	fi
}

# Perform install functions for various rc files
function install
{
	printf "${_GOOD}Installing $1...${_ERROR}"

	ERROR=()
	WARN=()

	# Install dependencies
	case "$1" in
		vimrc)
			mkdir -p $HOME/.tmp
			sym_link vimrc && \
			git_download "https://github.com/VundleVim/Vundle.vim" "$HOME/.vim/bundle/Vundle.vim" && \
			($(vim -c 'PluginInstall' -c 'qa!' > /dev/null 2>&1 || WARN+=("$1: Failed to install vim plugins")))
			;;
		nvimrc)
			NVIM_CONF_DIR=$HOME/.config/nvim
			mkdir -p $NVIM_CONF_DIR
			sym_link vimrc "$NVIM_CONF_DIR/init.vim"
			;;
		zshrc)
			sym_link zshrc && \
			git_download "https://github.com/zsh-users/antigen" "$HOME/.antigen"
			;;
		gitconfig)
			mkdir -p $HOME/bin
			sym_link gitconfig && \
			sym_link "libs/git_diff_wrapper" "$HOME/bin/git_diff_wrapper"
			;;
		screenrc)
			sym_link screenrc
			;;
	esac

	if [ "${#ERROR[@]}" -gt 0 ]; then
		echo ${_ERROR}error${_GOOD}
		ERROR_MESSAGES+=("${ERROR[@]}")
	elif [ "${#WARN[@]}" -gt 0 ]; then
		echo ${_WARN}warning${_GOOD}
		WARNING_MESSAGES+=("${WARN[@]}")
	else
		echo "${_GOOD}done.${_NORMAL}"
	fi


	printf $_NORMAL
}

function display_results
{
	if [ "${#ERROR_MESSAGES[@]}" -gt 0 ]; then
		printf $_ERROR
		tput smul
		echo
		echo "!!! ${#ERROR_MESSAGES[@]} Error(s) !!!"
		tput rmul
		printf '* %s\n' "${ERROR_MESSAGES[@]}"
		echo
		tput sgr0
	fi
	
	if [ "${#WARNING_MESSAGES[@]}" -gt 0 ]; then
		printf $_WARN
		tput smul
		echo
		echo "!!! ${#WARNING_MESSAGES[@]} Warning[(s) !!!"
		tput rmul
		printf '* %s\n' "${WARNING_MESSAGES[@]}"
		echo
		tput sgr0
	fi

	printf $_GOOD
	echo "Process Complete!"
	printf $_NORMAL
}
