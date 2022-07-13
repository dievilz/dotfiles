#
# $HOME/.config/bash/themes/dievilz-default.theme.bash
#

## Printing for debugging purposes
echo "Sourced: \$BASHDOTDIR/themes/dievilz-default.theme.bash"



# ----------------------- CUSTOM PROMPT WITH VCS INFO --------------------------
# Bash Prompt based on @mathiasbynens

# Shell prompt based on the Solarized Dark theme.
# Screenshot: http://i.imgur.com/EkEtphC.png
# Heavily inspired by @necolas’s prompt:
#     https://github.com/necolas/dotfiles/blob/master/shell/bash_prompt
# iTerm → Profiles → Text → use 13pt Monaco with 1.1 vertical spacing.


parse_git_state() {
	## Show different symbols as appropriate for various Git repository states
	## Compose this value via multiple conditional appends.
	local GIT_STATE=""
	local NUM_AHEAD="$(git log --oneline @{u}.. 2>/dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_AHEAD" -gt 0 ]; then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
	fi
	local NUM_BEHIND="$(git log --oneline ..@{u} 2>/dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_BEHIND" -gt 0 ]; then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
	fi
	local GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
	if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
		GIT_STATE=$GIT_STATE$GIT_SYMBOL_MERGING
	fi
	if $(git rev-parse --verify refs/stash &>/dev/null); then
		GIT_STATE=$GIT_STATE$GIT_SYMBOL_STASHED
	fi
	if ! git diff --quiet 2>/dev/null; then
		GIT_STATE=$GIT_STATE$GIT_SYMBOL_MODIFIED
	fi
	if [ -n $(git ls-files --other --exclude-standard 2>/dev/null) ]; then
		GIT_STATE=$GIT_STATE$GIT_SYMBOL_UNTRACKED
	fi
	if ! git diff --cached --quiet 2>/dev/null; then
		GIT_STATE=$GIT_STATE$GIT_SYMBOL_STAGED
	fi
	if [ -z "$(git status --porcelain)" ]; then
		GIT_STATE=
	fi
	if [ -n $GIT_STATE ]; then
		echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
	fi
}

git_info() {
	## @dievilz git info version adapted from
	## https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html &
	## https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html
	## mathiasbynens
	GIT_PROMPT_SYMBOL=$'\uE0A0' # plus/minus     - clean repo
	GIT_PROMPT_PREFIX="["
	GIT_PROMPT_SUFFIX="]"
	GIT_PROMPT_AHEAD="${C}⇡ANUM${RE}"  # A"NUM" - ahead by "NUM" commits
	GIT_PROMPT_BEHIND="${C}⇣BNUM${RE}" # B"NUM" - behind by "NUM" commits

	GIT_SYMBOL_MERGING="⚡︎"  # lightning bolt - merge conflict
	GIT_SYMBOL_MODIFIED="!"  # yellow circle - modified files
	GIT_SYMBOL_UNTRACKED="?" # orange circle - untracked files
	GIT_SYMBOL_STAGED="✔"    # green  circle - staged changes present = ready for "git push"
	GIT_SYMBOL_STASHED="$"   # green  circle - stashed files

	## Exit if not inside a Git repository
	! git rev-parse --is-inside-work-tree >/dev/null 2>&1 && return

	## Git branch/tag, or name-rev if on detached head
	local GIT_LOCATION="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || \
		git rev-parse --short HEAD 2>/dev/null || \
		echo '(unknown)')"

	## If inside a Git repository, print its branch and state
	[ -n "$GIT_LOCATION" ] && echo " $GIT_PROMPT_SYMBOL $GIT_LOCATION $(parse_git_state) "
}

__promptchar_exitcode() {
	if $(echo ${PIPESTATUS[@]} | grep -qEe '^0( 0)*$');
	then
		printf "\033[38;5;040m\033[0m"
	else
		printf "\033[38;5;196m↵ $(echo ${?##0})\033[0m"
	fi
}

# Bash shell executes the content of the PROMPT_COMMAND just before displaying the PS1 variable.
# PROMPT_COMMAND=

### PS1 Default interaction prompt
PS1="\[\033]0;\w\007\]" ## Set the terminal title to the current working directory
PS1+="\n"
PS1+="\[\033[34m\]\w \[\033[0m\]\n"
PS1+="\[\033[38;5;61m\]\u@\h\[\033[0m\] \[\033[0;33m\]\$(git_info)\[\033[0m\] \$(__promptchar_exitcode)\n"
PS1+='\$ \[\033[0m\]'

### PS2 Multiline/continuation interactive prompt
PS2="\[${RE}\]→ \[${RE}\]"

### PS4 Debug mode interactive prompt
fileToDebug="$(basename "$0")"
PS4='${fileToDebug}.$LINENO+ '
unset fileToDebug
