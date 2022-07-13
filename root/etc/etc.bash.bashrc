#
# /etc/bashrc
#
# System-wide bashrc file for bash(1) interactive shells.


## Printing for debugging purposes
echo "Sourced: /etc/bash.bashrc"


## If not running interactively, don't do anything.
[ -z "$PS1" ] && return


shopt -s checkwinsize # Make bash check its window size after a process completes
shopt -s nocaseglob;  # Case-insensitive globbing (used in pathname expansion)
shopt -s histappend;  # Append to $HISTFILE, rather than overwriting it
shopt -s cdspell;     # Autocorrect typos in path names when using `cd`

## Enable some Bash 4 features when possible:
## * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
## * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
   shopt -s "$option" 2>/dev/null;
done;


### PS1 Default interaction prompt
PS1="\[\033]0;\w\007\]" ## Set the terminal title to the current working directory
PS1+='
\w
\u@\h
\$ '

### PS2 Multiline/continuation interactive prompt
PS2="\[\033[m\]> \[\033[m\]"

### PS4 Debug mode interactive prompt
fileToDebug="$(basename "$0")"
PS4='${fileToDebug}.$LINENO+ '
unset fileToDebug



export ETCBASHRC_SOURCED=true


## If the session is non-login interactive, /etc/profile will not be sourced,
## only this file is supposed to be sourced. We need to source it if we are
## in macOS because we need our env vars initialized.
if [ "$(uname -s)" = "Darwin" ]; then
   if ! shopt -q login_shell && [ -z "$ETCPROFILE_SOURCED" ]; then
      [ -r "/etc/profile" ] && . /etc/profile
   fi
fi


## Useful support for interacting with Terminal.app or other terminal programs:
if [ "$(uname -s)" = "Darwin" ] && [ -r "/etc/bash.bashrc_$TERM_PROGRAM" ]; then
   . "/etc/bash.bashrc_$TERM_PROGRAM"
fi
