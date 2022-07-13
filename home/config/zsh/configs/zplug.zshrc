#######################################
## dievilz' ZPLUG RUN COMMANDS FILE  ##
#######################################

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/zplug.zshrc"


## If the session is non-login interactive, /etc/zprofile will not be sourced,
## only this file will be. We need to source it if we are in macOS because
## we need our env vars initialized.
if [ "$(uname -s)" = "Darwin" ];
then
	if [[ ! -o login ]];
	then
		[ -r "${ZDOTDIR:-$HOME/.config/zsh}/.zprofile" ] \
		&& . "${ZDOTDIR:-$HOME/.config/zsh}/.zprofile"
	fi
fi

## Path to your zplug installation.
[ -d "/opt/zplug" ] && export ZPLUG_HOME="/opt/zplug"


################################### PLUGINS ####################################

## load zplug
source "$ZPLUG_HOME/init.zsh" || {
	[ -r "$ZDOTDIR/configs/default.zshrc" ] && . "$ZDOTDIR"/configs/default.zshrc || {
		[ -r "$ZDOTDIR/default.zshrc" ] && . "$ZDOTDIR"/default.zshrc
	}
	return
}

# zplug 'zplug/zplug', hook-build:'zplug --self-manage'

[ "$(uname -s)" = "Darwin" ] && zplug "plugins/osx",      from:oh-my-zsh
[ "$(uname -s)" = "Linux" ] && zplug "plugins/archlinux", from:oh-my-zsh

zplug "plugins/alias-finder",      from:oh-my-zsh
zplug "plugins/chucknorris",       from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize",          from:oh-my-zsh
zplug "plugins/composer",          from:oh-my-zsh, if:"which composer"
zplug "plugins/extract",           from:oh-my-zsh
zplug "plugins/git",               from:oh-my-zsh, if:"which git"
zplug "plugins/git-flow-avh",      from:oh-my-zsh, if:"which git-flow-avh"
zplug "plugins/github",            from:oh-my-zsh
zplug "plugins/ng",                from:oh-my-zsh
zplug "plugins/node",              from:oh-my-zsh, if:"which node"
zplug "plugins/nvm",               from:oh-my-zsh
zplug "plugins/pyenv",             from:oh-my-zsh
zplug "plugins/themes",            from:oh-my-zsh
zplug "plugins/wd",                from:oh-my-zsh
zplug "plugins/z",                 from:oh-my-zsh

zplug "sei40kr/fast-alias-tips-bin",from:gh-r, as:command,rename-to:def-matcher
zplug "sei40kr/zsh-fast-alias-tips"
# zplug "zdharma/fast-syntax-highlighting", defer:2



################################### THEMES #####################################

[ -z $theme ] && \
theme=$(jot -w %i -r 1 1 5+1) # NumOfResults, Min, + (Max+1)

# echo "$theme"
case "$theme" \
in
	"1") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" powerlevel9k zplug
	;;
	"2") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" powerlevel10k zplug
	;;
	"3") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" spaceship zplug
	;;
	"4") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" geometry zplug
	;;
	*) [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
		  . "$ZDOTDIR/scripts/themes.script.zsh" hyperzsh zplug
	;;
esac
unset theme


if ! zplug check --verbose;
then
	printf "Install? [y/N]: "
	if read -q;
	then
		echo; zplug install
	fi
fi

## zplug load --verbose
zplug load


################################################################################


## Source post-rc file to finish up Zsh interactive configurations
[ -r "$ZDOTDIR/scripts/post-zshrc.script.zsh" ] && . "$ZDOTDIR/scripts/post-zshrc.script.zsh"
