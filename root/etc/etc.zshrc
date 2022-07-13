#
# /etc/zshrc
#
# System-wide run-commands file for zsh(1) interactive shells.

# Setup user specific overrides for this in ~/.zshrc. See zshbuiltins(1)
# and zshoptions(1) for more details.


## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: /etc/zshrc"


################################### OPTIONS ####################################

## Correctly display UTF-8 with combining characters.
if [ "$(locale LC_CTYPE)" = "UTF-8" ]; then
   setopt COMBINING_CHARS
fi

## Disable the log builtin, so we don't conflict with /usr/bin/log
if [ -x /usr/bin/log ]; then
   disable log
fi

setopt AUTO_CD              # If only directory path is entered, cd there.
setopt AUTO_NAME_DIRS       # For dynamic named directories
setopt AUTO_PUSHD           # Make cd push the old directory onto the directory stack.
setopt EXTENDED_GLOB        # Extended globbing. Allows using regular expressions with *
setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shells.
setopt NUMERIC_GLOB_SORT    # Sort filenames numerically when it makes sense
setopt PUSHD_IGNORE_DUPS    # Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_MINUS          # Exchanges the meanings of ‘+’ and ‘-’ when used with a number to specify a dir in the stack.
setopt RC_EXPAND_PARAM      # Array expansion with parameters

setopt APPEND_HISTORY         # Append history list to $HISTFILE instead of replace it when shell exits
setopt EXTENDED_HISTORY       # Record timestamp of command in $HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when $HISTFILE size exceeds $HISTSIZE
setopt HIST_IGNORE_ALL_DUPS   # If a new command is a duplicate, remove the older one
setopt HIST_IGNORE_DUPS       # Ignore duplicated commands history list
setopt HIST_IGNORE_SPACE      # Ignore commands that start with space
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY     # New lines added to $HISTFILE incrementally (as soon as they are entered)

unsetopt BEEP          # No beep on error
unsetopt CASE_GLOB     # Case insensitive globbing
unsetopt CHECK_JOBS    # Don't warn about running processes when exiting
unsetopt CORRECT       # No auto-correct mistakes
unsetopt NOTIFY        # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
unsetopt NOMATCH       # Passes the command as is instead of reporting pattern matching failure
unsetopt PROMPT_SUBST  # Disable variable substitution for prompt
unsetopt SHARE_HISTORY # Imports new lines from $HISTFILE, and append typed lines to $HISTFILE



## *-magic is known buggy in some versions; disable if so
autoload -Uz is-at-least
if [[ $DISABLE_MAGIC_FUNCTIONS != true ]];
then
   for d in $fpath;
   do
      if [[ -e "$d/url-quote-magic" ]];
      then
         if is-at-least 5.1;
         then
            autoload -Uz bracketed-paste-magic
            zle -N bracketed-paste bracketed-paste-magic
         fi
         autoload -Uz url-quote-magic
         zle -N self-insert url-quote-magic
         break
      fi
   done
fi



########################### COMPLETION & KEYBINDINGS ###########################

## Use keycodes (generated via zkbd) if present, otherwise fallback on
## values from terminfo
if [ -r "${ZDOTDIR:-$HOME/.config}/zkbd/${TERM}-${VENDOR}" ]; then
   . "${ZDOTDIR:-$HOME/.config}/zkbd/${TERM}-${VENDOR}"
fi

if [ "$(uname)" = "Darwin" ]; then
   typeset -g -A key

   [ -n "$terminfo[kf1]" ]   &&  key[F1]=$terminfo[kf1]
   [ -n "$terminfo[kf2]" ]   &&  key[F2]=$terminfo[kf2]
   [ -n "$terminfo[kf3]" ]   &&  key[F3]=$terminfo[kf3]
   [ -n "$terminfo[kf4]" ]   &&  key[F4]=$terminfo[kf4]
   [ -n "$terminfo[kf5]" ]   &&  key[F5]=$terminfo[kf5]
   [ -n "$terminfo[kf6]" ]   &&  key[F6]=$terminfo[kf6]
   [ -n "$terminfo[kf7]" ]   &&  key[F7]=$terminfo[kf7]
   [ -n "$terminfo[kf8]" ]   &&  key[F8]=$terminfo[kf8]
   [ -n "$terminfo[kf9]" ]   &&  key[F9]=$terminfo[kf9]
   [ -n "$terminfo[kf10]" ]  && key[F10]=$terminfo[kf10]
   [ -n "$terminfo[kf11]" ]  && key[F11]=$terminfo[kf11]
   [ -n "$terminfo[kf12]" ]  && key[F12]=$terminfo[kf12]
   [ -n "$terminfo[kf13]" ]  && key[F13]=$terminfo[kf13]
   [ -n "$terminfo[kf14]" ]  && key[F14]=$terminfo[kf14]
   [ -n "$terminfo[kf15]" ]  && key[F15]=$terminfo[kf15]
   [ -n "$terminfo[kf16]" ]  && key[F16]=$terminfo[kf16]
   [ -n "$terminfo[kf17]" ]  && key[F17]=$terminfo[kf17]
   [ -n "$terminfo[kf18]" ]  && key[F18]=$terminfo[kf18]
   [ -n "$terminfo[kf19]" ]  && key[F19]=$terminfo[kf19]
   [ -n "$terminfo[kf20]" ]  && key[F20]=$terminfo[kf20]
   [ -n "$terminfo[khome]" ] && key[Home]=$terminfo[khome]
   [ -n "$terminfo[kend]"  ] && key[End]=$terminfo[kend]
   [ -n "$terminfo[kich1]" ] && key[Insert]=$terminfo[kich1]
   [ -n "$terminfo[kbs]"   ] && key[Backspace]=$terminfo[kbs]
   [ -n "$terminfo[kdch1]" ] && key[Delete]=$terminfo[kdch1]
   [ -n "$terminfo[kcuu1]" ] && key[Up]=$terminfo[kcuu1]
   [ -n "$terminfo[kcud1]" ] && key[Down]=$terminfo[kcud1]
   [ -n "$terminfo[kcub1]" ] && key[Left]=$terminfo[kcub1]
   [ -n "$terminfo[kcuf1]" ] && key[Right]=$terminfo[kcuf1]
   [ -n "$terminfo[kpp]"   ] && key[PageUp]=$terminfo[kpp]
   [ -n "$terminfo[knp]"   ] && key[PageDown]=$terminfo[knp]
   [ -n "$terminfo[kcbt]"  ] && key[Shift-Tab]="${terminfo[kcbt]}"

   ## Default key bindings
   [ -n "${key[Home]}"      ] && bindkey -- "${key[Home]}"       beginning-of-line
   [ -n "${key[End]}"       ] && bindkey -- "${key[End]}"        end-of-line
   [ -n "${key[Insert]}"    ] && bindkey -- "${key[Insert]}"     overwrite-mode
   [ -n "${key[Backspace]}" ] && bindkey -- "${key[Backspace]}"  backward-delete-char
   [ -n "${key[Delete]}"    ] && bindkey -- "${key[Delete]}"     delete-char
   [ -n "${key[Up]}"        ] && bindkey -- "${key[Up]}"         up-line-or-history
   [ -n "${key[Down]}"      ] && bindkey -- "${key[Down]}"       down-line-or-history
   [ -n "${key[Left]}"      ] && bindkey -- "${key[Left]}"       backward-char
   [ -n "${key[Right]}"     ] && bindkey -- "${key[Right]}"      forward-char
   [ -n "${key[PageUp]}"    ] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
   [ -n "${key[PageDown]}"  ] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
   [ -n "${key[Shift-Tab]}" ] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
else
   bindkey -e
   bindkey '^[[7~' beginning-of-line                  # Home key
   bindkey '^[[H' beginning-of-line                   # Home key
   if [ "${terminfo[khome]}" != "" ]; then
      bindkey "${terminfo[khome]}" beginning-of-line  # [Home] - Go to beginning of line
   fi
   bindkey '^[[8~' end-of-line                        # End key
   bindkey '^[[F' end-of-line                         # End key
   if [ "${terminfo[kend]}" != "" ]; then
      bindkey "${terminfo[kend]}" end-of-line         # [End] - Go to end of line
   fi
   bindkey '^[[2~' overwrite-mode                     # Insert key
   bindkey '^[[3~' delete-char                        # Delete key
   bindkey '^[[C'  forward-char                       # Right key
   bindkey '^[[D'  backward-char                      # Left key
   bindkey '^[[5~' history-beginning-search-backward  # Page up key
   bindkey '^[[6~' history-beginning-search-forward   # Page down key

   ## Navigate words with ctrl+arrow keys
   bindkey '^[[Oc' forward-word
   bindkey '^[[Od' backward-word
   bindkey '^[[1;5D' backward-word
   bindkey '^[[1;5C' forward-word
   bindkey '^H' backward-kill-word    # delete previous word with ctrl+backspace
   bindkey '^[[Z' undo                # Shift+tab undo last action
fi

## Finally, make sure the terminal is in application mode, when zle is
## active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
   autoload -Uz add-zle-hook-widget
   function zle_application_mode_start { echoti smkx }
   function zle_application_mode_stop { echoti rmkx }
   add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
   add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi



################################# COMPLETION ###################################

#======= THEMING AUTO/TAB COMPLETE ========
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true  # Automatically find new executables in path

## Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR:-$HOME/.var/cache/zsh}"

autoload -Uz compinit

zstyle ':completion:*' menu select
zmodload zsh/complist
   # ============== VI MODE ==================
   bindkey -v
   export KEYTIMEOUT=1

   ## Use vim keys in tab complete menu:
   bindkey -M menuselect 'h' vi-backward-char        # 2> /dev/null
   bindkey -M menuselect 'k' vi-up-line-or-history   # 2> /dev/null
   bindkey -M menuselect 'l' vi-forward-char         # 2> /dev/null
   bindkey -M menuselect 'j' vi-down-line-or-history # 2> /dev/null
   bindkey -v '^?' backward-delete-char              # 2> /dev/null
   # =========================================

zmodload zsh/stat
zmodload zsh/terminfo  # bind UP and DOWN arrow keys to history substring search

_comp_options+=(globdots)       # Include hidden files.

# case "$(uname -s)" in
#   "Darwin")
#     if [ "$(date +'%j')" != "$(/usr/bin/stat -f '%Sm' -t '%j' "${ZSH_CACHE_DIR:-$HOME/.var/cache/zsh}/.zcompdump-${HOST}-${ZSH_VERSION}")" ];
#     then
#       compinit -d "${ZSH_CACHE_DIR:-$HOME/.var/cache/zsh}/.zcompdump-${HOST}-${ZSH_VERSION}"
#     else
#       compinit -C
#     fi
#   ;;
#   "Linux")
#     # not yet match for GNU/BSD stat
#   ;;
# esac



################################### THEMES #####################################

# ============= WINDOW TITLE ================
## Load built-in version control system
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn

case "$TERM" in
   xterm*|putty*|rxvt*|ansi|mlterm*|alacritty|st*|(dt|k|E)term)
      precmd() {
         vcs_info
         print -Pn "\e]0;%~ \a"
      }
      preexec() {
         print -Pn "\e]0;%~ ($1)\a"
      }
   ;;
   screen*|tmux*)
      precmd() {
         vcs_info
         print -Pn "\e]83;title \"$1\"\a"
         print -Pn "\e]0;$TERM - (%L) %~ \a"
      }
      preexec() {
         print -Pn "\e]83;title \"$1\"\a"
         print -Pn "\e]0;$TERM - (%L) %~ ($1)\a"
      }
   ;;
   *)
      # Try to use terminfo to set the title
      # If the feature is available set title
      if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
         echoti tsl
         print -Pn "$1"
         echoti fsl
      fi
   ;;
esac


# =============== PROMPTS ===================
## Enable colors, zcalc and predefined variables
autoload -U colors zcalc && colors
## Load the theme system
autoload -U promptinit && promptinit

## Only use colors if connected to a terminal
if [ -t 1 ];
then
   ### PROMPT Default interaction prompt
   PROMPT='
%F{blue}%~%f
%F{061}%n@%m%f
%(?.%F{040}%#%f.%F{196}%#%f) '

   ### RPROMPT Additional right prompt
   RPROMPT='%{'$'\033[1A''%}' # one line up '\e[
   RPROMPT+='%F{red}%(?..↵ %?)%f  %F{cyan}%D{%I:%M %p}%f'
   RPROMPT+='%{'$'\033[1B''%}' # one line down '\e[
else
   ### PS1 Default interaction prompt
   PS1="
%~
%n@%m
%# "

   RPROMPT='%{'$'\033[1A''%}' # one line up '\e[
   RPROMPT+='%(?..↵ %?)  %D{%I:%M %p}%f'
   RPROMPT+='%{'$'\033[1B''%}' # one line down '\e[
fi

### PS2 Multiline/continuation interactive prompt
PS2="%_→ "

### PS4 Debug mode interactive prompt
# PS4=+%N:%i>

# ### PS2 Multiline/continuation interactive prompt
# PS2="%_> "      # Default

# ### PS4 Debug mode interactive prompt
# PS4="+%N:%i>"   # Default

################################################################################


export ETCZSHRC_SOURCED=true


## If the session is non-login interactive, /etc/zprofile will not be sourced,
## only this file will be. We need to source it if we are in macOS because
## we need our env vars initialized.
if [ "$(uname -s)" = "Darwin" ];
then
   if [[ ! -o login ]] && [ -z "$ETCZPROFILE_SOURCED" ];
   then
      [ -r "/etc/zprofile" ] && . /etc/zprofile
   fi
fi


## Useful support for interacting with Terminal.app or other terminal programs:
if [ "$(uname -s)" = "Darwin" ] && [ -r "/etc/zshrc_$TERM_PROGRAM" ];
then
   . "/etc/zshrc_$TERM_PROGRAM"
fi
