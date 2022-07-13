#
# My custom @mavam's POWERLEVEL9K Configuration
#

## Printing for debugging purposes if session is interactive
[[ -o interactive ]] && echo "Sourced: \$ZDOTDIR/themes/pl9k/mavam-custom.pl9k.zsh"


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
    vcs  background_jobs  time  os_icon
)'
alias pl9kRightPtMC='POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    vcs_joined  background_jobs_joined  time_joined  os_icon_joined
)'



############################ POWERLEVEL9K SETTINGS #############################

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT=1
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"   # ╭─
# POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{blue}\u251c\u2500%f" # ├─
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f "   # ╰❯
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=" %(?.%F{040}❯%f.%F{196}❯%f) "

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    root_indicator  dir_writable_joined  dir_joined  newline
    context  command_execution_time  status  newline
    node_version  nvm  chruby  php_version  virtualenv  pyenv
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    vcs_joined  background_jobs  time  os_icon
)
# ==============================================================================


# ==== [ Background Jobs segment ] =============================================
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="clear"
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=114          # palegreen3a (verde mavam)
POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE_ALWAYS=true


# ==== [ Command Execution Time segment ] ======================================
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="clear"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=magenta                     # 005
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0


# ==== [ Context segment ] =====================================================
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="clear"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=013           # fuchsia (bright magenta)

POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="clear"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=214              # orange1, alt:226 yellow1

POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND="clear"
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND=""

POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND="clear"
POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=""
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND="clear"
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=""
POWERLEVEL9K_CONTEXT_TEMPLATE="$(print_icon USER_ICON) %n @ $(print_icon CONTEXT_ICON) %m"          # user @ hostname

POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true


# ==== [ Dir segment ] =========================================================
POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_FOREGROUND=blue                                      # 004
POWERLEVEL9K_HOME_ICON="$(print_icon 'HOME_ICON') "                          # 
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=blue                            # 004
POWERLEVEL9K_HOME_SUB_ICON="$(print_icon 'HOME_SUB_ICON') "                  # 
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=blue                                   # 004
POWERLEVEL9K_FOLDER_ICON="$(print_icon 'FOLDER_ICON') "                      # 
POWERLEVEL9K_DIR_ETC_BACKGROUND="clear"
POWERLEVEL9K_DIR_ETC_FOREGROUND=blue                                       # 004
POWERLEVEL9K_ETC_ICON="$(print_icon 'ETC_ICON') "                            # 

# POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
# POWERLEVEL9K_ALWAYS_SHOW_USER=true
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
# POWERLEVEL9K_SHORTEN_DELIMITER=""
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=""
# POWERLEVEL9K_DIR_PATH_HIGHLIGHT_BOLD=true

# POWERLEVEL9K_DIR_PATH_SEPARATOR_BACKGROUND="clear"
POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND=cyan                            # 006
POWERLEVEL9K_DIR_PATH_SEPARATOR="/"


# ==== [ Dir Writable segment ] ================================================
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="clear"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND=red          # 001, alt:160 red3a


# ==== [ Host segment ] ========================================================
POWERLEVEL9K_HOST_LOCAL_BACKGROUND="clear"
POWERLEVEL9K_HOST_LOCAL_FOREGROUND=013                # fuchsia (bright magenta)
POWERLEVEL9K_HOST_REMOTE_BACKGROUND="clear"
POWERLEVEL9K_HOST_REMOTE_FOREGROUND="magenta"
POWERLEVEL9K_HOST_ICON="\uF109 "          # Default pero con un espacio al final


# ==== [ IP segment ] ==========================================================
POWERLEVEL9K_IP_BACKGROUND=027                                     # dodgerblue2
# POWERLEVEL9K_IP_FOREGROUND="clear"


# ==== [ OS Icon segment ] =====================================================
POWERLEVEL9K_OS_ICON_BACKGROUND="clear"
POWERLEVEL9K_OS_ICON_FOREGROUND=white                                      # 015


# ==== [ Root Indicator segment ] ==============================================
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="clear"
POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=226            # yellow1 (amarillo chido), orig 001 red


# ==== [ SSH segment ] =========================================================
# POWERLEVEL9K_SSH_BACKGROUND=221           # lightgoldenrod2a (amarillo palido)
POWERLEVEL9K_SSH_FOREGROUND="clear"
# POWERLEVEL9K_SSH_ICON="\uF489"          # Default pero con un espacio al final


# ==== [ Status segment ] ======================================================
POWERLEVEL9K_STATUS_OK_BACKGROUND="clear"
POWERLEVEL9K_STATUS_OK_FOREGROUND=040                                  # green3a
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="clear"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND=196                                  # red1
# POWERLEVEL9K_STATUS_CROSS=false
POWERLEVEL9K_STATUS_OK=false
# POWERLEVEL9K_STATUS_SHOW_PIPESTATUS=true
# POWERLEVEL9K_STATUS_HIDE_SIGNAME=false


# ==== [ Time segment ] ========================================================
POWERLEVEL9K_TIME_BACKGROUND="clear"
POWERLEVEL9K_TIME_FOREGROUND=cyan                                          # 006
POWERLEVEL9K_TIME_FORMAT="%D{%I:%M %p}" # 00:00 PM
POWERLEVEL9K_TIME_12HR=true


# ==== [ User segment ] ========================================================
POWERLEVEL9K_USER_DEFAULT_BACKGROUND="clear"
POWERLEVEL9K_USER_DEFAULT_FOREGROUND=013              # fuchsia (bright magenta)
POWERLEVEL9K_USER_ICON="\uF415"                                 # user   default
# POWERLEVEL9K_ALWAYS_SHOW_USER=false
# POWERLEVEL9K_USER_TEMPLATE="%n"

POWERLEVEL9K_USER_ROOT_BACKGROUND="clear"
POWERLEVEL9K_USER_ROOT_FOREGROUND=009                               # bright red
POWERLEVEL9K_ROOT_ICON="\u26A1"                                 # rayito default

POWERLEVEL9K_USER_SUDO_BACKGROUND="clear"
POWERLEVEL9K_USER_SUDO_FOREGROUND=013                 # fuchsia (bright magenta)
POWERLEVEL9K_SUDO_ICON="\uF09C"                           # candado desbloqueado




#### Development Environment Segments ##########################################

# ==== [ VCS segment ] =========================================================
POWERLEVEL9K_VCS_CLEAN_BACKGROUND="clear"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND=070            # chartreuse3 (verde vcs chido)
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="clear"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow                                # 003
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="clear"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=130  # darkorange3 (naranja feo vcs), alt:166 darkorange3a
POWERLEVEL9K_SHOW_CHANGESET=true
# POWERLEVEL9K_CHANGESET_HASH_LENGTH=12
# POWERLEVEL9K_VCS_HIDE_TAGS=false
# POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)

## Don't check if submodules are dirty when showing vcs status
## This isn't important if I am not using VCS status
## (which is slow in the fs repo)
# POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY=false


POWERLEVEL9K_NODE_VERSION_BACKGROUND="clear"
POWERLEVEL9K_NODE_VERSION_FOREGROUND=green              # 002, alt:022 darkgreen
# POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_COLOR=green

POWERLEVEL9K_NVM_BACKGROUND="clear"
POWERLEVEL9K_NVM_FOREGROUND=green                       # 002, alt:022 darkgreen

POWERLEVEL9K_PHP_VERSION_BACKGROUND="clear"
POWERLEVEL9K_PHP_VERSION_FOREGROUND=099              # slateblue1 (morado chido)
# POWERLEVEL9K_PHP_VERSION_ICON="\uE608"

POWERLEVEL9K_VIRTUALENV_BACKGROUND="clear"
POWERLEVEL9K_VIRTUALENV_FOREGROUND=214                                 # orange1
# POWERLEVEL9K_VIRTUALENV_PROMPT_ALWAYS_SHOW="true"

POWERLEVEL9K_PYENV_BACKGROUND="clear"
POWERLEVEL9K_PYENV_FOREGROUND=185                      # khaki3, alt:214 orange1
# POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW="true"

POWERLEVEL9K_CHRUBY_BACKGROUND="clear"
POWERLEVEL9K_CHRUBY_FOREGROUND=166                                # darkorange3a
POWERLEVEL9K_CHRUBY_SHOW_ENGINE="false"
# POWERLEVEL9K_CHRUBY_SHOW_VERSION="true"
