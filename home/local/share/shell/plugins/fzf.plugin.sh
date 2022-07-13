#
# Setup fzf
#

case "$(uname -s)" in
	"Darwin")
		## Check for Homebrew install
		if [ -f /usr/local/bin/brew ]; then
			fzfPrefix=/usr/local/opt/fzf/shell

		## Check for Homebrew install #2
		elif [ -f /opt/homebrew/bin/brew ]; then
			fzfPrefix=/opt/homebrew/opt/fzf/shell

		## Check for MacPorts install
		elif [ -f /opt/local/bin/port ]; then
			fzfPrefix=/opt/local/opt/fzf/shell

		## Check for MacPorts install #2
		elif [ -f /opt/ports/bin/port ]; then
			fzfPrefix=/opt/ports/opt/fzf/shell

		## Check for NetBSD Pkgin install
		elif [ -f /opt/pkg/bin/pkgin ]; then
			fzfPrefix=/opt/pkg/opt/fzf/shell

		## Check for Fink install
		elif [ -f /sw/bin/pkgin ]; then
			fzfPrefix=/sw/opt/fzf/shell
		fi
	;;
	"Linux")
		fzfPrefix=/usr/share/fzf
	;;
esac

case "$(ps -o args= -p $$ | egrep -m 1 -o '\b\w{0,6}sh|koi')" in
	"zsh")
		[[ -o interactive ]] && . "${fzfPrefix}/completion.zsh" 2>/dev/null
	;;
	"bash")
		[[ "$-" == *i* ]] && . "${fzfPrefix}/completion.zsh" 2>/dev/null
	;;
esac

[ -r "${fzfPrefix}/key-bindings.zsh" ] && . "${fzfPrefix}/key-bindings.zsh"
