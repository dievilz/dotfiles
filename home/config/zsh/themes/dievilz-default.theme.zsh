#
# $ZDOTDIR/themes/dievilz-default.theme.zsh
#

## Printing for debugging purposes
echo "Sourced: \$ZDOTDIR/themes/dievilz-default.theme.zsh"


######################### GIT PROMPT DOESN'T WORK!!!!! #########################

# ----------------------- CUSTOM PROMPT WITH VCS INFO --------------------------
## Latest version adapted from: https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html
## (https://github.com/joshdick/dotfiles/blob/main/zshrc.symlink)
## -------------------------------
## First version adapted from 2019 Manjaro skeleton zshrc:
## (https://github.com/Chrysostomus/manjaro-zsh-config/blob/ebbc9d700d9e94e9d4423fdfe67cc634fb025538/.zshrc)
## which it adapted from:
## https://joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
## (https://github.com/joshdick/dotfiles/blob/5965dd5113e47e20e78ea022cbd0014e6e8e036e/zshrc.symlink)
## which it adapted from:
## https://gist.github.com/mislav/1712320


## Enable substitution for prompt
setopt PROMPT_SUBST

## Modify the colors and symbols in these variables as desired.
GIT_PROMPT_AHEAD="%{$fg[cyan]%}⇡ANUM%{$reset_color%}"   # ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}⇣BNUM%{$reset_color%}"  # behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"  # merge conflict
GIT_PROMPT_STASHED="%{$fg[yellow]%}$%{$reset_color%}"   # stashed files
GIT_PROMPT_MODIFIED="%{$fg[yellow]%}!%{$reset_color%}"  # modified files
GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?%{$reset_color%}" # untracked files
GIT_PROMPT_STAGED="%{$fg[green]%} ✔%{$reset_color%}"    # staged changes present = ready for "git push"

## Git branch/tag, or name-rev if on detached head
parse_git_branch() {
	## Exit if not inside a Git repository
	! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

	GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}
}

## Show different symbols as appropriate for various Git repository states
parse_git_state() {
	local -a DIVERGENCES
	local -a FLAGS

	local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_AHEAD" -gt 0 ];
	then
		DIVERGENCES+=( "${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}" )
	fi

	local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_BEHIND" -gt 0 ];
	then
		DIVERGENCES+=( "${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}" )
	fi

	local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
	if [ -n "$GIT_DIR" ] && test -r "$GIT_DIR"/MERGE_HEAD;
	then
		FLAGS+=( "$GIT_PROMPT_MERGING" )
	fi

	if git rev-parse --verify refs/stash &>/dev/null;
	then
		FLAGS+=( "$GIT_PROMPT_STASHED" )
	fi

	if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]];
	then
		FLAGS+=( "$GIT_PROMPT_UNTRACKED" )
	fi

	if ! git diff --quiet 2> /dev/null;
	then
		FLAGS+=( "$GIT_PROMPT_MODIFIED" )
	fi

	if ! git diff --cached --quiet 2> /dev/null;
	then
		FLAGS+=( "$GIT_PROMPT_STAGED" )
	fi
}

## Echoes information about Git repository status when inside a Git repository
git_info() {
	parse_git_branch
	[ -n "$GIT_LOCATION" ] && echo " ±$(parse_git_state)%{$fg[white]%}[$GIT_LOCATION] "
}

################################################################################

######################### GIT PROMPT DOESN'T WORK!!!!! #########################



# ### PROMPT Default interaction prompt
# PROMPT='
# %F{blue}%~%f
# %F{061}%n@%m%f
# %(?.%F{040}%#%f.%F{196}%#%f) '

# ### RIGHT PROMPTS
# RPROMPT='%{'$'\033[1A''%}' # one line up '\e[
# RPROMPT+='%F{red}%(?..↵ %?)%f '"$(git_info) "'%F{cyan}%D{%I:%M %p}%f'
# RPROMPT+='%{'$'\033[1B''%}' # one line down '\e[

# ### PS2 Multiline/continuation interactive prompt
# PS2="%_→ "

# ### PS4 Debug mode interactive prompt
# # PS4=+%N:%i>


export THEME_SOURCED=true
