# /etc/zshenv
#
# System-wide env file for zsh(1) shells.

# Setup user specific overrides for this in ~/.zshenv. See zshbuiltins(1)
# and zshoptions(1) for more details.


## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: /etc/zshenv"


## Set the [system-wide/3rd party] plugins/themes location
[ -d /opt/zsh ] && export ZSH=/opt/zsh

## Set the        [local]          plugins/themes location
case "$(uname -s)" in
   "Darwin") [ -d /usr/local/share/zsh ] && export ZSH_LOCAL=/usr/local/share/zsh ;;
          *) [ -d /usr/share/zsh ] && export ZSH_LOCAL=/usr/share/zsh ;;
esac

## Set the [system-wide/3rd party] plugins location
[ -d "$ZSH/plugins" ] && export ZSH_PLUGIN_DIR="$ZSH/plugins"
## Set the [system-wide/3rd party] themes location
[ -d "$ZSH/themes" ] && export ZSH_THEME_DIR="$ZSH/themes"


## Setting $ZDOTDIR straight inside into /etc/zshenv will make ZSH source $ZDOTDIR/.zshenv
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.etc}/zsh"
export ZSH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.var/lib}/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.var/cache}/zsh"

export HISTFILE="${ZSH_STATE_DIR:-$HOME/.var/lib/zsh}/history"

export ZSH_COMPDUMP="${ZSH_CACHE_DIR:-$HOME/.var/cache/zsh}/zcompdump-${HOST}-${ZSH_VERSION}"



export ETCZENV_SOURCED=true
