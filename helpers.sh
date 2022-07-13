#!/bin/bash
#
# Set of shell function helpers to simplify code
#
# By Diego Villarreal, @dievilz in GitHub (https://github.com/dievilz)


## Exporting DOTFILES,PUNTO_SH & PUNTO path to locate them in other scripts
if command -v fd > /dev/null 2>&1;
then
  if [ ! -d "$DOTFILES" ] || [ -z "$DOTFILES" ]; then
   DOTFILES="$(fd -g ".dotfiles" "$HOME" -HI --maxdepth 3 --type d -E "Library" -E "Trash" --max-results 1)"
  fi

  if [ ! -d "$PUNTO_SH" ] || [ -z "$PUNTO_SH" ]; then
   PUNTO_SH="$(fd -g ".punto-sh" "$HOME" -HI --maxdepth 3 --type d -E "Library" -E "Trash" --max-results 1)"
  fi

  if [ ! -d "$PUNTO" ] || [ -z "$PUNTO" ]; then
      PUNTO="$(fd -g ".punto" "$HOME" -HI --maxdepth 3 --type d -E "Library" -E "Trash" --max-results 1)"
  fi
else
  if [ ! -d "$DOTFILES" ] || [ -z "$DOTFILES" ]; then
   DOTFILES="$(find "$HOME" -maxdepth 3 -name ".dotfiles" -type d -print -quit 2> /dev/null)"
  fi

  if [ ! -d "$PUNTO_SH" ] || [ -z "$PUNTO_SH" ]; then
   PUNTO_SH="$(find "$HOME" -maxdepth 3 -name ".punto-sh" -type d -print0 -quit 2> /dev/null)"
  fi

  if [ ! -d "$PUNTO" ] || [ -z "$PUNTO" ]; then
      PUNTO="$(find "$HOME" -maxdepth 3 -name ".punto" -type d -print0 -quit 2> /dev/null)"
  fi
fi
export DOTFILES
export PUNTO_SH
export PUNTO


## Exporting Punto's Bin folder to $PATH so /usr/local/bin is not necessary anymore
export PATH="$PUNTO_SH/bin:${PATH}"


command_exists() {
	command -v "$@" > /dev/null 2>&1
}

## The [ -t 1 ] check only works when the function is not called from
## a subshell (like in `$(...)` or `(...)`, so this hack redefines the
## function at the top level to always return false when stdout is not
## a tty.
if [ -t 1 ]; then
	is_tty() {
		true
	}
else
	is_tty() {
		false
	}
fi

setup_colors() {
	## Only use colors if connected to a terminal
	if is_tty; then
		   K='\033[38;30m'   ##  KEY (BLACK)
		   R='\033[38;31m'   ##  RED
		   G='\033[38;32m'   ##  GREEN
		   Y='\033[38;33m'   ##  YELLOW
		   B='\033[38;34m'   ##  BLUE
		   M='\033[38;35m'   ##  MAGENTA
		   C='\033[38;36m'   ##  CYAN
		   W='\033[38;37m'   ##  WHITE
		  BK='\033[38;90m'   ##  BRIGHT KEY
		  BR='\033[38;91m'   ##  BRIGHT RED
		  BG='\033[38;92m'   ##  BRIGHT GREEN
		  BY='\033[38;93m'   ##  BRIGHT YELLOW
		  BB='\033[38;94m'   ##  BRIGHT BLUE
		  BM='\033[38;95m'   ##  BRIGHT MAGENTA
		  BC='\033[38;96m'   ##  BRIGHT CYAN
		  BW='\033[38;97m'   ##  BRIGHT WHITE
		 NRB='\033[25m'      ##  NO RAPID BLINKING
		 NSB='\033[25m'      ##  NO SLOW BLINKING
		 NUL='\033[24m'      ##  NO UNDERLINED
		 NBL='\033[23m'      ##  NO BLACKLETTER
		 NIT='\033[23m'      ##  NO ITALIC
		 NDM='\033[22m'      ##  NO DIM (NORMAL)
		 NBO='\033[22m'      ##  NO BOLD (NORMAL)
		  RB='\033[6m'       ##  RAPID BLINK
		  SB='\033[5m'       ##  SLOW BLINK
		  UL='\033[4m'       ##  UNDERLINED
		  IT='\033[3m'       ##  ITALIC
		  DM='\033[2m'       ##  DIM
		  BO='\033[1m'       ##  BOLD
		  RE='\033[0m'       ##  RESET ALL
	else
		   K=''
		   R=''
		   G=''
		   Y=''
		   B=''
		   M=''
		   C=''
		   W=''
		  BK=''
		  BR=''
		  BG=''
		  BY=''
		  BB=''
		  BM=''
		  BC=''
		  BW=''
		 NRB=''
		 NSB=''
		 NUL=''
		 NIT=''
		 NBL=''
		 NDM=''
		 NBO=''
		  RB=''
		  SB=''
		  UL=''
		  IT=''
		  DM=''
		  BO=''
		  RE=''
	fi

	 OA="${M}>${R}>${Y}>${B}"  ## Option Arrow
	SOA="${C}-->"              ## SubOption Arrow
	TOA="${BM}-->"             ## ThirdOption Arrow
	FOA="${M}-->"             ## ThirdOption Arrow
}

setup_colors

########### Arrows
	option() {
		is_tty && printf "%b %b%b\n" "${OA}"  "$*" "${RE}" || printf "%b\n" "$*"
	}
	subopt() {
		is_tty && printf "%b %b%b\n" "${SOA}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	trdopt() {
		is_tty && printf "%b %b%b\n" "${TOA}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	frtopt() {
		is_tty && printf "%b %b%b\n" "${FOA}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	suboptq() {
		is_tty && printf "%b %b%b" "${SOA}" "$*" "${RE}" || printf "%b" "$*"
	}
	trdoptq() {
		is_tty && printf "%b %b%b" "${TOA}" "$*" "${RE}" || printf "%b" "$*"
	}
	frtoptq() {
		is_tty && printf "%b %b%b" "${FOA}" "$*" "${RE}" || printf "%b" "$*"
	}
	dimcode() {   ## shellcheck disable=SC2016 # backtick in single-quote
		is_tty && printf '%b`%s%`%b\n' ${DM} "$*" "${NBD}" || printf '`%b`\n' "$*"
		# is_tty && printf '`%b%s%b`\n' ${DM} "$*" "${NBD}" || printf '`%b`\n' "$*"
		# is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%b`\n' "$*"
	}
	success() {
		is_tty && printf "%b==> %b%b\n" "${G}" "$*" "${RE}" || printf "==> %b\n" "$*"
	}
	error() {
		is_tty && printf "%b==> Error: %b%b\n" "${UL}${R}" "$*" "${RE}" 1>&2 || printf "==> Error: %b\n" "$*" 1>&2
	}
	warn() {
		is_tty && printf "%b==> Warning: %b%b\n" "${Y}" "$*" "${RE}" || printf "==> Warning: %b\n" "$*"
	}
	info() {
		is_tty && printf "%b==> Note: %b%b\n" "${B}" "$*" "${RE}" || printf "==> Note: %b\n" "$*"
	}

########### Colored output
	red() {
		is_tty && printf "%b%b%b\n" "${R}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	green() {
		is_tty && printf "%b%b%b\n" "${G}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	yellow() {
		is_tty && printf "%b%b%b\n" "${Y}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	blue() {
		is_tty && printf "%b%b%b\n" "${B}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	magenta() {
		is_tty && printf "%b%b%b\n" "${M}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	cyan() {
		is_tty && printf "%b%b%b\n" "${C}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	bold() {
		is_tty && printf "%b%b%b\n" "${BO}" "$*" "${RE}" || printf "%b\n" "$*"
	}
	reset() {
		is_tty && printf "%b%b\n" "${RE}" "$*" || printf "%b\n" "$*"
	}

## Safe run function to ensure commands are executed successfully
saferun() {
	typeset cmnd="$*"
	typeset ret_code

	eval  "$cmnd"
	ret_code=$?

	if [ "$ret_code" != 0 ];
	then
		error "${UL}It looks like there was an issue running:${NUL} $*" \
		"\nExit code: $ret_code."
		exit $?
	fi
}

### Kill ourself with SIGINT upon receiving SIGINT
halt_shcript() {
	### trap - INT restores default INT handler
	trap 'trap - INT; kill -s INT "$$"' INT
}

## Keeps sudo privilege alive throughout the execution of this script.
enter_sudo_mode() {
	if ! sudo -n true 2> /dev/null; then
		option "Please enter your password to maintain a sudo session"
		sudo -v
		saferun sudo echo "Authentication successful!"
		while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
		echo
	fi
}

if_bin_exists() {
	if command_exists "$1" ; then
		success "$1 found!"
	else
		error "$1 not found! Aborting..."
		echo; exit 126
	fi
}

isDistro() {
	## Ensure the user is running this script on macOS
	if [ "$(uname -s)" != "Linux" ] && [ "$(uname -s)" != "GNU" ]; then   ## system/kernel POSIX
		error "This script is for use with GNU or Linux only! Aborting..."
		echo; return # 1
	fi

	case "$(uname -s)" in
		"Linux")
			DISTRO=$(sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/*release)
			export DISTRO
		;;
	esac
}

isMacos() {
	## Ensure the user is running this script on macOS
	if [ "$(uname -s)" != "Darwin" ]; then   ## system/kernel POSIX
		error "This script is for use with macOS only! Aborting..."
		echo; return # 1
	fi

	## Ensure the user is running this script on machines with Intel SoCs or Apple Silicon
	case "$(uname -m)" in   ## machine POSIX
		"x86_64"|"i386"|"arm64") true ;;
		*)
			error "Please run this script only in machines with Intel" \
			"processors or Apple Silicon! Aborting..."
			echo; return # 1
		;;
	esac

	## Ensure script is not being run with root privileges
	if [ "$(id -u)" -eq 0 ]; then
		error "Please don't run this script with root privileges! Aborting..."
		echo; return # 1
	fi
}
