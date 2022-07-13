## Protect against non-zsh execution of Oh My Zsh (use POSIX syntax here)
if ! ps -o args= -p $$ | egrep -m 1 -q '\b(zsh)'; then return; fi

## If OMZ is not defined, use the current script's directory.
[ -z "$OMZ" ] && export OMZ="${${(%):-%x}:a:h}"

## Set ZSH_CACHE_DIR to the path where cache files should be created
## or else we will use the default /cache
[ -z "$ZSH_CACHE_DIR" ]; && ZSH_CACHE_DIR="$OMZ/cache"

## Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
[ ! -w "$ZSH_CACHE_DIR" ] && ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"

## Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

## Check for updates on initial load...
if [[ "$DISABLE_AUTO_UPDATE" != true ]]; then
	source "$OMZ/tools/check_for_upgrade.sh"
fi

## Initializes Oh My Zsh

## Add a function path
fpath=("$OMZ/functions" "$OMZ/completions" $fpath)

## Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

## Set ZSH_CUSTOM to the path where your custom config files
## and plugins exists, or else we will use the default /custom
if [[ -z "$ZSH_CUSTOM" ]]; then
	ZSH_CUSTOM="$OMZ/custom"
fi

is_plugin() {
	local base_dir="$1"
	local name="$2"
	builtin test -f "$base_dir/plugins/$name/$name.plugin.zsh" || \
	builtin test -f "$base_dir/plugins/$name/_$name" || \
	builtin test -f "$base_dir/plugins/$name.plugin.zsh" || \
	builtin test -f "$base_dir/plugins/_$name" || \
}

## Add all defined plugins to fpath. This must be done
## before running compinit.
for plugin ($plugins);
do
	if is_plugin "$ZSH_CUSTOM" "$plugin"; then
		fpath=("$ZSH_CUSTOM/plugins/$plugin" $fpath)
	elif is_plugin "$OMZ" "$plugin"; then
		fpath=("$OMZ/plugins/$plugin" $fpath)
	else
		echo "[oh-my-zsh] plugin '$plugin' not found"
	fi
done



################################## COMPLETION ##################################

## Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
	ZSH_COMPDUMP="${ZSH_CACHE_DIR:-$HOME/.var/cache/zsh}/omz-zcompdump-${HOST}-${ZSH_VERSION}"
fi

## Construct zcompdump OMZ metadata
zcompdump_revision="#omz revision: $(builtin cd -q "$OMZ"; git rev-parse HEAD 2>/dev/null)"
zcompdump_fpath="#omz fpath: $fpath"

## Delete the zcompdump file if zcompdump metadata changed
if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
|| ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null;
then
	command rm -f "$ZSH_COMPDUMP"
	zcompdump_refresh=1
fi

if [[ "$OMZ_DISABLE_COMPFIX" != true ]]; then
	source "$OMZ/lib/compfix.zsh"
	## If completion insecurities exist, warn the user
	handle_completion_insecurities
	## Load only from secure directories
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

## Load all of your custom configurations from /custom
## TIP: Add files you don't want in git to .gitignore
for config_file ("$OMZ"/lib/*.zsh); do
	custom_config_file="$ZSH_CUSTOM/lib/${config_file:t}"
	[[ -f "$custom_config_file" ]] && config_file="$custom_config_file"
	source "$config_file"
done
unset custom_config_file



################################# LOAD PLUGINS #################################

## Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins);
do
	if [ -f "$OMZ/plugins/custom/$plugin/$plugin.plugin.zsh" ]; then
		source "$OMZ/plugins/custom/$plugin/$plugin.plugin.zsh" || \
		source "$OMZ/plugins/custom/$plugin/_$plugin"
		echo "Plugin: $plugin"

	elif [ -f "$OMZ/plugins/custom/$plugin.plugin.zsh" ]; then
		source "$OMZ/plugins/custom/$plugin.plugin.zsh" || \
		source "$OMZ/plugins/custom/_$plugin"
		echo "Plugin: $plugin"

	elif [ -f "$OMZ/plugins/$plugin/$plugin.plugin.zsh" ]; then
		source "$OMZ/plugins/$plugin/$plugin.plugin.zsh" || \
		source "$OMZ/plugins/$plugin/_$plugin"
		echo "Plugin: $plugin"

	elif [ -f "$OMZ/plugins/$plugin.plugin.zsh" ]; then
		source "$OMZ/plugins/$plugin.plugin.zsh" || \
		source "$OMZ/plugins/_$plugin"
		echo "Plugin: $plugin"
	fi
done
unset plugin

## Load all of your custom configurations from custom/
for config_file ("$ZSH_CUSTOM"/*.zsh(N)); do
	source "$config_file"
done
unset config_file



################################# LOAD THEMES ##################################

## Load the theme
is_theme() {
	local base_dir=$1
	local name=$2
	builtin test -f "$base_dir/$name.zsh-theme" || \
	builtin test -f "$base_dir/$name.theme.zsh"
}

if [ -n "$ZSH_THEME" ]; then
	if is_theme "$OMZ/themes/custom/$ZSH_THEME" "$ZSH_THEME"; then
		source "$OMZ/themes/custom/$ZSH_THEME/$ZSH_THEME.zsh-theme" || \
		source "$OMZ/themes/custom/$ZSH_THEME/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	elif is_theme "$OMZ/themes/custom" "$ZSH_THEME"; then
		source "$OMZ/themes/custom/$ZSH_THEME.zsh-theme" || \
		source "$OMZ/themes/custom/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	elif is_theme "$OMZ/themes/$ZSH_THEME" "$ZSH_THEME"; then
		source "$OMZ/themes/$ZSH_THEME/$ZSH_THEME.zsh-theme" || \
		source "$OMZ/themes/$ZSH_THEME/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	elif is_theme "$OMZ/themes" "$ZSH_THEME"; then
		source "$OMZ/themes/$ZSH_THEME.zsh-theme" || \
		source "$OMZ/themes/$ZSH_THEME.theme.zsh"
		echo "Theme:  $ZSH_THEME"

	else
		echo "Theme '$ZSH_THEME' not found"
	fi
fi
