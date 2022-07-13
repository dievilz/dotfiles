#######################################
## dievilz' ZINIT RUN COMMANDS FILE  ##
#######################################

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/zinit.zshrc"


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

## Path to your zinit installation.
[ -d "/opt/zinit" ] && export ZINIT="/opt/zinit"


################################### PLUGINS ####################################

### Added by Zplugin's installer
	source "$ZINIT/bin/zinit.zsh" || {
		[ -r "$ZDOTDIR/configs/default.zshrc" ] && . "$ZDOTDIR"/configs/default.zshrc || {
			[ -r "$ZDOTDIR/default.zshrc" ] && . "$ZDOTDIR"/default.zshrc
		}
		return
	}

	autoload -Uz _zinit
	(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zplugin installer's chunk

[ "$(uname -s)" = "Darwin" ] && zinit snippet OMZ::plugins/osx/osx.plugin.zsh
[ "$(uname -s)" = "Linux" ] && zinit snippet OMZ::plugins/archlinux/archlinux.plugin.zsh

zinit snippet OMZ::plugins/alias-finder/alias-finder.plugin.zsh
zinit snippet OMZ::plugins/chucknorris/chucknorris.plugin.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/colorize/colorize.plugin.zsh
zinit snippet OMZ::plugins/composer/composer.plugin.zsh
zinit snippet OMZ::plugins/extract/extract.plugin.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/git-flow-avh/git-flow-avh.plugin.zsh
zinit snippet OMZ::plugins/github/github.plugin.zsh
zinit snippet OMZ::plugins/ng/ng.plugin.zsh
zinit snippet OMZ::plugins/node/node.plugin.zsh
zinit snippet OMZ::plugins/nvm/nvm.plugin.zsh
zinit snippet OMZ::plugins/pyenv/pyenv.plugin.zsh
zinit snippet OMZ::plugins/themes/themes.plugin.zsh
zinit snippet OMZ::plugins/wd/wd.plugin.zsh
zinit snippet OMZ::plugins/z/z.plugin.zsh

zinit ice from'gh-r' as'program'; zinit light sei40kr/fast-alias-tips-bin
zinit light sei40kr/zsh-fast-alias-tips
# zinit light zdharma/fast-syntax-highlighting



################################### THEMES #####################################

[ -z $theme ] && \
theme=$(jot -w %i -r 1 1 5+1) # NumOfResults, Min, + (Max+1)

# echo "$theme"
case "$theme" \
in
	"1") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" powerlevel9k zinit
	;;
	"2") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" powerlevel10k zinit
	;;
	"3") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" spaceship zinit
	;;
	"4") [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
			. "$ZDOTDIR/scripts/themes.script.zsh" geometry zinit
	;;
	*) [ -r "$ZDOTDIR/scripts/themes.script.zsh" ] && \
		  . "$ZDOTDIR/scripts/themes.script.zsh" hyperzsh zinit
	;;
esac
unset theme


################################################################################


## Source post-rc file to finish up Zsh interactive configurations
[ -r "$ZDOTDIR/scripts/post-zshrc.script.zsh" ] && . "$ZDOTDIR/scripts/post-zshrc.script.zsh"
