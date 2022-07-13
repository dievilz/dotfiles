#
# My custom @mavam's POWERLEVEL10K Configuration
#

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/themes/dievilz-custom.p10k.zsh"


PS2=" %_→ "
alias pl9kLeftPtMC_wo_Dev='POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    root_indicator  dir_writable_joined  dir_joined  newline
    context  command_execution_time  status
)'
alias pl9kLeftPtMC='POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    root_indicator  dir_writable_joined  dir_joined  newline
    context  command_execution_time  status  newline
    node_version  nvm  chruby  php_version  virtualenv  pyenv
)'
alias pl9kRightPtMC_wo_Joined='POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    newline  vcs  newline  background_jobs  time  os_icon
)'
alias pl9kRightPtMC='POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    newline  vcs_joined  newline  background_jobs_joined  time_joined  os_icon_joined
)'



############################ POWERLEVEL10K SETTINGS ################################################

typeset -g POWERLEVEL9K_MODE="nerdfont-complete"
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT=1
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"   # ╭─
# POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{blue}\u251c\u2500%f" # ├─
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f "   # ╰❯
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=""
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=" %(?.%F{040}❯%f.%F{196}❯%f) "

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    root_indicator  dir_writable_joined  dir_joined  newline
    context  command_execution_time  status  newline
    node_version  nvm  chruby  php_version  virtualenv  pyenv
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    newline  vcs_joined  newline  background_jobs  time  os_icon
)
# ==================================================================================================

## When set to `moderate`, some icons will have an extra space after them. This
## is meant to avoid icon overlap when using non-monospace fonts. When set to
## `none`, spaces are not added.
typeset -g POWERLEVEL9K_ICON_PADDING=moderate

typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='·'
if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    # The color of the filler.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=244
    # Add a space between the end of left prompt and the filler.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
    # Add a space between the filler and the start of right prompt.
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '
    # Start filler from the edge of the screen if there are no left segments on the first line.
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    # End filler on the edge of the screen if there are no right segments on the first line.
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
fi

## Add a space between the end of left prompt and the filler.
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
## Add a space between the filler and the start of right prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''


# ==== [ TRANSIENT PROMPT ] ========================================================================

## Transient prompt works similarly to the builtin transient_rprompt option. It
## trims down prompt when accepting a command line.
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# --------------------------------------------------------------------------------------------------


# ==== [ Background Jobs segment ] =================================================================
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="clear"
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=114                   # palegreen3a (verde mavam)
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE_ALWAYS=true


# ==== [ Command Execution Time segment ] ==========================================================
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="clear"
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=magenta                              # 005
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0


# ==== [ Context: user@hostname segment ] ==========================================================
# Context color in SSH without privileges.
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND="clear"
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=214                # fuchsia (bright magenta)
# Context color in SSH with privileges.
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND="clear"
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=013                     # orange1, alt:226 yellow1
# Context color when running with privileges.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="clear"
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=214                       # orange1, alt:226 yellow1
# Default context color (no privileges, no SSH).
typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND="clear"
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=013                            # fuchsia (bright magenta)

# Context format when in SSH without privileges: user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_TEMPLATE="%B$(print_icon USER_ICON) %n @ $(print_icon CONTEXT_ICON) %m"
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_TEMPLATE="$(print_icon USER_ICON) %n @ $(print_icon CONTEXT_ICON) %m"
# Context format when running with privileges: bold user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%B$(print_icon USER_ICON) %n @ $(print_icon CONTEXT_ICON) %m"
# Default context format (no privileges, no SSH): user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="$(print_icon USER_ICON) %n @ $(print_icon CONTEXT_ICON) %m"

typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true


# ==== [ Dir segment ] =============================================================================
typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

typeset -g POWERLEVEL9K_DIR_CLASSES=(
   '~'            HOME            ''
   '~/*'          HOME_SUBFOLDER  ''
   '/etc(|/*)'    ETC             ''
   '*'            DEFAULT         ''
)

# Styling for HOME 
typeset -g POWERLEVEL9K_DIR_HOME_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'HOME_ICON')"
typeset -g POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_HOME_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_HOME_ANCHOR_FOREGROUND=39

typeset -g POWERLEVEL9K_DIR_HOME_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'HOME_ICON')"
typeset -g POWERLEVEL9K_DIR_HOME_NOT_WRITABLE_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_HOME_NOT_WRITABLE_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_HOME_NOT_WRITABLE_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_HOME_NOT_WRITABLE_ANCHOR_FOREGROUND=39

# Styling for HOME_SUBFOLDER 
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'HOME_SUB_ICON')"
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_ANCHOR_FOREGROUND=39

typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'HOME_SUB_ICON')"
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_NOT_WRITABLE_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_NOT_WRITABLE_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_NOT_WRITABLE_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_NOT_WRITABLE_ANCHOR_FOREGROUND=39

# Styling for DEFAULT 
typeset -g POWERLEVEL9K_DIR_DEFAULT_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'FOLDER_ICON')"
typeset -g POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_DEFAULT_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_DEFAULT_ANCHOR_FOREGROUND=39

typeset -g POWERLEVEL9K_DIR_DEFAULT_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'FOLDER_ICON')"
typeset -g POWERLEVEL9K_DIR_DEFAULT_NOT_WRITABLE_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_DEFAULT_NOT_WRITABLE_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_DEFAULT_NOT_WRITABLE_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_DEFAULT_NOT_WRITABLE_ANCHOR_FOREGROUND=39

# Styling for ETC 
typeset -g POWERLEVEL9K_DIR_ETC_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'ETC_ICON')"
typeset -g POWERLEVEL9K_DIR_ETC_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_ETC_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_ETC_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_ETC_ANCHOR_FOREGROUND=39

typeset -g POWERLEVEL9K_DIR_ETC_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION="$(print_icon 'ETC_ICON')"
typeset -g POWERLEVEL9K_DIR_ETC_NOT_WRITABLE_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_ETC_NOT_WRITABLE_FOREGROUND=blue
# typeset -g POWERLEVEL9K_DIR_ETC_NOT_WRITABLE_SHORTENED_FOREGROUND=103
# typeset -g POWERLEVEL9K_DIR_ETC_NOT_WRITABLE_ANCHOR_FOREGROUND=39


# typeset -g  POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
# typeset -g  POWERLEVEL9K_ALWAYS_SHOW_USER=true
# typeset -g  POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
# typeset -g  POWERLEVEL9K_SHORTEN_DELIMITER=""
# typeset -g  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# typeset -g POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=""
# typeset -g POWERLEVEL9K_DIR_PATH_HIGHLIGHT_BOLD=true

# typeset -g POWERLEVEL9K_DIR_PATH_SEPARATOR_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND=cyan                                     # 006
typeset -g POWERLEVEL9K_DIR_PATH_SEPARATOR="/"




# ==== [ Dir Writable segment ] ====================================================================
typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="clear"
typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND=red                   # 001, alt:160 red3a



# ==== [ Host segment ] ============================================================================
typeset -g POWERLEVEL9K_HOST_LOCAL_BACKGROUND="clear"
typeset -g POWERLEVEL9K_HOST_LOCAL_FOREGROUND=013                         # fuchsia (bright magenta)
typeset -g POWERLEVEL9K_HOST_REMOTE_BACKGROUND="clear"
typeset -g POWERLEVEL9K_HOST_REMOTE_FOREGROUND="magenta"
typeset -g POWERLEVEL9K_HOST_ICON="\uF109 "          # Default pero con un espacio al final


# ==== [ IP segment ] ==============================================================================
typeset -g POWERLEVEL9K_IP_BACKGROUND=027                                              # dodgerblue2
# POWERLEVEL9K_IP_FOREGROUND="clear"


# ==== [ OS Icon segment ] =========================================================================
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="clear"
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=white                                               # 015


# ==== [ Root Indicator segment ] ==================================================================
typeset -g POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="clear"
typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=226       # yellow1 (amarillo chido), orig 001 red


# ==== [ SSH segment ] =============================================================================
# POWERLEVEL9K_SSH_BACKGROUND=221                               # lightgoldenrod2a (amarillo palido)
typeset -g POWERLEVEL9K_SSH_FOREGROUND="clear"
# POWERLEVEL9K_SSH_ICON="\uF489 "                             # Default pero con un espacio al final


# ==== [ Status segment ] ==========================================================================
## Status when some part of a pipe command fails but the overall exit status is zero. It may look
## like this: 1|0.
typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=040                 # green3a, alt:070 chartreuse3
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

## Status when some part of a pipe command fails and the overall exit status is
## also non-zero. It may look like this: 1|0.
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=196                       # red1, alt:160 red3a
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION=''

typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND="clear"
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=040                                           # green3a
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND="clear"
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=196                                           # red1
# POWERLEVEL9K_STATUS_CROSS=false
typeset -g POWERLEVEL9K_STATUS_OK=false
# POWERLEVEL9K_STATUS_SHOW_PIPESTATUS=true
# POWERLEVEL9K_STATUS_HIDE_SIGNAME=false


# ==== [ Time segment ] ============================================================================
typeset -g POWERLEVEL9K_TIME_BACKGROUND="clear"
typeset -g POWERLEVEL9K_TIME_FOREGROUND=cyan                                          # 006
typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%I:%M %p}" # 00:00 PM
typeset -g POWERLEVEL9K_TIME_12HR=true


# ==== [ User segment ] ============================================================================
typeset -g POWERLEVEL9K_USER_DEFAULT_BACKGROUND="clear"
typeset -g POWERLEVEL9K_USER_DEFAULT_FOREGROUND=013              # fuchsia (bright magenta)
typeset -g POWERLEVEL9K_USER_ICON="\uF415"                                 # user   default "$(print_icon USER_ICON)
# POWERLEVEL9K_ALWAYS_SHOW_USER=false
# POWERLEVEL9K_USER_TEMPLATE="%n"

typeset -g POWERLEVEL9K_USER_ROOT_BACKGROUND="clear"
typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND=009                               # bright red
typeset -g POWERLEVEL9K_ROOT_ICON="\u26A1"                                 # rayito default

typeset -g POWERLEVEL9K_USER_SUDO_BACKGROUND="clear"
typeset -g POWERLEVEL9K_USER_SUDO_FOREGROUND=013                 # fuchsia (bright magenta)
typeset -g POWERLEVEL9K_SUDO_ICON="\uF09C"                           # candado desbloqueado




#### Development Environment Segments ##############################################################

# ==== [ VCS segment ] =============================================================================
## Don't show Git status in prompt for repositories whose workdir matches this
## pattern. For example, if set to '~', the Git repository at $HOME/.git will be
## ignored. Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="clear"
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=070            # chartreuse3 (verde vcs chido)
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="clear"
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow                                # 003
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="clear"
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=130  # darkorange3 (naranja feo vcs), alt:166 darkorange3a
typeset -g POWERLEVEL9K_SHOW_CHANGESET=true
# POWERLEVEL9K_CHANGESET_HASH_LENGTH=12
# POWERLEVEL9K_VCS_HIDE_TAGS=false
# POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)

## Don't check if submodules are dirty when showing vcs status
## This isn't important if I am not using VCS status
## (which is slow in the fs repo)
# POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY=false
# --------------------------------------------------------------------------------------------------


typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND="clear"
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=green              # 002, alt:022 darkgreen
# POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_COLOR=green

typeset -g POWERLEVEL9K_NVM_BACKGROUND="clear"
typeset -g POWERLEVEL9K_NVM_FOREGROUND=green                       # 002, alt:022 darkgreen

typeset -g POWERLEVEL9K_PHP_VERSION_BACKGROUND="clear"
typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=099              # slateblue1 (morado chido)
typeset -g POWERLEVEL9K_PHP_VERSION_ICON=$'\uE608'

typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND="clear"
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=214                                 # orange1
# POWERLEVEL9K_VIRTUALENV_PROMPT_ALWAYS_SHOW="true"

typeset -g POWERLEVEL9K_PYENV_BACKGROUND="clear"
typeset -g POWERLEVEL9K_PYENV_FOREGROUND=185                      # khaki3, alt:214 orange1
# POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW="true"

typeset -g POWERLEVEL9K_CHRUBY_BACKGROUND="clear"
typeset -g POWERLEVEL9K_CHRUBY_FOREGROUND=166                                # darkorange3a
typeset -g POWERLEVEL9K_CHRUBY_SHOW_ENGINE="false"
# POWERLEVEL9K_CHRUBY_SHOW_VERSION="true"
