#!/bin/zsh
#
# $ZDOTDIR/scripts/zle.script.zsh  OR  ~/.zle.script.zsh
#
# Zsh Line Editor and Line Buffer Source Manager for syntax hiliting, auto-suggestions, history-search, etc.

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/scripts/zle.script.zsh"

## echo $ZSH_LOCAL
## echo $ZSH_PLUGIN_DIR


zshSourcingProjects() \
{
# =========== AUTOSUGGESTION ==========================================================================================================

	if [ -z $AUTOSUGGESTION_ENABLED ]; then
		case "$AUTOSUGGESTION" in
			"zsh-users")
				if [ -r "$ZSH_PLUGIN_DIR"/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ];
				then
					ausgDir="$ZSH_PLUGIN_DIR"
				elif [ -r "$ZSH_LOCAL"/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ];
				then
					ausgDir="$ZSH_LOCAL"
				fi

				if [ -n "$ausgDir" ]; then
					. "$ausgDir"/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ||
					. "$ausgDir"/zsh-autosuggestions/zsh-autosuggestions.zsh

					export AUTOSUGGESTION_ENABLED=true
				else
					export AUTOSUGGESTION_ENABLED=false
				fi
			;;
		esac

		zshProjectAdjustments_Autosuggest
		unset ausgDir
	fi

# =========== HISTORY SEARCH ==========================================================================================================

	if [ -z $HISTORY_SEARCH_ENABLED ]; then
		case "$HISTORY_SEARCH" in
			"zdharma")
				if [ -r "$ZSH_PLUGIN_DIR"/history-search-multi-word/history-search-multi-word.plugin.zsh ];
				then
					hssrDir="$ZSH_PLUGIN_DIR"
				elif [ -r "$ZSH_PLUGIN_DIR"/history-search-multi-word/history-search-multi-word.plugin.zsh ];
				then
					hssrDir="$ZSH_LOCAL"
				fi

				if [ -n "$hssrDir" ]; then
					. "$hssrDir"/history-search-multi-word/history-search-multi-word.plugin.zsh ||
					. "$hssrDir"/history-search-multi-word/history-search-multi-word.zsh

					export HISTORY_SEARCH_ENABLED=true
				else
					export HISTORY_SEARCH_ENABLED=false
				fi
			;;
			"zsh-users")
				if [ -r "$ZSH_PLUGIN_DIR"/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh ];
				then
					hssrDir="$ZSH_PLUGIN_DIR"
				elif [ -r "$ZSH_LOCAL"/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh ];
				then
					hssrDir="$ZSH_LOCAL"
				fi

				if [ -n "$hssrDir" ]; then
					. "$hssrDir"/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh ||
					. "$hssrDir"/zsh-history-substring-search/zsh-history-substring-search.zsh

					export HISTORY_SEARCH_ENABLED=true
				else
					export HISTORY_SEARCH_ENABLED=false
				fi
			;;
		esac

		zshProjectAdjustments_History
		unset hssrDir
	fi

# ============ SYNTAX_HILITE ===========================================================================================================

	if [ -z $SYNTAX_HILITE_ENABLED ]; then
		case "$SYNTAX_HILITE" in
			"zdharma")
				if [ -r "$ZSH_PLUGIN_DIR"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ];
				then
					syhgDir="$ZSH_PLUGIN_DIR"
				elif [ -r "$ZSH_LOCAL"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ];
				then
					syhgDir="$ZSH_LOCAL"
				fi

				if [ -n "$syhgDir" ]; then
					. "$syhgDir"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ||
					. "$syhgDir"/fast-syntax-highlighting/fast-syntax-highlighting.zsh

					export SYNTAX_HILITE_ENABLED=true
				else
					export SYNTAX_HILITE_ENABLED=false
				fi
			;;
			"zsh-users")
				if [ -r "$ZSH_PLUGIN_DIR"/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ];
				then
					syhgDir="$ZSH_PLUGIN_DIR"
				elif [ -r "$ZSH_LOCAL"/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ];
				then
					syhgDir="$ZSH_LOCAL"
				fi

				if [ -n "$syhgDir" ]; then
					. "$syhgDir"/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ||
					. "$syhgDir"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

					export SYNTAX_HILITE_ENABLED=true
				else
					export SYNTAX_HILITE_ENABLED=false
				fi
			;;
		esac

		zshProjectAdjustments_SyntaxHilite
		unset syhgDir
	fi
}

zshProjectAdjustments_Autosuggest() \
{
	if [ "$AUTOSUGGESTION_ENABLED" = true ];
	then
		## Enable asynchronous fetching of suggestions.
		ZSH_AUTOSUGGEST_USE_ASYNC=1
		## For some reason, the offered completion winds up having the same color as
		## the terminal background color (when using a dark profile). Therefore, we
		## switch to gray.
		## See https://github.com/zsh-users/zsh-autosuggestions/issues/182.
		# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=gray'
		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=238'
	fi
}

zshProjectAdjustments_History() \
{
	if [ "$HISTORY_SEARCH" = "zsh-users" ] && [ "$HISTORY_SEARCH_ENABLED" = true ];
	then
		zmodload zsh/terminfo # bind UP and DOWN arrow keys to history substring search

		bindkey '^[[A' history-substring-search-up
		bindkey '^[[B' history-substring-search-down
		bindkey "${terminfo[kcuu1]}" history-substring-search-up
		bindkey "${terminfo[kcud1]}" history-substring-search-down

		bindkey -M emacs '^P' history-substring-search-up
		bindkey -M emacs '^N' history-substring-search-down

		bindkey -M vicmd 'k' history-substring-search-up
		bindkey -M vicmd 'j' history-substring-search-down
	fi
}

zshProjectAdjustments_SyntaxHilite() \
{
	if [ "$SYNTAX_HILITE" = "zsh-users" ] && [ "$SYNTAX_HILITE_ENABLED" = true ];
	then
		ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
		ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
		typeset -A ZSH_HIGHLIGHT_STYLES
		ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
		ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=cyan'
		ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
		ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
		ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
		ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
		ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
		ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
		ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
		ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
		ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
	fi
}

main_zlescript() \
{
	AUTOSUGGESTION="$2"
	HISTORY_SEARCH="$3"
	SYNTAX_HILITE="$1"
	# echo "$AUTOSUGGESTION"
	# echo "$HISTORY_SEARCH"
	# echo "$SYNTAX_HILITE"

	alias zleVars='
printf "\033[38;35mIs Autosuggestions Enabled?:\033[0m %s\n" "$AUTOSUGGESTION_ENABLED";
printf "\033[38;35mAutosuggestions plugin:     \033[0m %s\n" "$AUTOSUGGESTION";
printf "\033[38;35mIs History Search Enabled?: \033[0m %s\n" "$HISTORY_SEARCH_ENABLED";
printf "\033[38;35mHistory Search plugin:      \033[0m %s\n" "$HISTORY_SEARCH";
printf "\033[38;35mIs Syntax Hilite Enabled?:  \033[0m %s\n" "$SYNTAX_HILITE_ENABLED";
printf "\033[38;35mSyntax Hilite plugin:       \033[0m %s\n" "$SYNTAX_HILITE";
echo'

	zshSourcingProjects
}

main_zlescript "$@"; return
