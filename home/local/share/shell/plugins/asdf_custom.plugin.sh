# Find where asdf should be installed
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
ASDF_COMPLETIONS="${ASDF_COMPLETIONS:-$HOME/.asdf/completions}"

# If not found, check for Homebrew package
if [ ! -f "$ASDF_DIR/asdf.sh" ] || [ ! -f "$ASDF_COMPLETIONS/asdf.bash" ] \
&& command -v brew >/dev/null 2>&1;
then
	ASDF_DIR="$(brew --prefix asdf)"
	ASDF_COMPLETIONS="$ASDF_DIR/etc/bash_completion.d"
fi

# Load command
if [ -f "$ASDF_DIR/asdf.sh" ]; then
	. "$ASDF_DIR/asdf.sh"

	# Load completions
	if [ -d "$ASDF_COMPLETIONS" ]; then
		case "$(ps -o args= -p $$ | egrep -m 1 -o '\b\w{0,6}sh|koi')" in
			"zsh")
				fpath=("${ASDF_DIR}/completions" $fpath)
			;;
			*)
				. "$ASDF_COMPLETIONS/asdf.bash"
			;;
		esac
	fi
fi
