#
# /etc/profile
#
# System-wide profile for sh(1) and ksh-like(1) shells.


### XDG BASE DIRECTORY SPECIFICATION v0.8
## Where user-specific configuration files should be written.
export XDG_CONFIG_HOME="$HOME/.etc"                        ## /etc
# export XDG_CONFIG_HOME="$HOME/.config"

## Where user-specific non-essential (cached) data should be written.
##  * Shell completion cache
## Cached files can be deleted without loss of any important data
export XDG_CACHE_HOME="$HOME/.var/cache"                   ## /var/cache
# export XDG_CACHE_HOME="$HOME/.cache"

## Where user-specific data files should be written.
export XDG_DATA_HOME="$HOME/.local/share"                  ## /usr(/local)/share

## Where user-specific state files should be written.
##  * Actions history (logs, history, recently used files, etc)
##  * Current state of the application (view, layout, open files, undo history..)
## Unimportant/portable enough state data that should persist between app restarts
export XDG_STATE_HOME="$HOME/.var/lib"                     ## /var/lib
# export XDG_STATE_HOME="$HOME/.local/state"

## Where user-specific runtime files and other file objects should be placed.
##  * Objects such as sockets, named pipes, etc.
## Runtime files should be stored but not preserved between system reboots.
export XDG_RUNTIME_DIR # ="$HOME/.runtime"                 ## /run (/var/run before FHS 3.0)

## Where user-specific executable files may be written.(UNOFFICIAL)
export XDG_BIN_DIR="$HOME/.local/bin"                      ## /usr/local/bin


export XDG_LIB_DIR="$HOME/.local/lib"
export XDG_OPT_DIR="$HOME/.opt"


## Dotfiles folder should be in $HOME.
[ -d "$HOME/.dotfiles" ] && export DOTFILES="$HOME/.dotfiles"

### Important Shell env vars
export BASHDOTDIR="${XDG_CONFIG_HOME:-$HOME/.etc}/bash" # Unused
export BASH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.var/lib}/bash"
export BASH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.var/cache}/bash"

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.etc}/zsh"
export ZSH_STATE_DIR="${XDG_STATE_HOME:-$HOME/.var/lib}/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.var/cache}/zsh"

export SHELL_HOME="${XDG_CONFIG_HOME:-$HOME/.etc}/shell"
export SHDEBUG_HOME="${XDG_CACHE_HOME:-$HOME/.var/cache}/shelldebug"




if [ -x /usr/libexec/path_helper ];
then
   eval `/usr/libexec/path_helper -s`
fi



#################################### SHELLS ####################################

# if [ "${BASH-no}" != "no" ]; then
if ps -o args= -p $$ | egrep -m 1 -q '\b(bash)';
then
   ## Printing for debugging purposes if session is interactive
   case "$-" in
      *i*) echo "Sourced: /etc/profile" ;;
   esac

   export POSIXLY_CORRECT=true
   export HISTFILE="${BASH_STATE_DIR:-$HOME/.var/lib/bash}/history"

   ## Checking Login v.s. Non-Login
   if shopt -q login_shell;
   then
      SHELL_IS_LOGIN=true
      SHELL_TYPE="Login"
   else
      SHELL_IS_LOGIN=false
      SHELL_TYPE="Non-Login"
   fi

   ## Checking Interactive vs Non-Interactive
   case "$-" in
      *i*)
         SHELL_IS_INTERACTIVE=true
         SHELL_TYPE+=" Interactive"
      ;;
      *)
         SHELL_IS_INTERACTIVE=false
         SHELL_TYPE+=" Non-Interactive"
      ;;
   esac

   export SHELL_IS_LOGIN
   export SHELL_IS_INTERACTIVE
   export SHELL_TYPE
   export SHELL_SESH="$SHELL_TYPE"

   ETCPROFILE_SOURCED="Bash"

   if [ -z "$ETCBASHRC_SOURCED" ];
   then
      if [ "$SHELL_IS_INTERACTIVE" = true ] && [ "$ETCPROFILE_SOURCED" = "Bash" ];
      then
         [ -r /etc/bash.bashrc ] && . /etc/bash.bashrc
      fi
   fi

################################################################################

elif ps -o args= -p $$ | egrep -m 1 -q '\b(zsh)';
then
   ## Printing for debugging purposes if session is interactive
   [[ -o interactive ]] && echo "Sourced: /etc/profile"

   ## Checking Login v.s. Non-Login
   if [[ -o login ]];
   then
      SHELL_IS_LOGIN=true
      SHELL_TYPE="Login"
   else
      SHELL_IS_LOGIN=false
      SHELL_TYPE="Non-Login"
   fi

   ## Checking Interactive vs Non-Interactive
   if [[ -o interactive ]];
   then
      SHELL_IS_INTERACTIVE=true
      SHELL_TYPE+=" Interactive"
   else
      SHELL_IS_INTERACTIVE=false
      SHELL_TYPE+=" Non-Interactive"
   fi

   export SHELL_IS_LOGIN
   export SHELL_IS_INTERACTIVE
   export SHELL_TYPE
   export SHELL_SESH="$SHELL_TYPE"

   ## Figure out the SHORT hostname
   if [ -z "$SHORT_HOST" ]; then
      case "$OSTYPE" in
         darwin*)
            ## macOS's $HOST changes with dhcp, etc. Use HostName if possible.
            SHORT_HOST=$(scutil --get HostName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
         ;;
      esac
   else
      SHORT_HOST=${HOST/.*/}
   fi

   ETCPROFILE_SOURCED="Zsh"

################################################################################

elif ps -o args= -p $$ | egrep -m 1 -q '\b(sh)';
then
   ## Printing for debugging purposes if session is interactive
   [ -t 1 ] && echo "Sourced: /etc/profile"

   export HISTFILE="${XDG_STATE_HOME=$HOME/.var/lib}/shell/history"

   ETCPROFILE_SOURCED="Sh"

################################################################################

else
   return
fi


export ETCPROFILE_SOURCED
