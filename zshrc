#export PROMPT="%n@%m:%c %# " 
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep notify
unsetopt extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

### Path ###
export PATH=~/bin:$PATH

### Antigen ###
#source ~HOME/.antigen/antigen.zsh

# Load the oh-my-zsh Library
#antigen use oh-my-zsh

# Bundles
#antigen bundle <bundle name>

# Theme
#antigen theme <theme name>

# Apply
#antigen apply

### Prompt ###
ZLE_RPROMPT_INDENT=0

PROMPT="%U%F{cyan}%n%f%u%F{red}@%f%U%F{magenta}%m%f%k%u %B%F{green}%~%f%b%# "

function preexec() {
	timer=${time:-$SECONDS}
}

function precmd() {
	if [ $timer ]; then
		timer_show=$(($SECONDS - $timer))
		export RPROMPT="%F{yellow}${timer_show}s%f"
		unset timer
	fi
}

### Aliases ###
alias ls="ls --color"
alias grep="grep --color"
alias ll="ls --color -l"
alias la="ls --color -a"
alias lla="ls --color -la"
alias l1="ls --color -1"
alias ccat="highlight -O ansi"
alias vi="stty stop '' -ixoff ; vi"
alias vim="stty stop '' -ixoff ; vim"
alias nvim="stty stop '' -ixoff ; nvim"
