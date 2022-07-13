#
# Shell Snippets
#


### Older way to define DOTFILES constant
## Throws error when hitting some folders at ~/Library or constant error and shit
DOTFILES="$(find "$HOME" -maxdepth 3 -name ".dotfiles" -type d -print0 -quit)"
DOTFILES="$(find "$HOME" -maxdepth 3 -name ".dotfiles" -type d -print0 -quit 2> /dev/null)"

### Older way to define PUNTO_SH constant
## Throws error when hitting some folders at ~/Library or constant error and shit
PUNTO_SH="$(find "$HOME" -maxdepth 3 -name ".punto-sh" -type d -print0 -quit)"
PUNTO_SH="$(find "$HOME" -maxdepth 3 -name ".punto-sh" -type d -print0 -quit 2> /dev/null)"

### Older way to define PUNTO constant
## Throws error when hitting some folders at ~/Library or constant error and shit
PUNTO="$(find "$HOME" -maxdepth 3 -name ".punto" -type d -print0 -quit)"
PUNTO="$(find "$HOME" -maxdepth 3 -name ".punto" -type d -print0 -quit 2> /dev/null)"


### Better way to define constants, but is not portable :(, so I can't use it on scripts
DOTFILES="$(fd -g ".dotfiles" "$HOME" -HI --maxdepth 3 --type d -E "Library" --max-results 1)"
PUNTO_SH="$(fd -g ".punto-sh" "$HOME" -HI --maxdepth 3 --type d -E "Library" --max-results 1)"
   PUNTO="$(fd -g ".punto" "$HOME" -HI --maxdepth 3 --type d -E "Library" --max-results 1)"


if command -v fd > /dev/null 2>&1;
then
  DOTFILES="$(fd -g ".dotfiles" "$HOME" -HI --maxdepth 3 --type d -E "Library" --max-results 1)"
else
  DOTFILES="$(find "$HOME" -maxdepth 3 -name ".dotfiles" -type d -print0 -quit 2> /dev/null)"
fi

DOTFILES="$(realpath "$0" | grep -Eo '^.*?\.dotfiles')" ## -o: only matching
PUNTO_SH="$(realpath "$0" | grep -Eo '^.*?\.punto-sh')" ## -o: only matching
PUNTO="$(realpath "$0" | grep -Eo '^.*?\.punto')" ## -o: only matching

. "$PUNTO_SH/scripts/functions/helpers.sh" || {
	printf "%b\n\n" "\033[38;31mError: helper functions not found! Aborting...\033[0m"
	echo; exit 1
}



## 1
### Keeps sudo privilege alive throughout the execution of this script.
## https://github.com/mavam/dotfiles/blob/master/bootstrap#L34
if ! sudo -n true 2> /dev/null; then
	echo "Please enter your password to maintain a sudo session"
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &
fi

## 2
### Enter Sudo mode and mantain the session open
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &

## 3
### Kill ourself with SIGINT upon receiving SIGINT
## trap - INT restores default INT handler
trap 'trap - INT; kill -s INT "$$"' INT

## 4
### Keeps sudo privilege alive throughout the execution of this script.
if ! sudo -n true 2> /dev/null; then
	echo; option "Please enter your password to maintain a sudo session"
	sudo -v
	saferun sudo echo "Authentication successful!"
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &
	echo
fi




### Syntax snippet: Yes/No/Skip Case

option ""
subopt "Do you.." \
"...?"
suboptq "Choose one option ['Y'es|'n'o][press Enter key to halt]: "
suboptq "Choose one option [${BO}'Y'es${NO}|${BO}'n'o${NO}][press ${BO}Enter key${NO} to halt]: "
read -r resp


case "$resp" in
	y|Y|yes|Yes)
		true
	;;
	no|No|"skip"|"Skip"|"none"|"None"|"")
		warn "Skipping this step!"
		return
	;;
	*)
		error "Invalid choice! Aborting..."
		echo; exit 1
	;;
esac




subopt "Choose one option: ['opt1'|'opt2'|'opt3'|'opt4'|'opt5'|'opt6']"
subopt "Choose one option: [${BO}'opt1'${NO}|${BO}'opt2'${NO}|${BO}'opt3'${NO}|${BO}'opt4'${NO}|${BO}'opt5'${NO}|${BO}'opt6'${NO}]"
read -r resp

subopt "Choose one option: ['opt1'|'opt2'|'opt3'|'opt4'|'opt5'|'opt6']"
subopt "Choose one option: [${BO}'opt1'${NO}|${BO}'opt2'${NO}|${BO}'opt3'${NO}|${BO}'opt4'${NO}|${BO}'opt5'${NO}|${BO}'opt6'${NO}]"
subopt "or ['skip'|'none'][press Enter key] to halt."
subopt "or [${BO}'skip'${NO}|${BO}'none'${NO}][press ${BO}Enter key${NO}] to halt."
suboptq "" && read -r resp

# ------------------------------------------------------------------------------

subopt "Choose one option from the list..."
suboptq "(to halt [type 'skip'|'none'] or [press Enter key]): "
suboptq "(to halt [type ${BO}'skip'${NO}|${BO}'none'${NO}] or [press ${BO}Enter key${NO}]): "
read -r resp

subopt "Choose one option from the list..."
subopt "or [type 'skip'|'none'][press Enter key] to halt."
subopt "or [type ${BO}'skip'${NO}|${BO}'none'${NO}][press ${BO}Enter key${NO}] to halt."
suboptq "> " && read -r resp

subopt "Choose one option from the list..."
subopt "or ['skip'|'none'][Enter key] to halt."
subopt "or [${BO}'skip'${NO}|${BO}'none'${NO}][${BO}Enter key${NO}] to halt."
suboptq "> " && read -r resp


case "$resp" in
	"opt1")
		true
	;;
	"opt2")
		true
	;;
	"skip"|"Skip"|"none"|"None"|"")
		warn "Skipping this step!"
	;;
	*)
		error "Invalid choice! Aborting..."
		echo; exit 1
	;;
esac


printf "%b" "$SOA" " Choose one option [Y/n/skip]: " "$RE"

### OSTYPE (It's not POSIX)
case "$OSTYPE" in
	darwin*|freebsd*)   ## For Linux: linux-gnu
		echo "$OSTYPE"
	;;
esac

## POSIX
if [ "$(uname -s)" = "Darwin" ] || [ "$(uname -s)" = "FreeBSD" ]; then
	uname -s
else
	echo "no compila"
fi
## Ksh-like (bash, zsh)
if [ "$OSTYPE" =~ (darwin|freebsd)* ]; then
	echo "$OSTYPE"
else
	echo "no compila"
fi



### Arch Distro option
case "$( sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/*release )" in
	"Arch") echo "Arch" ;;
	"Manjaro") echo "Manjaro" ;;
	"Ubuntu") echo "Ubuntu" ;;
	*)
		error "Distro not supported! Aborting..."
		echo; exit 126
	;;
esac

case "$DISTRO" in
	"Arch" | "Manjaro")
		zsh "$PUNTO_SH/scripts/archlinux.sh" ;;
	*)
		error "${DISTRO} not supported! Aborting..."
		echo; exit 126
	;;
esac



### Input If Statement for the Option Questions to type "Enter to skip"
if [ -n "$resp" ]; then
	funct "$resp"
else
	warn "Skipping this step!"
fi
# And then here, goes a case statement



### Print Distro
distro_exists() {
	sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/*release > /dev/null 2>&1
}

if [ "$(sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/*release)" = "Arch Linux" ]; then
	echo
else
	echo
fi



### Command Exists
if command_exists ruby ; then
	echo
else
	error "Binary not found! Aborting..."
	echo; exit 126
fi



### Grep Pipe command to Except git folder
## grep -v: Select lines that don't match any specified pattern
for file in $( find "$DOTFILES/home" -type f | grep -Ev '.zsh' ); do
	ln -fsv "$file" "$HOME"
done
( ... | grep -Ev '\.git$'|'\<folder>'|'<file>' )







### Parse arguments
while [ "$#" -gt 0 ]; do
	case $1 in
		"--unattended") ZSHRC=no; CHSH=no; RUNZSH=no
		;;
		"--only-zshrc") setup_zshrc; return
		;;
		"--only-chsh") OHMYZSH=no; ZSHRC=no; RUNZSH=no
		;;
		"--only-zshrc-chsh") OHMYZSH=no; RUNZSH=no
		;;
		"--skip-clone") OHMYZSH=no
		;;
		"--skip-zshrc") ZSHRC=no
		;;
		"--skip-chsh") CHSH=no
		;;
		"--skip-runzsh") RUNZSH=no
		;;
	esac
	shift
done




## Leave Pyenv fourth in the PATH because I don't use Python that much
if [ -d "$HOME"/.pyenv ]; then
	export PYENV_ROOT="$HOME"/.pyenv
	export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:${PATH}"
	## eval "$(pyenv init -)"
	## eval "$(pyenv virtualenv-init -)"
fi

## Leave NVM third in the PATH, just because i'll use Node more than Python
if [ -d "$HOME"/.nvm ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR"/nvm.sh ] && . "$NVM_DIR"/nvm.sh
	[ -s "$NVM_DIR"/bash_completion ] && . "$NVM_DIR"/bash_completion
fi



PS3='Please enter your choice: '
options=("Disable GateKeeper" "Enable GateKeeper" "Allow Single-App to Bypass GateKeeper" "Self-Sign An App" "Quit")
select opt in "${options[@]}"; do
true
done



jot -w %i -r 1 1 6
RandomTheme=$(jot -w %i -r 1 1 3)
echo "$RandomTheme"



source /Users/dievilz/.nvm/nvm.sh
nvm --version
command -v nvm



nodeDescript[0]='Installing AdonisJs CLI Scaffolding Helper'               nodePackages[0]=@adonisjs/cli;
nodeDescript[1]='Installing Vue.js CLI Scaffolding Helper'                 nodePackages[1]=@vue/cli;
nodeDescript[2]='Installing Vue.js CLI Old Scaffolding Helper'             nodePackages[2]=@vue/cli-init;
nodeDescript[3]='Installing React Scaffolding Helper'                      nodePackages[3]=create-react-app;
nodeDescript[4]='Installing ESlint, a JavaScript Linter Tool'              nodePackages[4]=eslint;
nodeDescript[5]='Installing Gulp, a task manager and build system toolkit' nodePackages[5]=gulp;
nodeDescript[6]='Installing ndb, a Debugger enabled by Chrome DevTools'    nodePackages[6]=ndb;
nodeDescript[7]='Installing vtop, a Node-enabled Activity Monitor'         nodePackages[7]=vtop;

## Mejor esta version...
for K in "${!nodeDescript[@]}"; do
	echo; subopt "${nodeDescript[K]}"
	echo "npm install -g ${nodePackages[K]}"
done

# ...Que esta
# for (( I=0; $I < nodeDescript[@]; I+=1 )); do
# 	echo; subopt "${nodeDescript[I]}"
# 	echo "npm install -g ${nodePackages[I]}"
# done





## Use this code when you want to match any shell
case "$(ps -o args= -p $$ | egrep -m 1 -o '\b\w{0,6}sh|koi')" in
	"zsh")
		sqlPkg=$(whence -p mysql)
	;;
	*) sqlPkg=$(type -P mysql) ;;
esac

## Use this code when you want to match against an specific shell
if [ -z "$(ps -o args= -p $$ | egrep -m 1 -q '\b(bash|sh)')" ]; then
	true
fi





## Looping en un directorio con un archivo respectivo a un usuario normal y otro root
while IFS= read -r -d '' zrc; do
	# printf "%s\n" $zrc
	case "$(id -u)" in
		0) # Root
			if [[ "$zrc" == *"user"* ]]; then
				break
			fi
		;;
		*) # User
			if [[ "$zrc" == *"root"* ]]; then
				break
			fi
		;;
	esac
	zshrcsFound+=("$zrc")
done < <(find "$DOTFILES/home/config/zsh" -maxdepth 3 -name "*.zshrc*" -type f -print0)


## Get all the available Zshrc files variants of my Dotfiles
while IFS= read -r -d '' dotsZrcPath; do
	dotsZrcFile="$(basename -- "$dotsZrcPath")"
	# case $dotsZrcFile in
		# "etc"*) break;;
		# "zdotdir"*)
			(for e in "${dotsZrcsFound[@]}"; do [ "$e" = "default.zshrc" ] && exit 0; done) && matched="found" || matched="not found"
			if [ "$matched" = "found" ]; then
				break
			else
				dotsZrcFile="default.zshrc"
			fi
	# 	;;
	# esac
	dotsZrcsFound+=("$dotsZrcFile")
done < <(find "$DOTFILES/home/config/zsh" -maxdepth 3 -name "*.zshrc*" -type f -print0)










# osascript -e 'do shell script "touch Untitled" with administrator privileges'

### How to create a File at Window (Reworked for sudo touch)
for dir in "$@"; do
	CuUSER="$HOME"
	CuGROUP="$(id -gn)"

	if [[ -d "$dir" ]]; then
		cd "$dir" || fails
	fi

	oldDirPerms="$(/opt/pkg/bin/gstat -c "%a" "$dir")"

	if [[ ! -f "Untitled" ]]; then
		if [ -w "$dir" ]; then
			touch Untitled
		else
			chmod -v 755 "${dir}"
			touch Untitled
			# chown -v "${CuUSER}":"${CuGROUP}" Untitled
			chmod -v "${oldDirPerms}" "${dir}"
		fi
	else
		x=1
		while :; do
			FILEN="Untitled ${x}"
			if [[ ! -f "$FILEN" ]]; then
				if [ -w "$dir" ]; then
					touch "$FILEN"
				else
					chmod -v 755 "${dir}"
					touch "$FILEN"
					# chown -v "${CuUSER}":"${CuGROUP}" "$FILEN"
					chmod -v "${oldDirPerms}" "${dir}"
				fi
				break ### To prevent a loop once the wanted file is created
			fi
			x=$(( x + 1 ))
		done
	fi
done

### How to create a File at Selection (Reworked for sudo touch)
for dir in "$@"; do
	CuUSER="$($HOME)"
	CuGROUP="$(id -gn)"

	if [[ -d "$dir" ]]; then
		cd "$dir" || fails

	elif [[ -f "$dir" ]]; then
		dir="$(dirname "$dir")"
		cd "$dir" || fails
	fi

	oldDirPerms="$(/opt/pkg/bin/gstat -c "%a" "$dir")"

	if [[ ! -f "Untitled" ]]; then
		if [ -w "$dir" ]; then
			touch Untitled
		else
			chmod -v 755 "${dir}"
			touch Untitled
			# chown -v "${CuUSER}":"${CuGROUP}" Untitled
			chmod -v "${oldDirPerms}" "${dir}"
		fi
	else
		x=1
		while :; do
			FILEN="Untitled ${x}"
			if [[ ! -f "$FILEN" ]]; then
				if [ -w "$dir" ]; then
					touch "$FILEN"
				else
					chmod -v 755 "${dir}"
					touch "$FILEN"
					# chown -v "${CuUSER}":"${CuGROUP}" "$FILEN"
					chmod -v "${oldDirPerms}" "${dir}"
				fi
				break ### To prevent a loop once the wanted file is created
			fi
			x=$(( x + 1 ))
		done
	fi
done



### How to create a File at Window (Original and Working)
for dir in "$@"; do

	if [[ -d "$dir" ]]; then
		cd "$dir"
	fi

	if [[ ! -f "Untitled" ]]; then
		touch Untitled
	else
		x=1
		while :; do
			FILEN="Untitled ${x}"
			if [[ ! -f "$FILEN" ]]; then
				touch "$FILEN"
				break
			fi
			x=$(( $x + 1 ))
		done
	fi
done


### How to create a File at Selection (Original and Working)
for dir in "$@"; do

	if [[ -d "$dir" ]]; then
		cd "$dir"

	elif [[ -f "$dir" ]]; then
		cd "$(dirname "$dir")"
	fi

	if [[ ! -f "Untitled" ]]; then
		touch Untitled
	else
		x=1
		while :; do
			FILEN="Untitled ${x}"
			if [[ ! -f "$FILEN" ]]; then
				touch "$FILEN"
				break
			fi
			x=$(( $x + 1 ))
		done
	fi
done





##################### DOTFILES ALIASES #####################

######## LESS CONFIGURATION ########
############ VI MODE #############
###### WINDOW TITLE #######
### THEMING AUTOLOADING ###



#=============== VI MODE ==================
#======= THEMING AUTO/TAB COMPLETE ========



################################### PLUGINS ####################################
################################### THEMES #####################################
################################### OPTIONS ####################################
############################## USER CONFIGURATION ##############################
################################# COMPLETION ###################################
################################# KEYBINDINGS ##################################
##################### SYNTAX HIGHLIGHTING; Should be last ######################











### Zsh Sessions backup

## Useful support for interacting with Terminal.app or other terminal programs:
## As this is the last line to run, if false, <[> return an exit code 1
# [ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"

if [ "$(uname -s)" = "Darwin" ] && [ -r "/etc/zshrc_$TERM_PROGRAM" ]; then
   . "/etc/zshrc_$TERM_PROGRAM"
fi

### Bash Sessions backup

## Useful support for interacting with Terminal.app or other terminal programs:
## As this is the last line to run, if false, <[> return an exit code 1
# [ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
# [ -r "/etc/bash.bashrc_$TERM_PROGRAM" ] && . "/etc/bash.bashrc_$TERM_PROGRAM"

if [ "$(uname -s)" = "Darwin" ] && [ -r "/etc/bash.bashrc_$TERM_PROGRAM" ]; then
   . "/etc/bash.bashrc_$TERM_PROGRAM"
fi














##################### SYNTAX HIGHLIGHTING; Should be last ######################
custom_defined() {
	## My recommended setting: define where are you going to place your Zsh host plugins in your
	## /etc/zshenv. If you haven't, go set them and then come back
	if [ -d "$ZSH_PLUGINS" ]; then
		if [ -f "$ZSH_PLUGINS/$ZSH_SYNTAX_HIGHL" ]; then
			. "$ZSH_PLUGINS/$ZSH_SYNTAX_HIGHL" && export SYNTAX_HIGHL_ENABLED=true
		fi

		if [ -f "$ZSH_PLUGINS/$ZSH_AUTOSUGGESTION" ]; then
			. "$ZSH_PLUGINS/$ZSH_AUTOSUGGESTION" && export AUTOSUGGESTION_ENABLED=true
		fi

		if [ -f "$ZSH_PLUGINS/$ZSH_HISTORY_SEARCH" ]; then
			. "$ZSH_PLUGINS/$ZSH_HISTORY_SEARCH" && export HISTORY_SEARCH_ENABLED=true
		fi
	fi
}

recurse() {
	## zsh-users Recommended folder to place their plugins
	if find /usr/local/share -maxdepth 1 -name "zsh-*" -type d 2>/dev/null; then
		if [ -f /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
			. /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
			&& export SYNTAX_HIGHL_ENABLED=zsh-users
		fi

		if [ -f /usr/local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
			. /usr/local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
			&& export AUTOSUGGESTION_ENABLED=zsh-users
		fi

		if [ -f /usr/local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
			. /usr/local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh \
			&& export HISTORY_SEARCH_ENABLED=zsh-users
		fi

	## Some OSes may use this folder
	elif find /usr/share/zsh/plugins -maxdepth 1 -name "zsh-*" -type d 2>/dev/null; then
		if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
			. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
			&& export SYNTAX_HIGHL_ENABLED=zsh-users
		fi

		if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
			. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
			&& export AUTOSUGGESTION_ENABLED=zsh-users
		fi

		if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
			. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh \
			&& export HISTORY_SEARCH_ENABLED=zsh-users
		fi
	fi
}
