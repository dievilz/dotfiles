#
# config.zsh
#
# Configuration script for Zsh.

## Protect against non-zsh execution.
if ! ps -o args= -p $$ | egrep -m 1 -q '\b(zsh)'; then return; fi

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: $ZSH/configure.script.zsh"

[ -z "$ZSH" ] && return

## Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
[ -z "$ZSH_CACHE_DIR" ] && ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"


mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)



########################## Initialize configuration ###########################

## Add a function path
fpath=("$ZSH/functions" "$ZSH/completions" $fpath)

## Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

is_plugin() {
	local base_dir="$1"
	local name="$2"
	builtin test -f "$base_dir/$name/$name.plugin.zsh" || \
	builtin test -f "$base_dir/$name/_$name" || \
	builtin test -f "$base_dir/$name.plugin.zsh" || \
	builtin test -f "$base_dir/_$name" || \
}

## Add all defined plugins to fpath. This must be done
## before running compinit.
for plugin ($plugins);
do
	if is_plugin "$ZSH/plugins/custom" "$plugin"; then
		fpath=("$ZSH/plugins/custom/$plugin" $fpath)
	elif is_plugin "$ZSH/plugins" "$plugin"; then
		fpath=("$ZSH/plugins/$plugin" $fpath)
	else
		echo "Plugin '$plugin' not found"
	fi
done



################################## COMPLETION ##################################

## Construct zcompdump metadata
zcompdump_revision="#revision: $(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null)"
zcompdump_fpath="#fpath: $fpath"

## Delete the zcompdump file if zcompdump metadata changed
if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
|| ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null;
then
	command rm -f "$ZSH_COMPDUMP"
	zcompdump_refresh=1
fi

if [[ "$ZSH_DISABLE_COMPFIX" != true ]]; then
	# source "$OMZ/lib/compfix.zsh"
	# ## If completion insecurities exist, warn the user
	# handle_completion_insecurities
	# ## Load only from secure directories
	compinit -i -C -d "${ZSH_COMPDUMP}"
else
	## If the user wants it, load from all found directories
	compinit -u -C -d "${ZSH_COMPDUMP}"
fi

## Append zcompdump metadata if missing
if (( $zcompdump_refresh )); then
	## Use `tee` in case the $ZSH_COMPDUMP filename is invalid, to silence the error
	## See https://github.com/ohmyzsh/ohmyzsh/commit/dd1a7269#commitcomment-39003489
	tee -a "$ZSH_COMPDUMP" &>/dev/null <<EOF

$zcompdump_revision
$zcompdump_fpath
EOF
fi
unset zcompdump_revision zcompdump_fpath zcompdump_refresh



################################# LOAD PLUGINS #################################

## Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins);
do
	if [ -f "$ZSH/plugins/custom/$plugin/$plugin.plugin.zsh" ]; then
		source "$ZSH/plugins/custom/$plugin/$plugin.plugin.zsh" || \
		source "$ZSH/plugins/custom/$plugin/_$plugin"
		echo "Plugin: $plugin"

	elif [ -f "$ZSH/plugins/custom/$plugin.plugin.zsh" ]; then
		source "$ZSH/plugins/custom/$plugin.plugin.zsh" || \
		source "$ZSH/plugins/custom/_$plugin"
		echo "Plugin: $plugin"

	elif [ -f "$ZSH/plugins/$plugin/$plugin.plugin.zsh" ]; then
		source "$ZSH/plugins/$plugin/$plugin.plugin.zsh" || \
		source "$ZSH/plugins/$plugin/_$plugin"
		echo "Plugin: $plugin"

	elif [ -f "$ZSH/plugins/$plugin.plugin.zsh" ]; then
		source "$ZSH/plugins/$plugin.plugin.zsh" || \
		source "$ZSH/plugins/_$plugin"
		echo "Plugin: $plugin"
	fi
done
unset plugin



################################# LOAD THEMES ##################################

## Load the theme
is_theme() {
	local base_dir=$1
	local name=$2
	builtin test -f "$base_dir/$name.zsh-theme" || \
	builtin test -f "$base_dir/$name.theme.zsh"
}

if [ -n "$ZSH_THEME" ]; then
	if is_theme "$ZSH/themes/custom/$ZSH_THEME" "$ZSH_THEME"; then
		source "$ZSH/themes/custom/$ZSH_THEME/$ZSH_THEME.zsh-theme" || \
		source "$ZSH/themes/custom/$ZSH_THEME/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	elif is_theme "$ZSH/themes/custom" "$ZSH_THEME"; then
		source "$ZSH/themes/custom/$ZSH_THEME.zsh-theme" || \
		source "$ZSH/themes/custom/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	elif is_theme "$ZSH/themes/$ZSH_THEME" "$ZSH_THEME"; then
		source "$ZSH/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme" || \
		source "$ZSH/themes/$ZSH_THEME/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	elif is_theme "$ZSH/themes" "$ZSH_THEME"; then
		source "$ZSH/themes/$ZSH_THEME.zsh-theme" || \
		source "$ZSH/themes/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	else
		echo "Theme '$ZSH_THEME' not found"
	fi
fi
