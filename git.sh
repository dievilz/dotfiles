#!/bin/bash
#
# Git Configuration and Authentication Script
#
# By Diego Villarreal, @dievilz in GitHub (https://github.com/dievilz)


## Exporting DOTFILES location to source helper functions
DOTFILES="$(realpath "$0" | grep -Eo '^.*?\.dotfiles')" ## -o: only matching
. "$DOTFILES/helpers.sh" || {
	printf "%b\n\n" "\033[38;31mError: helper functions not found! Aborting...\033[0m"
	echo; exit 1
}


################################## GIT CONFIG ##################################

setup_config_git() \
{
	option "Configuring Git"

	[ ! -w "$HOME" ] && chmod 0755 "$HOME"

	local localConfig
	localConfig="$(fd -g ".gitconfig" "$HOME" -HI --maxdepth 2 \
		-E "Library" -E ".dotfiles" -E ".git" -E ".Trash" --max-results 1)"

	if [ -n "$localConfig" ];
	then
		success "A .gitconfig file was found: $localConfig"
	else
		warn "No .gitconfig file could be found!"
	fi
	echo

	subopt "Listing Git configuration files at \$XDG_CONFIG_HOME/git:"
	find "${XDG_CONFIG_HOME:-$HOME/.config}/git" -name "*.gitconfig" -type f
	echo

	trdopt "Do you want to: 1) create a new .gitconfig file, 2) change current" \
	"one with another .gitconfig at \$XDG_CONFIG_HOME/git, or skip this step?"
	trdopt "Choose one option: [${BO}'n'ew${NBD}|${BO}'c'hange${NBD}]"
	trdopt "or [${BO}'skip'${NBD}|${BO}'none'${NBD}][press ${BO}Enter key${NBD}] to halt"
	trdoptq "" && read -r resp
	case "$resp" in
		"n"|"new")
			echo
			## To delete any present .gitconfig symlink and not overwrite the target
			check_config_issues_git
			make_config_git
		;;
		"c"|"change")
			echo
			change_config_git
		;;
		no|No|"skip"|"Skip"|"none"|"None"|"")
			warn "Skipping this step!"
		;;
		*)
			error "Invalid choice! Aborting..."
			echo; exit 126
		;;
	esac
	echo
}

check_config_issues_git() \
{
	subopt "Fixing possible issues with current Git configs..."
	echo

	oldConfigOwner="$(grep -Po '(?<=^\tname = )\w*$' "$localConfig")"

	if [ -h "$localConfig" ] && [ ! -e "$localConfig" ];
	then
		# warn "The found git config file is a broken symlink! Time for" \
		# "removing it..."

		rm "$localConfig"
		# echo

	elif [ -h "$localConfig" ] && [ -e "$localConfig" ];
	then
		# if cmp -s "$localConfig" "${XDG_CONFIG_HOME:-$HOME/.config}/git/$oldConfigOwner.gitconfig";
		# then
		# 	warn "The current .gitconfig is a symlink to an already backed up" \
		# 	"config file at $XDG_CONFIG_HOME/git! Removing symlink..."

			rm "$localConfig"
		# 	echo
		# fi

	elif [ -f "$localConfig" ] && \
	[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/git/$oldConfigOwner.gitconfig" ];
	then
		warn "The current .gitconfig is not registered in our" \
		"\$XDG_CONFIG_HOME/git folder! Time for backing it up..."

		mv -v "$localConfig" \
		"${XDG_CONFIG_HOME:-$HOME/.config}/git/$oldConfigOwner.gitconfig"
		echo

	elif [ -f "$localConfig" ] && \
	[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/git/$oldConfigOwner.gitconfig" ];
	then
		if cmp -s "$localConfig" "${XDG_CONFIG_HOME:-$HOME/.config}/git/$oldConfigOwner.gitconfig";
		then
			warn "The current .gitconfig is apparently backed up at" \
			"$XDG_CONFIG_HOME/git! Removing normal file..."

			rm -v "$localConfig"
			echo
		fi
	fi
}

change_config_git() \
{
	while IFS= read -r -d '' gdirConfigPath; do
		gdirConfigFile="$(basename -- "$gdirConfigPath")"
		gdirConfigFound+=("$gdirConfigFile")
	done < \
	<(find "${XDG_CONFIG_HOME:-$HOME/.config}/git" -name "*.gitconfig" -type f -print0)

	frtopt "Do you want to set a .gitconfig file? [Y/n]: "
	frtoptq "" && read -r resp
	case $resp in
		y|Y|yes|Yes)
			echo
			PS3='Choose the .gitconfig file to use: '
			select opt in "${gdirConfigFound[@]}"
			do
				## To delete any present .gitconfig that if it's a normal file
				## No worries with symlinks as the following <ln> forces the link
				echo; check_config_issues_git
				success "Setting ${Y}$opt${G} as the main config"
				ln -fsv "${XDG_CONFIG_HOME:-$HOME/.config}/git/$opt" "$HOME/.gitconfig"
				unset PS3
				return
			done
		;;
		n|N|no|No|"skip"|"Skip"|"none"|"None"|"")
			warn "Skipping this step!"
		;;
		*)
			error "Invalid choice! Aborting..."
			echo; return 1
		;;
	esac
}

make_config_git() \
{
	frtopt "Creating a new global .gitconfig file at $HOME..."

	echo; frtoptq "Enter your Git name: "
	read -r gitName
	[ -n "$gitName" ] && git config --global user.name "$gitName"

	echo; frtoptq "Enter your Git email: "
	read -r gitEmail
	[ -n "$gitEmail" ] && git config --global user.email "$gitEmail"

	## Aliases
		## git config --get-regexp alias
		git config --global alias.aliases "config --get-regexp alias"

		## git reset $(git commit-tree HEAD^{tree} -m "A new start")
		squashAll='!f(){ git reset $(git commit-tree HEAD^{tree} -m "${1:-A new start}");};f'
		git config --global alias.squashAll "${squashAll}"

		## git --no-pager log --name-status --decorate | perl -pe 's/\e\[0-9;]*m//g' > "$HOME/Desktop/log.txt"
		exportLog='!f(){ git --no-pager log --name-status --decorate'
		exportLog="${exportLog} | perl -pe 's/\e\[0-9;]*m//g' >"
		default='"${1:-$HOME/Desktop/log.txt}";};f'
		exportLog="${exportLog} ${default}"
		git config --global alias.exportLog "${exportLog}"

		git config --global alias.ammend "commit --amend "
		git config --global alias.logv "log --stat"
		git config --global alias.undoS "reset --soft HEAD~1"
		git config --global alias.undo "reset HEAD~1"
		git config --global alias.untrack "update-index --assume-unchanged "
		git config --global alias.reup "!f(){ git remote add upstream $1};f"
		git config --global alias.reupGH "!f(){ git remote add upstream git@github.com:$1/$2.git;};f"
		git config --global alias.reorg "!f(){ git remote add origin $1};f"
		git config --global alias.reorgGH "!f(){ git remote add origin git@github.com:$1/$2.git;};f"
	##

	git config --global color.ui always
	git config --global color.branch always
	git config --global color.diff always
	git config --global color.interactive always
	git config --global color.status always
	git config --global color.grep always
	git config --global color.pager true
	git config --global color.decorate always
	git config --global color.showbranch always

	git config --global color.status.added green
	git config --global color.status.changed yellow
	git config --global color.status.untracked 166

	git config --global commit.gpgsign false
	git config --global commit.template "$HOME"/.config/git/gitmessage

	## Convert CRLF to LF, but not turning back into CRLF again
	git config --global core.autocrlf input
	git config --global core.editor "subl -n -w"
	git config --global core.excludesFile "$HOME"/.config/git/ignore
	command_exists delta && git config --global core.pager delta || {
		git config --global core.pager "less -+$LESS -FNRS -x4"
	}
	## Don't consider trailing space change as a cause for merge conflicts
	git config --global core.whitespace trailing-space
	git config --global core.sshCommand "ssh \$SSH_CONFIG"


	if [ "$(uname -s)" = "Darwin" ];
	then
		git config --global credential.helper osxkeychain
	else
		case "$DISTRO" in
			"Arch")
				git config --global credential.helper archlinux-keyring ;;
			"Manjaro")
				git config --global credential.helper manjaro-keyring ;;
			*)
				echo
				error "$DISTRO not supported! Skipping setting a credential helper for Git" ;;
		esac
	fi

	git config --global filter.lfs.process "git-lfs filter-process"
	git config --global filter.lfs.required true
	git config --global gpg.program gpg

	command_exists delta && git config --global interactive.diffFilter "delta --color-only"

	## Use abbrev SHAs whenever possible/relevant instead of full 40 chars
	git config --global log.abbrevCommit true

	git config --global pull.rebase true

	## When pushing, also push tags whose commits/whatever are now reachable upstream
	git config --global push.followTags true

	## Sort tags as version numbers whenever applicable, so 1.10.2 is AFTER 1.2.0.
	git config --global tag.sort version:refname

	git config --global delta.line-numbers true
	git config --global delta.syntax-theme "Dracula"

	if [ "$(uname -s)" = "Darwin" ];
	then
		printf "%b" '\n\n# [diff]\n#\ttool = Kaleidoscope\n#\tcolorMoved = default\n# [difftool]\n#\tprompt = false\n[difftool "Kaleidoscope"]\n\tcmd = ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"\n' >> "$HOME"/.gitconfig
		printf "%b" '# [merge]\n#\ttool = Kaleidoscope\n# [mergetool]\n#\tprompt = false\n[mergetool "Kaleidoscope"]\n\tcmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot\n\n' >> "$HOME"/.gitconfig
		git config --global mergetool.Kaleidoscope.trustexitcode true
	fi

	echo

	if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/git/$gitName.gitconfig" ]; then
		success "Git config file successfully created! Moving it to" \
		"\$XDG_CONFIG_HOME/git/.gitconfig and symlinking it to \$HOME..."

		mv -v "$HOME/.gitconfig" "${XDG_CONFIG_HOME:-$HOME/.config}/git/$gitName.gitconfig"
	else
		warn "Looks like you already have a git config for the same Git user." \
		"\nPlease edit the former file, or delete/duplicate it manually." \
		"\nFor now, a symlink will be created from the present git config" \
		"to conform with the process managed by this script."

		rm -v "$HOME/.gitconfig"
	fi

	ln -fsv "${XDG_CONFIG_HOME:-$HOME/.config}/git/$gitName.gitconfig" "$HOME/.gitconfig"
	echo
}



##################################### SSH ######################################

setup_ssh_git() \
{
	option "Configuring SSH"

	local sshDir
	sshDir="$(fd -g "*ssh" "$HOME" -HI --maxdepth 3 --type d \
		-E "Library" -E ".dotfiles" -E ".config" -E ".etc" --max-results 1)"

	SSH_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/ssh"
	export SSH_CONFIG="-F ${XDG_CONFIG_HOME:-$HOME/.config}/ssh/ssh_config"

	if [ -e "$sshDir" ];
	then
		subopt "SSH folder found: $sshDir."

		if [ "$sshDir" = "$HOME/.ssh" ] && [ ! -h "$sshDir" ];
		then
			if [ ! -d "$SSH_HOME" ];
			then
				subopt "Moving old SSH folder content to: $SSH_HOME."
				mv -fv "$HOME/.ssh" "$SSH_HOME"
			fi
		fi
	else
		warn "SSH directory not found! Using $SSH_HOME"
		mkdir -pv "$HOME"/.local/share/ssh
	fi
	sshDir="$SSH_HOME"
	echo

	subopt "Listing existing SSH Keys in your machine"
	ls -Al "${sshDir}"; echo   # ls -Al para que no aparezcan los '.' y '..'

	subopt "Do you want to create a new SSH key or use an existing one for a SCM Hosting Provider?"
	subopt "Choose one option [${BO}'n'ew${NBD}|${BO}'e'xisting${NBD}]"
	subopt "or [${BO}'skip'${NBD}|${BO}'none'${NBD}][press ${BO}Enter key${NBD}] to halt"
	suboptq "" && read -r resp
	case "$resp" in
		"n"|"new")
			echo; create_ssh
		;;
		"e"|"existing")
			echo; copying_ssh
		;;
		no|No|"skip"|"Skip"|"none"|"None"|"")
			warn "Skipping this step!"
		;;
		*)
			error "Invalid choice! Aborting..."
			echo; exit 126
		;;
	esac
	echo
}

create_ssh_git() \
{
	trdopt "Creating new SSH key..."
	frtoptq "Enter your SCM Hosting Provider email: "
	read -r gitEmail
	frtoptq "Enter the name for the new SSH key [i.e. id_ed25519_<'username''Site'>]: "
	read -r sshKey

	ssh-keygen -t ed25519 -a 100 -C "$gitEmail" -f "$sshDir/$sshKey"; echo
	echo

	mv -v "$sshDir/$sshKey" "$sshDir/$sshKey.pk"
	echo

	if $(eval `ssh-agent -s`); then
		export SSH_CONFIG="-F ${XDG_CONFIG_HOME:-$HOME/.config}/ssh/ssh_config"

		if [ ! -d "$(dirname "$SSH_CONFIG")" ];
		then
			STRING="Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile $SSH_HOME/$sshKey.pk"

			if ! grep -Fqx "${STRING}" "$SSH_CONFIG"; then
				printf "%b" "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile $SSH_HOME/$sshKey.pk" >> "$SSH_CONFIG"
			fi
		fi

		ssh-add -K "$sshDir/$sshKey.pk" || {
			error "The SSH key couldn't get added! Aborting..."
			echo; return
		}
		echo

		copying_ssh
	fi
}

copying_ssh_git() \
{
	trdopt "Copying the contents of the $sshKey file to clipboard..."

	if [ -z "$sshKey" ];
	then
		frtoptq "Enter the filename for the new SSH key [i.e. id_rsa_<'username''Site'>]: "
		read -r sshKey
		echo
	fi

	case "$(uname -s)" in
		"Darwin")
			pbcopy < "$sshDir/$sshKey.pk"
		;;
		"GNU"|"Linux"|"FreeBSD")
			xclip -selection clipboard < "$sshDir/$sshKey.pk"
		;;
		*)
			error "$(uname -s) not supported! Skipping..."
			echo; exit 126
		;;
	esac

	success "Your new SSH Key is in your Clipboard, add it to your SCM Hosting" \
	"Provider account. When you finish, come back and, i.e. type ${DM}'ssh -T git@github.com'${NBD}"
}



##################################### GPG ######################################

setup_gpg_git() \
{
	option "Configuring GPG"

	if [ -n "$GNUPGHOME" ]; then
		subopt "Listing existing GPG Keys in your machine"

		gpg --list-secret-keys --keyid-format LONG
	else
		error "There is no GPG directory. Aborting..."
		echo; exit 1
	fi

	subopt "Do you want to create a new GPG key or use an existing one for your" \
	"SCM Hosting Provider?"
	subopt "Choose one option [${BO}'n'ew${NBD}|${BO}'e'xisting${NBD}]"
	subopt "or [${BO}'skip'${NBD}|${BO}'none'${NBD}][press ${BO}Enter key${NBD}] to halt"
	suboptq "" && read -r resp
	case "$resp" in
		no|No|"skip"|"Skip"|"none"|"None"|"")
			warn "Skipping this step!"
		;;
		"n"|"new")
			echo
			trdopt "Generating GPG key. Accept the following default options by pressing Enter key"
			echo; gpg --full-generate-key

			armor_gpg
		;;
		"e"|"existing")
			echo; armor_gpg
		;;
		*)
			error "Invalid choice! Aborting..."
			echo; exit 126
		;;
	esac
	echo
}

armor_gpg_git() \
{
	frtopt "Identify the 16 digit GPG key ID you'd like to use"
	frtopt " i.e: ${Y}'sec   rsaxxxx/${R}<KEY ID>${Y} 20xx-xx-xx'"
	frtopt "Copy it below, ${W}and don't type Ctrl+C for copying the ID"
	frtoptq " " && read -r gpgkey

	git config --global user.signingkey "$gpgkey"

	echo; subopt "Exporting the GPG key"
	echo; gpg --armor --export "$gpgkey"

	echo
	success "Copy your GPG key, beginning with"
	success "--BEGIN PGP--    to    --END PGP--"
	success "and add it to your SCM Hosting Provider account."
}



# ==============================================================================

usage_git() \
{
	echo
	echo "Git Config & Authentication Script"
	printf "SYNOPSIS: ./%s [-c][-g][-h][-s] \n" "$(basename "$0")"
	cat <<-'EOF'

	OPTIONS:
	    -c,--config   Setup Git global configurations
	    -s,--ssh      Setup SSH key to connect to a SCM Hosting Provider
	    -g,--gpg      Setup GPG key to sign commits and tags

	    -h,--help     Show this menu

	Without any arguments, all aspects will be setup (in the above order)

	For full documentation, see: https://github.com/dievilz/punto.sh#readme

	EOF
}

main_git() \
{
	case "$1" in
		"-h"|"--help")
			usage_git
			exit 0
		;;
		"-c"|"--config")
			echo; setup_config_git
		;;
		"-s"|"--ssh")
			echo; setup_ssh_git
		;;
		"-g"|"--gpg")
			echo; setup_gpg_git
		;;
		"")
			echo; bold "${B}–-> Setting up Git, SSH & GPG..."

			echo
			setup_config_git
			setup_ssh_git
			setup_gpg_git

			success "Git, SSH & GPG successfully configured!"; echo
		;;
		*)
			usage_git
			return 127
		;;
	esac
}

main_git "$@"; exit
