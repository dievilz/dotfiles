######################################
## dievilz' ZGEN RUN COMMANDS FILE  ##
######################################

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/zgen.zshrc"


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

## Path to your zgen installation.
[ -d "/opt/zgen" ] && export ZGEN="/opt/zgen"


################################### PLUGINS ####################################

## load zgen
source "$ZGEN/zgen.zsh" || {
	[ -r "$ZDOTDIR/configs/default.zshrc" ] && . "$ZDOTDIR"/configs/default.zshrc || {
		[ -r "$ZDOTDIR/default.zshrc" ] && . "$ZDOTDIR"/default.zshrc
	}
	return
}

## if the init scipt doesn't exist
if ! zgen saved;
then
	# echo "Creating a zgen save"

	zgen oh-my-zsh

	[ "$(uname -s)" = "Darwin" ] && zgen oh-my-zsh plugins/osx
	[ "$(uname -s)" = "Linux" ] && zgen oh-my-zsh plugins/archlinux

	zgen oh-my-zsh plugins/alias-finder
	zgen oh-my-zsh plugins/chucknorris
	zgen oh-my-zsh plugins/colored-man-pages
	zgen oh-my-zsh plugins/colorize
	zgen oh-my-zsh plugins/composer
	zgen oh-my-zsh plugins/extract
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/git-flow-avh
	zgen oh-my-zsh plugins/github
	zgen oh-my-zsh plugins/ng
	zgen oh-my-zsh plugins/node
	zgen oh-my-zsh plugins/nvm
	zgen oh-my-zsh plugins/pyenv
	zgen oh-my-zsh plugins/themes
	zgen oh-my-zsh plugins/wd
	zgen oh-my-zsh plugins/z

	zgen load sei40kr/fast-alias-tips-bin
	zgen load sei40kr/zsh-fast-alias-tips
	# zgen load zdharma/fast-syntax-highlighting



	############################### THEMES #####################################

	[ -z $theme ] && \
	theme=$(jot -w %i -r 1 1 5+1) # NumOfResults, Min, + (Max+1)

	# echo "$theme"
	case "$theme" \
	in
		"1") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
				. "$ZDOTDIR/scripts/themes.script.zsh" powerlevel9k zgen
		;;
		"2") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
				. "$ZDOTDIR/scripts/themes.script.zsh" powerlevel10k zgen
		;;
		"3") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
				. "$ZDOTDIR/scripts/themes.script.zsh" spaceship zgen
		;;
		"4") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
				. "$ZDOTDIR/scripts/themes.script.zsh" geometry zgen
		;;
		*) [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			  . "$ZDOTDIR/scripts/themes.script.zsh" hyperzsh zgen
		;;
	esac
	unset theme

	# ==========================================================================

#     ## bulk load
#     zgen loadall <<EOPLUGINS
#         zsh-users/zsh-history-substring-search
#         /path/to/local/plugin
# EOPLUGINS
#     ## ^ can't indent this EOPLUGINS

    ## completions
    # zgen load zsh-users/zsh-completions src

    ## save all to init script
    zgen save
fi


################################################################################


## Source post-rc file to finish up Zsh interactive configurations
[ -r "$ZDOTDIR/scripts/post-zshrc.script.zsh" ] && . "$ZDOTDIR/scripts/post-zshrc.script.zsh"
