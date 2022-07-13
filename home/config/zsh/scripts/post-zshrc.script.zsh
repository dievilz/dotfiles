#!/bin/zsh
#
# $ZDOTDIR/scripts/post-zshrc.script.zsh  OR  ~/.post-zshrc.script.zsh
#
# Final script to configure an interactive session for Zsh.

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/scripts/post-zshrc.script.zsh"


################################# KEYBINDINGS ##################################



############################# LAST CONFIGURATIONS ##############################

if [ -z $CUSTOM_PLUGINS_LOADED ]; then
	## My custom settings for POSIX  3rd Party plugins/Custom plugins
	while IFS= read -r -d '' shllplugn;
	do
		[ -r "$shllplugn" ] && . "$shllplugn"
	done \
	< <(find "${SHELL_HOME:-$HOME/.config/shell}/plugins" \
		-name "*.plugin.sh" -type f -print0 2> /dev/null)
	unset shllplugn
fi
unset CUSTOM_PLUGINS_LOADED


## Set keyboard layout for Non-Darwin (macOS) systems.
if [ "$(uname -s)" != "Darwin" ];
then
	case "$(id -un)" \
	in
		0) if command -v loadkeys > /dev/null 2>&1; then loadkeys es; fi ;;
		*) if command -v setxkbmap > /dev/null 2>&1; then setxkbmap -layout es; fi ;;
	esac
fi


## Composer at last because, y'know, PHP...  *yuck* xD
# [ -s "$HOME"/Dev/Repos/php-version/php-version.sh ] \
# && . "$HOME"/Dev/Repos/php-version/php-version.sh


# php-version 7
# nvm alias default 12.14.1 >/dev/null
# # pyenv shell 3.8.1
# chruby 2.7.0



##################### SYNTAX HIGHLIGHTING; Should be last ######################

[ -r "${ZDOTDIR:-$HOME/.config/zsh}/scripts/zle.script.zsh" ] \
&& . "${ZDOTDIR:-$HOME/.config/zsh}/scripts/zle.script.zsh" zdharma zsh-users zsh-users



################################# END OF FILE ##################################

## Load the shell dotfiles:
for homefile in "$HOME"/.{aliases,functions};
do
	[ -r "$homefile" ] && . "$homefile"
done
unset homefile


## Remove PATH duplicated entries
# PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
