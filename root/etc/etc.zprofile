#
# /etc/zprofile
#
# System-wide profile file for zsh(1) login shells.

# Setup user specific overrides for this in ~/.zprofile. See zshbuiltins(1)
# and zshoptions(1) for more details.


## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: /etc/zprofile"

## This file doesn't contain the shell vars we need, they are in /etc/profile.
## We need to verify if it has been somewhat sourced at this point, if not,
## source it right away,

if [ -z "$ETCPROFILE_SOURCED" ];
then
   [ -r /etc/profile ] && . /etc/profile
fi


export ETCZPROFILE_SOURCED=true
