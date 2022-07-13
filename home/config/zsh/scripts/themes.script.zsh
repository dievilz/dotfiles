#!/bin/zsh
#
# $ZDOTDIR/scripts/themes.script.zsh  OR  ~/.themes.script.zsh
#
# @dievilz's script for sourcing themes for Zsh.

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/scripts/themes.script.zsh"


set_pwrlvl9k_zshtheme() \
{
	case "$1" in
		"omz") ZSH_THEME="powerlevel9k/powerlevel9k"
		;;
		"zgen") zgen load powerlevel9k/powerlevel9k
		;;
		"zinit") zinit ice depth=1; zinit light powerlevel9k/powerlevel9k
		;;
		"zplug") zplug "powerlevel9k/powerlevel9k", use:powerlevel9k.zsh-theme
		;;
		*) printf "%b\n" "\033[38;31mError: plugin manager not found!"; return 126
		;;
	esac

	if [ -z $PWRLVL ];
	then
		PWRLVL=$(jot -w %i -r 1 1 3+1)
		PWRLVL=3
	fi
	# echo "$PWRLVL"
	case "$PWRLVL" in
		"1") . "${ZDOTDIR:-$HOME/.config/zsh}/themes/pl9k/default.pl9k.zsh"
		;;
		"2") . "${ZDOTDIR:-$HOME/.config/zsh}/themes/pl9k/dievilz-original.pl9k.zsh"
		;;
		"3") . "${ZDOTDIR:-$HOME/.config/zsh}/themes/pl9k/dievilz.pl9k.zsh"
		;;
		"4") . "${ZDOTDIR:-$HOME/.config/zsh}/themes/pl9k/mavam.pl9k.zsh"
		;;
	esac
	unset PWRLVL
}

set_pwrlvl10k_zshtheme() \
{
	case "$1" in
		"omz") ZSH_THEME="powerlevel10k/powerlevel10k"
		;;
		"zgen") zgen load romkatv/powerlevel10k
		;;
		"zinit") zinit ice depth=1; zinit light romkatv/powerlevel10k
		;;
		"zplug") zplug "romkatv/powerlevel10k", use:powerlevel10k.zsh-theme
		;;
		*) printf "%b\n" "\033[38;31mError: plugin manager not found!"; return 126
		;;
	esac

	if [ -z $PWRLVL ];
	then
		PWRLVL=$(jot -w %i -r 1 1 1+1)
		PWRLVL=2
	fi
	# echo "$PWRLVL"
	case "$PWRLVL" in
		"1") . "${ZDOTDIR:-$HOME/.config/zsh}/themes/p10k/default.p10k.zsh"
		;;
		"2") . "${ZDOTDIR:-$HOME/.config/zsh}/themes/p10k/dievilz.p10k.zsh"
		;;
	esac
	unset PWRLVL
}

set_spaceship_zshtheme() \
{
	case "$1" in
		"omz") ZSH_THEME="spaceship/spaceship"
		;;
		"zgen") zgen load spaceship/spaceship
		;;
		"zinit") zinit ice depth=1; zinit light spaceship/spaceship
		;;
		"zplug") zplug "spaceship/spaceship", use:spaceship.zsh-theme
		;;
		*) printf "%b\n" "\033[38;31mError: plugin manager not found!"; return 126
		;;
	esac
}

set_geometry_zshtheme() \
{
	case "$1" in
		"omz") ZSH_THEME="geometry/geometry"
		;;
		"zgen") zgen load geometry/geometry
		;;
		"zinit") zinit ice depth=1; zinit light geometry/geometry
		;;
		"zplug") zplug "geometry/geometry", use:geometry.zsh-theme
		;;
		*) printf "%b\n" "\033[38;31mError: plugin manager not found!"; return 126
		;;
	esac
}

set_hyperzsh_zshtheme() \
{
	case "$1" in
		"omz") ZSH_THEME="hyperzsh/hyperzsh"
		;;
		"zgen") zgen load hyperzsh/hyperzsh
		;;
		"zinit") zinit ice depth=1; zinit light hyperzsh/hyperzsh
		;;
		"zplug") zplug "hyperzsh/hyperzsh", use:hyperzsh.zsh-theme
		;;
		*) printf "%b\n" "\033[38;31mError: plugin manager not found!"; return 126
		;;
	esac
}

# ------------------------------------------------------------------------------

usage_zshthemes() {
	echo
	echo "Zsh Theme Sourcing Script"
	printf "SYNOPSIS: ./%s [options][-h]\n" "$(basename "$0")"
	cat <<-'EOF'

	OPTIONS:
	    pl9k,
	    pl9k,
	    powerlevel9k    Source theme Powerlevel9k by @bhilburn
	    pl10k,
	    pwrlvl10k,
	    powerlevel10k   Source theme Powerlevel9k by @romkatv
	    space,
	    spaceship       Source theme Spaceship by @
	    geo,
	    geometry        Source theme Geometry by @
	    hyper,
	    hyperzsh        Source theme Hyperzsh by @

	    -h,--help       Show this menu

	EOF
}

main_zshthemes() {
	case $1 in
		"-h"|"--help")
			usage_zshthemes
			return 0
		;;
		"pl9k"|"pwrlvl9k"|"powerlevel9k")
			if [ "$3" = "random" ];
			then
				set_pwrlvl9k_zshtheme "$2" "random"
			else
				set_pwrlvl9k_zshtheme "$2"
			fi
		;;
		"pl10k"|"pwrlvl10k"|"powerlevel10k")
			if [ "$3" = "random" ];
			then
				set_pwrlvl10k_zshtheme "$2" "random"
			else
				set_pwrlvl10k_zshtheme "$2"
			fi
		;;
		"space"|"spaceship")
			if [ "$3" = "random" ];
			then
				set_spaceship_zshtheme "$2" "random"
			else
				set_spaceship_zshtheme "$2"
			fi
		;;
		"geo"|"geometry")
			if [ "$3" = "random" ];
			then
				set_geometry_zshtheme "$2" "random"
			else
				set_geometry_zshtheme "$2"
			fi
		;;
		"hyper"|"hyperzsh")
			if [ "$3" = "random" ];
			then
				set_hyperzsh_zshtheme "$2" "random"
			else
				set_hyperzsh_zshtheme "$2"
			fi
		;;
		*)
			usage_zshthemes
			return 127
		;;
	esac
}

main_zshthemes "$@"
