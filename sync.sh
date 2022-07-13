#!/bin/bash
#
# Dotfiles Syncing & Management Script
# Main script for dotfiles symlinking & rsyncing
# Influenced by @mavam's and @ajmalsiddiqui's sync script
#
# By Diego Villarreal, @dievilz in GitHub (https://github.com/dievilz)


### Exporting DOTFILES location to source helper functions
DOTFILES="$(realpath "$0" | grep -Eo '^.*?\.dotfiles')" ## -o: only matching
. "$DOTFILES/helpers.sh" || {
	printf "%b\n\n" "\033[38;31mError: helper functions not found! Aborting...\033[0m"
	echo; exit 1
}


################################### DOTFILES ###################################
############################# SYNC DOTS FUNCTIONS ##############################

syncHomeFiles_sync() \
{
	subopt "Symlinking Dotfiles to $HOME..."
	# echo $DOTFILES

	if [ ! -w "$HOME" ]; then
		echo; printf "%b" "Changing \$HOME permissions: " && chmod -v 751 "$HOME"
	fi
	echo

	while IFS= read -r -d '' dotfile;
	do
		# echo $dotfile
		case "$dotfile" \
		in
			"."*) continue ;;
		esac

		if [ -w "$HOME" ];
		then
			ln -fsv "$dotfile" "$HOME/.$(basename "$dotfile")"
		else
			printf "%b" "Changing \$HOME permissions: " && chmod -v 751 "$HOME"
			ln -fsv "$dotfile" "$HOME/.$(basename "$dotfile")"

			printf "%b" "Changing owner/group: " && \
			chown -hRv "$(id -un)":"$(id -gn)" "$HOME/.$(basename "$dotfile")"

			printf "%b" "Changing permissions: " && \
			chmod -v 700 "$HOME/.$(basename "$dotfile")"
		fi
	done \
	< <(find "$DOTFILES/home" -maxdepth 1 -type f -print0)

	touch "$HOME"/.hushlogin

	echo; printf "%b" "Defending \$HOME: " && chmod -v 551 "$HOME"
	echo
}

syncEtcFiles() \
{
	subopt "Symlinking Dotfiles to /etc..."
	enter_sudo_mode

	while IFS= read -r -d '' etcfile;
	do
		# echo $etcfile
		case "$etcfile" \
		in
			"."*) continue ;;
			*"/etc."*)
				# echo "$etcfile" # "$DOTFILES/root/etc/etc.<file>"
				onlyEtcfile="$(basename "$etcfile" | \
					awk -v a="/etc." '{len=length(a)}{print substr($0,len)}')"
				# echo "$onlyEtcfile" # "<file>"
			;;
			*)
				# echo "$etcfile" # "$DOTFILES/root/etc/<folder1>/<folder2>/<file>"
				onlyEtcfile="$(echo "$etcfile" | \
					awk -v a="$DOTFILES/root/etc//" \
					'{len=length(a)}{print substr($0,len)}')"
				# echo "$onlyEtcfile" # "/<folder1>/<folder2>/<file>"

				if [ ! -d "$(dirname "$onlyEtcfile")" ];
				then
					sudo mkdir -m 755 -pv "/etc/$(dirname "$onlyEtcfile")"
					sudo chown -v root:wheel "/etc/$(dirname "$onlyEtcfile")"
				fi
			;;
		esac
		# echo $onlyEtcfile

		[ ! -d /etc/defaults.d ] && sudo mkdir -m 700 /etc/defaults.d

		[ ! -e "/etc/defaults.d/$onlyEtcfile"_default ] && \
		sudo mv -v "/etc/$(basename $onlyEtcfile)" \
		"/etc/defaults.d/$(basename $onlyEtcfile)"_default

		sudo rsync --exclude=".*" -rhPv "$etcfile" "/etc/$onlyEtcfile"
		sudo chown -v root:wheel "/etc/$onlyEtcfile"
	done \
	< <(fd . "$DOTFILES/root/etc" -d 3 -t f -E "apache2" -0)
	echo
}

syncOptFiles() \
{
	subopt "Creating folders at /opt for Dotfiles"

	while IFS= read -r -d '' optfolders;
	do
		# echo "$optfolders" # "$DOTFILES/root/opt/<folder1>/<folderN>/";
		optfoldersPath="$(echo "$optfolders" | \
			awk -v a="$DOTFILES/root/opt//" \
			'{len=length(a)}{print substr($0,len)}')"
		echo "$optfoldersPath" # "/<folder1>/<folderN>/";

		[ ! -d "/opt/$optfoldersPath" ] && sudo mkdir -pv "/opt/$optfoldersPath"
	done \
	< <(find "$DOTFILES/root/opt" -type d -print0)
	echo

	subopt "Symlinking specific Dotfiles to /opt"
	sudo rsync --exclude=".*" -ahPv "$DOTFILES/root/opt/" "/opt"
	echo
}



############################# SYNC BINS FUNCTIONS ##############################

syncBins() \
{
	subopt "Symlinking Dotfiles scripts to $HOME/.local/bin"
	# ln -fsv "$DOTFILES"/bootstrap.sh "$HOME"/.local/bin/bootstrap
	# ln -fsv "$DOTFILES"/sync.sh "$HOME"/.local/bin/sync
	echo
}



############################ SYNC FOLDERS FUNCTIONS ############################

makeDirs() \
{
	subopt "Making some folders on \$HOME first..."

	if [ ! -w "$HOME" ]; then
		echo; printf "%b" "Changing \$HOME permissions: " && chmod -v 751 "$HOME"
	fi
	echo

	[ ! -d "$HOME/.dotfiles" ] && mkdir -m 700 -pv "$HOME"/.dotfiles
	chmod -v 700 "$HOME"/.dotfiles
	[ ! -d "$HOME/.punto-sh" ] && mkdir -m 700 -pv "$HOME"/.punto-sh
	chmod -v 700 "$HOME"/.punto-sh
	[ ! -d "$HOME/.punto" ] && mkdir -m 700 -pv "$HOME"/.punto
	chmod -v 700 "$HOME"/.punto

	[ ! -d "$HOME/Desktop" ] && mkdir -m 700 -pv "$HOME"/Desktop
	chmod -v 700 "$HOME"/Desktop
	[ ! -d "$HOME/Dev" ] && mkdir -m 700 -pv "$HOME"/Dev
	chmod -v 700 "$HOME"/Dev
	[ ! -d "$HOME/Documents" ] && mkdir -m 700 -pv "$HOME"/Documents
	chmod -v 700 "$HOME"/Documents
	[ ! -d "$HOME/Downloads" ] && mkdir -m 700 -pv "$HOME"/Downloads
	chmod -v 700 "$HOME"/Downloads
	[ ! -d "$HOME/Pictures" ] && mkdir -m 700 -pv "$HOME"/Pictures
	chmod -v 700 "$HOME"/Pictures
	[ ! -d "$HOME/Music" ] && mkdir -m 700 -pv "$HOME"/Music
	chmod -v 700 "$HOME"/Music
	[ ! -d "$HOME/Public" ] && mkdir -m 755 -pv "$HOME"/Public
	chmod -v 755 "$HOME"/Public
	[ ! -d "$HOME/Sites" ] && mkdir -m 755 -pv "$HOME"/Sites
	chmod -v 755 "$HOME"/Sites
	[ ! -d "$HOME/Videos" ] && mkdir -m 700 -pv "$HOME"/Videos
	chmod -v 700 "$HOME"/Videos

	[ ! -d "$HOME/Dev/Repos" ] && mkdir -pv "$HOME"/Dev/Repos
	[ ! -d "$HOME/Music/DownloadedMusic" ] && mkdir -pv "$HOME"/Music/DownloadedMusic
	[ ! -d "$HOME/Pictures/Wallpapers" ] && mkdir -pv "$HOME"/Pictures/Wallpapers

	if [ "$(uname -s)" = "Darwin" ];
	then
		[ ! -d "$HOME/Dev/Xcode" ] && mkdir -pv "$HOME"/Dev/Xcode
		[ ! -d "/Users/Public/LyricsX" ] && mkdir -pv /Users/Public/LyricsX
		if [ -d "$HOME/Music/LyricsX" ] && [ ! -h "$HOME/Music/LyricsX" ];
		then
			mv -v "$HOME"/Music/LyricsX /Users/Public/Old.LyricsX
		fi
		[ ! -h "$HOME/Music/LyricsX" ] && ln -fsv /Users/Public/LyricsX \
			"$HOME"/Music/LyricsX
		[ ! -d "$HOME/Library/QuickLook" ] && mkdir -pv "$HOME"/Library/QuickLook
		[ ! -d "/Library/Services" ] && sudo mkdir -pv /Library/Services
		[ ! -d "/Library/Sounds" ] && sudo mkdir -pv /Library/Sounds
		[ ! -d "/Library/Fonts" ] && sudo mkdir -pv /Library/Fonts
	fi
	echo

	subopt "Making XDG folders on \$HOME..."
	trdopt                          "Verifying XDG_DATA_HOME = /usr/local/share"
	[ ! -d "$HOME/.local" ] && mkdir -m 700 -pv "$HOME"/.local
	chmod -v 700 "$HOME"/.local
	[ ! -d "$HOME/.local/bin" ] && mkdir -m 700 -pv "$HOME"/.local/bin
	chmod -v 700 "$HOME"/.local/bin
	[ ! -d "$HOME/.local/lib" ] && mkdir -m 700 -pv "$HOME"/.local/lib
	chmod -v 700 "$HOME"/.local/lib
	[ ! -d "$HOME/.local/share" ] && mkdir -m 700 -pv "$HOME"/.local/share
	chmod -v 700 "$HOME"/.local/share
	[ ! -d "$HOME/.local/share/gnupg" ] && mkdir -m 700 -pv "$HOME"/.local/share/gnupg
	chmod -v 700 "$HOME"/.local/share/gnupg
	[ ! -d "$HOME/.local/share/ssh" ] && mkdir -m 700 -pv "$HOME"/.local/share/ssh
	chmod -v 700 "$HOME"/.local/share/ssh
	[ ! -d "$HOME/.local/share/dropbox" ] && mkdir -m 700 -pv "$HOME"/.local/share/dropbox
	chmod -v 700 "$HOME"/.local/share/dropbox
	[ ! -d "$HOME/.local/share/vscode" ] && mkdir -m 700 -pv "$HOME"/.local/share/vscode
	echo
	magenta "Symlinking \$HOME/.vscode to \$HOME/.local/share/vscode"
	[ ! -h "$HOME/.vscode" ] && ln -fsv "$HOME"/.local/share/vscode "$HOME"/.vscode
	chmod -v 700 "$HOME"/.vscode
	echo
	magenta "Symlinking \$HOME/.dropbox to \$HOME/.local/share/dropbox"
	[ ! -h "$HOME/.dropbox" ] && ln -fsv "$HOME"/.local/share/dropbox "$HOME"/.dropbox
	chmod -v 700 "$HOME"/.dropbox
	echo
	magenta "Symlinking \$HOME/.ssh to \$HOME/.local/share/ssh"
	[ ! -h "$HOME/.ssh" ] && ln -fsv "$HOME"/.local/share/ssh "$HOME"/.ssh
	chmod -v 700 "$HOME"/.ssh
	echo

	trdopt                                    "Verifying XDG_CONFIG_HOME = /etc"
	[ ! -d "$HOME/.etc" ] && mkdir -m 700 -pv "$HOME"/.etc
	[ ! -d "$HOME/.etc/shell" ] && mkdir -pv "$HOME"/.etc/shell

	magenta "Symlinking \$HOME/.etc to \$HOME/.config"
	if [ -d "$HOME/.config" ] && [ ! -h "$HOME/.config" ];
	then
		mv -v "$HOME"/.config "$HOME"/.etc/old.config
	fi
	[ ! -h "$HOME/.config" ] && ln -fsv "$HOME"/.etc "$HOME"/.config
	chmod -v 700 "$HOME"/.config
	echo

	trdopt "Verifying XDG_STATE_HOME = /var/lib and XDG_CACHE_HOME = /var/cache"
	[ ! -d "$HOME/.var" ] && mkdir -m 700 -pv "$HOME"/.var
	chmod -v 700 "$HOME"/.var
	[ ! -d "$HOME/.var/lib" ] && mkdir -m 700 -pv "$HOME"/.var/lib
	chmod -v 700 "$HOME"/.var/lib
	[ ! -d "$HOME/.var/lib/bash" ] && mkdir -pv "$HOME"/.var/lib/bash
	[ ! -d "$HOME/.var/lib/zsh" ] && mkdir -pv "$HOME"/.var/lib/zsh
	[ ! -d "$HOME/.var/cache" ] && mkdir -m 700 -pv "$HOME"/.var/cache
	chmod -v 700 "$HOME"/.var/cache
	[ ! -d "$HOME/.var/cache/bash" ] && mkdir -pv "$HOME"/.var/cache/bash
	[ ! -d "$HOME/.var/cache/zsh" ] && mkdir -pv "$HOME"/.var/cache/zsh
	[ ! -d "$HOME/.var/cache/shelldebug" ] && mkdir -pv "$HOME"/.var/cache/shelldebug
	echo
	magenta "Symlinking \$HOME/.var/lib to \$HOME/.local/state & \$HOME/.state"
	[ ! -h "$HOME/.local/state" ] && ln -fsv "$HOME"/.var/lib "$HOME"/.local/state
	[ ! -h "$HOME/.state" ] && ln -fsv "$HOME"/.var/lib "$HOME"/.state
	chmod -v 700 "$HOME"/.state
	echo

	magenta "Symlinking \$HOME/.var/cache to \$HOME/.cache"
	[ ! -h "$HOME/.cache" ] && ln -fsv "$HOME"/.var/cache "$HOME"/.cache
	chmod -v 700 "$HOME"/.cache
	echo

	trdopt                                       "Verifying XDG_OPT_HOME = /opt"
	[ ! -d "$HOME/.opt" ] && mkdir -m 700 -pv "$HOME"/.opt
	chmod -v 700 "$HOME"/.opt
	echo

	if [ -w "$HOME" ]; then
		printf "%b" "Defending \$HOME: " && chmod -v 551 "$HOME"
	fi
	echo
}

syncShellFilesFolders_sync() \
{
	subopt "Symlinking Shell files to their respective ~/.config/<shell> folders..."

	if [ ! -w "$HOME" ]; then
		echo; printf "%b" "Changing \$HOME permissions: " && chmod -v 751 "$HOME"
	fi
	echo

	ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
	BASHDOTDIR="${BASHDOTDIR:-$HOME/.config/bash}"
	SHELL_HOME="${SHELL_HOME:-$HOME/.config/shell}"

	[ ! -d "$ZDOTDIR" ] && mkdir -pv "$ZDOTDIR"
	[ ! -d "$BASHDOTDIR" ] && mkdir -pv "$BASHDOTDIR"
	[ ! -d "$SHELL_HOME" ] && mkdir -pv "$SHELL_HOME"
	# -----------------------------------------------------------------------------------------------

	while IFS= read -r -d '' zfolders;
	do
		# echo "$zfolders" # "$DOTFILES/home/config/zsh/<folder1>/<folderN>/";
		zfoldersPath="$(echo "$zfolders" | \
			awk -v a="$DOTFILES/home/config/zsh//" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$zfoldersPath" # "/<folder1>/<folderN>/";

		[ ! -d "$ZDOTDIR/$zfoldersPath" ] && mkdir -pv "$ZDOTDIR/$zfoldersPath"
	done \
	< <(find "$DOTFILES/home/config/zsh" -type d -print0)

	while IFS= read -r -d '' zfiles;
	do
		case "$zfiles" in
			"."*) continue ;;
		esac

		# echo "$zfiles" # "$DOTFILES/home/config/zsh/<folder1>/<folderN>/<file>";
		zfilesPath="$(echo "$zfiles" | \
			awk -v a="$DOTFILES/home/config/zsh//" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$zfilesPath" # "/<folder1>/<folder2>/<file>";

		ln -fsv "$zfiles" "$ZDOTDIR/$zfilesPath"
	done \
	< <(find "$DOTFILES/home/config/zsh" -type f -print0)

	[ -f "$ZDOTDIR/zshenv" ] && mv -v "$ZDOTDIR/zshenv" "$ZDOTDIR/.zshenv"
	[ -f "$ZDOTDIR/zprofile" ] && mv -v "$ZDOTDIR/zprofile" "$ZDOTDIR/.zprofile"
	[ -f "$ZDOTDIR/zshrc" ] && mv -v "$ZDOTDIR/zshrc" "$ZDOTDIR/.zshrc"
	[ -f "$ZDOTDIR/zlogin" ] && mv -v "$ZDOTDIR/zlogin" "$ZDOTDIR/.zlogin"
	# -----------------------------------------------------------------------------------------------

	while IFS= read -r -d '' bthemes;
	do
		case "$bthemes" in
			"."*) continue ;;
		esac
		[ ! -d "$BASHDOTDIR/themes" ] && mkdir -pv "$BASHDOTDIR/themes"
		ln -fsv "$bthemes" "$BASHDOTDIR/themes"
	done \
	< <(find "$DOTFILES/home/config/bash/themes" -type f -print0)

	while IFS= read -r -d '' brc;
	do
		ln -fsv "$brc" "$HOME/.$(basename "$brc")"
		printf "%b" "Changing permissions: " && chmod -v 700 "$HOME/.$(basename "$brc")"
	done \
	< <(find "$DOTFILES/home/config/bash" -name "bash*" -type f -print0)
	# -----------------------------------------------------------------------------------------------

	while IFS= read -r -d '' shllfiles;
	do
		case "$shllfiles" in
			"."*) continue ;;
		esac
		# echo "$shllfiles" # "$DOTFILES/home/config/shell/<folder1>/<folderN>/<file>";
		shllfilesPath="$(echo "$shllfiles" | \
			awk -v a="$DOTFILES/home/config/shell//" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$shllfilesPath" # "/<folder1>/<folder2>/<file>";

		if [ ! -d "$SHELL_HOME/$(dirname "$shllfilesPath")" ];
		then
			mkdir -m 700 -pv "$SHELL_HOME/$(dirname "$shllfilesPath")"
		fi
		ln -fsv "$shllfiles" "$SHELL_HOME/$shllfilesPath"
	done \
	< <(find "$DOTFILES/home/config/shell" -type f -print0)
	# -----------------------------------------------------------------------------------------------


	if [ -w "$HOME" ]; then
		echo; printf "%b" "Defending \$HOME: " && chmod -v 551 "$HOME"
	fi
	echo
}

syncConfigFolders_sync() \
{
	subopt "Symlinking your config files to their respective .config folders..."

	case "$(uname -s)" \
	in
		"Darwin")
			while IFS= read -r -d '' configFile;
			do
				case "$configFile" in
					"."*) continue ;;
				esac

				# echo "$configFile" # "$DOTFILES/home/config/<folder1>/<folder2>/<file>"
				configFilePath="$(echo "$configFile" | \
					awk -v a="$DOTFILES/home/config//" \
					'{len=length(a)}{print substr($0,len)}')"
				# echo "$configFilePath" # "/<folder1>/<folder2>/<file>"

				if [ ! -d "$(dirname "$configFilePath")" ];
				then
					mkdir -m 700 -pv "$HOME/.config/$(dirname "$configFilePath")"
				fi
				ln -fsv "$configFile" "$HOME/.config/$configFilePath"

			done \
			< <(fd . "$DOTFILES/home/config" -d 5 --type f \
				-E "bash" -E "iterm2" -E "spotify" -E "sublime-text" -E "sublime-merge" \
				-E "vscode" -E "zsh" -E "i3" -E "polybar" -E "terminator" -E "X11" -0)

			cp -v "$DOTFILES"/home/config/iterm2/com.googlecode.iterm2.plist \
			"$HOME"/.config/iterm2/com.googlecode.iterm2.plist
		;;
		"Linux")
			while IFS= read -r -d '' configFile;
			do
				case "$configFile" in
					"."*) continue ;;
				esac

				# echo "$configFile" # "$DOTFILES/home/config/<folder1>/<folder2>/<file>"";
				configFilePath="$(echo "$configFile" |
					awk -v a="$DOTFILES/home/config//" \
					'{len=length(a)}{print substr($0,len)}')"
				# echo "$configFilePath" # "/<folder1>/<folder2>/<file>""

				if [ ! -d "$(dirname "$configFilePath")" ];
				then
					mkdir -m 700 -pv "$HOME/.config/$(dirname "$configFilePath")"
				fi
				ln -fsv "$configFile" "$HOME/.config/$configFilePath"

			done \
			< <(fd . "$DOTFILES/home/config" -d 5 --type f \
				-E "bash" -E "iterm2" -E "spotify" -E "sublime-text" -E "sublime-merge" \
				-E "vscode" -E "zsh" -E "deluge" -E "karabiner" -0)
		;;
	esac
	echo
}

syncLocalFolders_sync() \
{
	subopt "Copying your share files to their respective .local/share folders..."

	while IFS= read -r -d '' localShareFile;
	do
		case "$localShareFile" in
			"."*) continue ;;
		esac
		# echo "$localShareFile" # "$DOTFILES/home/local/share/<folder1>/<folder2>/<file>"
		localShareFilePath="$(echo "$localShareFile" | \
			awk -v a="$DOTFILES/home/local/share//" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$localShareFilePath" # "/<folder1>/<folder2>/<file>"

		if [ ! -d "$(dirname "$localShareFilePath")" ];
		then
			mkdir -m 700 -pv "$HOME/.local/share/$(dirname "$localShareFilePath")"
		fi
		ln -fsv "$localShareFile" "$HOME/.local/share/$localShareFilePath"
	done \
	< <(fd . "$DOTFILES/home/local/share" -d 5 --type f -0)
	echo
}

syncEtcFolders() \
{
	subopt "Copying your system config files to the /etc folders..."

	case "$(uname -s)" \
	in
		"Darwin")
			if command_exists pkgin;
			then
				[ ! -d /opt/pkg/etc/defaults.d ] && mkdir -m 700 /opt/pkg/etc/defaults.d

				if [ -e /opt/pkg/bin/dnsmasq ];
				then
					[ ! -e /opt/pkg/etc/rc.d/dnsmasq ] && sudo install -C -m 0755 \
					/opt/pkg/share/examples/rc.d/dnsmasq /opt/pkg/etc/rc.d/dnsmasq

					[ ! -e /opt/pkg/etc/defaults.d/dnsmasq.conf_default ] \
					&& sudo mv -v /opt/pkg/etc/dnsmasq.conf /opt/pkg/etc/defaults.d/dnsmasq.conf_default

					sudo rsync -rhPv"$DOTFILES/root/etc/dnsmasq/dnsmasq.conf" /opt/pkg/etc/dnsmasq.conf
				fi


				if [ -e /opt/pkg/bin/privoxy ];
				then
					[ ! -e /opt/pkg/etc/rc.d/privoxy ] && sudo install -C -m 0755 \
					/opt/pkg/share/examples/rc.d/privoxy /opt/pkg/etc/rc.d/privoxy
					while IFS= read -r -d '' privoxyFile;
					do
						[ ! -e /opt/pkg/etc/defaults.d/"$(basename "$privoxyFile")"_default ] && \
						sudo mv -v /opt/pkg/etc/"$(basename "$privoxyFile")" \
						/opt/pkg/etc/defaults.d/"$(basename "$privoxyFile")"_default

						sudo rsync -rhPv --exclude=".*" "$privoxyFile" \
						"/opt/pkg/etc/privoxy/$(basename "$privoxyFile")"
					done \
					< <(find "$DOTFILES/root/etc/privoxy" -type f -maxdepth 1  -print0)
				fi


				[ ! -e /opt/pkg/etc/rc.d/dbus ] && sudo install -C -m 0755 \
				/opt/pkg/share/examples/rc.d/dbus /opt/pkg/etc/rc.d/dbus
				if ! sudo grep -Fqx "dbus=YES" /opt/pkg/etc/rc.d/dbus; then
					echo "dbus=YES" | sudo tee -a /opt/pkg/etc/rc.d/dbus
				fi

				sudo rsync -rhPv "$DOTFILES/root/etc/doas.conf" /opt/pkg/etc/doas.conf
				echo
			fi

			if command_exists brew;
			then
				[ ! -d "$(brew --prefix)/etc/defaults.d" ] && mkdir -m 700 "$(brew --prefix)/etc/defaults.d"

				if [ -e "$(brew --prefix)/bin/dnsmasq" ];
				then
					[ ! -e "$(brew --prefix)/etc/defaults.d/dnsmasq.conf_default" ] \
					&& sudo mv -v "$(brew --prefix)/etc/dnsmasq.conf" \
					"$(brew --prefix)/etc/defaults.d/dnsmasq.conf_default"

					sudo rsync -rhPv "$DOTFILES/root/etc/dnsmasq.conf" \
					"$(brew --prefix)/etc/dnsmasq.conf"
				fi

				if [ -e "$(brew --prefix)/bin/dnscrypt-proxy" ];
				then
					[ ! -e "$(brew --prefix)/etc/defaults.d/dnscrypt-proxy.toml_default" ] \
					&& sudo mv -v "$(brew --prefix)/etc/dnscrypt-proxy.toml" \
					"$(brew --prefix)/etc/defaults.d/dnscrypt-proxy.toml_default"

					sudo rsync -rhPv "$DOTFILES/root/etc/dnscrypt-proxy.toml" \
					"$(brew --prefix)/etc/dnscrypt-proxy.toml"
				fi

				if [ -e "$(brew --prefix)/bin/privoxy" ];
				then
					while IFS= read -r -d '' privoxyFile;
					do
						[ ! -e "$(brew --prefix)/etc/defaults.d/$(basename "$privoxyFile")"_default ] && \
						sudo mv -v "$(brew --prefix)/etc/privoxy/$(basename "$privoxyFile")" \
						"$(brew --prefix)/etc/defaults.d/$(basename "$privoxyFile")_default"

						sudo rsync -rhPv --exclude=".*" "$privoxyFile" \
						"$(brew --prefix)/etc/privoxy/$(basename "$privoxyFile")"
					done \
					< <(find "$DOTFILES/root/etc/privoxy" -type f -maxdepth 1  -print0)
				fi
			fi
			echo
		;;
	esac

	## https://github.com/slicer69/doas#compiling-and-installing
	if [ -e /etc/pam.d/sudo ] && [ ! -e /etc/pam.d/doas ];
	then
		sudo cp -v /etc/pam.d/sudo /etc/pam.d/doas
	fi

	if [ "$(uname -s)" = "Linux" ];
	then
		if [ ! -e /etc/pam.d/sudo ] && [ ! -e /etc/pam.d/doas ];
		then
			printf "%b" "#%PAM-1.0
  @include common-auth
  @include common-account
  @include common-session-noninteractive" | sudo tee -a /etc/pam.d/doas

			sudo chown root:root /etc/pam.d/doas
		fi
	fi

	[ ! -e /etc/defaults.d/sshd_config_default ] \
	&& sudo mv -v /etc/ssh/sshd_config /etc/defaults.d/sshd_config_default
	sudo rsync -rhPv "$DOTFILES/root/etc/ssh/sshd_config" /etc/ssh/sshd_config

	sudo rsync -rhPv "$DOTFILES/root/etc/pf/pf.rules" /etc/pf/pf.rules
	echo
}

################################################################################



################################# PREFERENCES ##################################

setup_preferences() \
{
	option "Preferences: Copying preferences files for apps (like Spotify, iTerm2, etc)..."

	case "$(uname -s)" in
	"Darwin")
		subopt "Enter your Spotify Unique ID/Account ID to sync your Spotify" \
		"Desktop preferences"
		suboptq "[Type 'skip'/'none'/press 'Enter' to halt]: "
		read -r spotifyUID
		case "$spotifyUID" \
		in
			n|N|no|No|"skip"|"none"|"")
				warn "Skipping this step!"
				echo
			;;
			*)
			mkdir -pv "$HOME/Library/Application Support/Spotify/Users/$spotifyUID-user"
			trdopt "Copying Spotify preferences"
			rsync -ahPv "$DOTFILES"/home/config/spotify/prefs \
			"$HOME/Library/Application Support/Spotify/Users/$spotifyUID-user/prefs"
			;;
		esac

		if [ -d "$HOME/Library/Containers/com.aone.keka/Data/Library/Preferences" ];
		then
			rsync -ahPv "$DOTFILES/home/Library/Containers/lyricsx/com.aone.keka.plist" \
			"$HOME"/Library/Containers/com.aone.keka/Data/Library/Preferences/
		fi

		if [ -d "$HOME/Library/Containers/ddddxxx.LyricsX/Data/Library/Preferences" ];
		then
			rsync -ahPv "$DOTFILES/home/Library/Containers/lyricsx/ddddxxx.LyricsX.plist" \
			"$HOME"/Library/Containers/ddddxxx.LyricsX/Data/Library/Preferences/
		fi

		if [ -d "$HOME/Library/Containers/com.fiplab.memoryclean2/Data/Library/Preferences/" ];
		then
			rsync -ahPv "$DOTFILES/home/Library/Containers/memoryclean2/com.fiplab.memoryclean2.plist" \
			"$HOME"/Library/Containers/com.fiplab.memoryclean2/Data/Library/Preferences/
		fi

		while IFS= read -r -d '' prefFile;
		do
			# echo "$prefFile" # "$DOTFILES/home/Library/Preferences/<file>"
			prefFilePath="$(echo "$prefFile" | \
				awk -v a="$DOTFILES/home/Library/Preferences//" \
				'{len=length(a)}{print substr($0,len)}')"
			# echo "$prefFilePath" # "/<file>"

			rsync -ahPv --exclude=".*" "$prefFile" "$HOME/Library/Preferences/$prefFilePath"
		done \
		< <(fd . "$DOTFILES/home/Library/Preferences" -d 1 --type f -0)
		echo
	;;
	"Linux")
		warn "Nothing to add yet..."
	;;
	esac
	echo
}

setup_library_macos() \
{
	option "Library: Copying Library files for apps (like LyricsX, TimeOut, etc)..."
	isMacos

	subopt "Setting up ${IT}Renamer6${NIT} data (renamerlets)"
	suboptq "Type anything or press Enter key to skip: "
	read -r skipper
	if [ -n "$skipper" ]; then
		[ ! -d "$HOME/Library/Application Support/Renamer" ] \
		&& mkdir -pv "$HOME/Library/Application Support/Renamer"

		rsync -ahPv "$DOTFILES/home/Library/Application Support/Renamer/Renamerlets.renamerlets" \
		"$HOME/Library/Application Support/Renamer/Renamerlets.renamerlets"
		echo
	fi
	[ -z "$skipper" ] && echo
	unset $skipper

	subopt "Setting up ${IT}Time Out${NIT} data (settings and breaks)"
	suboptq "Type anything or press Enter key to skip: "
	read -r skipper
	[ -n "$skipper" ] && setup_library_timeout
	[ -z "$skipper" ] && echo
	unset $skipper

	subopt "Setting up ${IT}yEd Editor${NIT} data (settings and bundles)"
	suboptq "Type anything or press Enter key to skip: "
	read -r skipper
	[ -n "$skipper" ] && setup_library_yed
	[ -z "$skipper" ] && echo
	unset $skipper

	subopt "Setting up ${IT}QuickLook${NIT} generators"
	suboptq "Type anything or press Enter key to skip: "
	read -r skipper
	[ -n "$skipper" ] && setup_library_quicklook
	[ -z "$skipper" ] && echo
	unset $skipper

	subopt "Setting up ${IT}Automator${NIT} Services and Quick Actions"
	suboptq "Type anything or press Enter key to skip: "
	read -r skipper
	[ -n "$skipper" ] && setup_library_automator
	[ -z "$skipper" ] && echo
	unset $skipper

	subopt "Setting up ${IT}Sounds${NIT} for System Preferences"
	suboptq "Type anything or press Enter key to skip: "
	read -r skipper
	[ -n "$skipper" ] && setup_library_sounds
	[ -z "$skipper" ] && echo
	unset $skipper
}

setup_library_timeout() \
{
	while IFS= read -r -d '' timeOutFile;
	do
		# echo "$timeOutFile" # "$DOTFILES/home/Library/Group Containers/timeout/<folder1>/<file>"
		timeOutFilePath="$(echo "$timeOutFile" | \
			awk -v a="$DOTFILES/home/Library/Group Containers/timeout/" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$timeOutFilePath" # "/<folder1>/<file>"

		timeOutFolder="$(find "$HOME/Library/Group Containers" \
			-name "*dejal.timeout.free" -type d -print0 -quit | \
			awk -F "Containers/" '{print $2}' | tr -d '\0')"

		if [ ! -d "$HOME/Library/Group Containers/$timeOutFolder$(dirname "$timeOutFilePath")" ];
		then
			mkdir -pv "$HOME/Library/Group Containers/$timeOutFolder$(dirname "$timeOutFilePath")"
		fi

		if [ ! -e "$HOME/Library/Group Containers/$timeOutFolder$timeOutFilePath" ];
		then
			rsync -ahPv --exclude=".*" "$timeOutFile" \
			"$HOME/Library/Group Containers/$timeOutFolder$timeOutFilePath"
		fi
	done \
	< <(fd . "$DOTFILES/home/Library/Group Containers/timeout" -d 5 -t f -0)
	echo
}

setup_library_yed() \
{
	while IFS= read -r -d '' yEdFile;
	do
		# echo "$yEdFile" # "$DOTFILES/home/Library/yWorks/yEd/<folder1>/<file>"
		yEdFilePath="$(echo "$yEdFile" | \
			awk -v a="$DOTFILES/home/Library/yWorks//" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$yEdFilePath" # "yEd/<folder1>/<file>"

		if [ ! -d "$(dirname "$yEdFilePath")" ];
		then
			mkdir -pv "$HOME/Library/yWorks/$(dirname "$yEdFilePath")"
		fi

		if [ ! -e "$HOME/Library/yWorks/$yEdFilePath" ];
		then
			rsync -ahPv --exclude=".*" "$yEdFile" "$HOME/Library/yWorks/$yEdFilePath"
		fi
	done < <(fd . "$DOTFILES/home/Library/yWorks/yEd" -d 5 -t f -0)
	echo
}

setup_library_quicklook() \
{
	trdopt "Copying QuickLook Generators from iCloud Drive..."

	[ ! -d "$HOME/Library/QuickLook" ] && mkdir -pv "$HOME"/Library/QuickLook
	while IFS= read -r -d '' qlgen;
	do
		[ ! -d "$HOME/Library/QuickLook/$(basename $qlgen)" ] && \
		rsync -ahPv --exclude=".*" "$qlgen" "$HOME/Library/QuickLook/"
	done \
	< <(find "$HOME/Library/Mobile Documents/com~apple~CloudDocs/QuickLook"\
		-name "*.qlgenerator" -maxdepth 1 -type d-print0)
	echo

	trdopt "Rsyncing QuickLook Generators config files..."
	[ -d "$HOME/Library/QuickLook/QLColorCode.qlgenerator/Contents" ] && \
	rsync -ahPv "$DOTFILES/home/Library/QuickLook/QLColorCode.ql/Info.plist" \
	"$HOME"/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist

	[ -d "$HOME/Library/QuickLook/QLStephen.qlgenerator/Contents" ] && \
	rsync -ahPv "$DOTFILES/home/Library/QuickLook/QLStephen.ql/Info.plist" \
	"$HOME"/Library/QuickLook/QLStephen.qlgenerator/Contents/Info.plist

	echo
}

setup_library_automator() \
{
	trdopt "Rsyncing the custom QuickActions and Services from iCloud Drive..."

	[ ! -d "/Library/Services" ] && sudo mkdir -pv /Library/Services
	while IFS=$'\n' read -r -d '' workf;
	do
		# echo "$workf" # "$HOME/Library/Mobile Documents/com~apple~Automator/Documents/<dir>"
		workfPath="$(echo "$workf" | \
			awk -v a="$HOME/Library/Mobile Documents/com~apple~Automator/Documents//" \
			'{len=length(a)}{print substr($0,len)}')"
		# echo "$workfPath" # "<folder>"

		if [ ! -e "/Library/Services/$workfPath" ];
		then
			sudo cp -Rv "$workf" "/Library/Services/$workfPath"
			sudo chown -Rv root:staff "/Library/Services/$workfPath"
		fi
	done \
	< <(find "$HOME/Library/Mobile Documents/com~apple~Automator/Documents" \
		-name "*.workflow" -maxdepth 1 -type d -print0)
	echo
}

setup_library_sounds() \
{
	trdopt "Rsyncing Sounds audio files from iCloud Drive..."

	[ ! -d "/Library/Sounds" ] && sudo mkdir -pv /Library/Sounds
	while IFS= read -r -d '' snds;
	do
		case "$snds" in
			*".icloud") continue ;;
		esac

		if [ ! -e "/Library/Sounds/$(basename "$snds")" ];
		then
			sudo cp -v "$snds" "/Library/Sounds/"
			sudo chown -Rv root:staff "/Library/Sounds/$(basename "$snds")"
		fi
	done \
	< <(find "$HOME/Library/Mobile Documents/com~apple~QuickTimePlayerX/Documents/Ringtones" \
		-maxdepth 1 -type f -print0)
	echo
}

################################################################################



################################# TEXT EDITORS #################################

basicsSublimeText() \
{
	option "Copying Sublime Text basic settings..."

	case "$(uname -s)" in
		"Darwin")
			appLocation="$HOME/Library/Application Support/Sublime Text/Packages/User"
			binLocation="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
		;;
		"Linux")
			appLocation="$HOME/.config/sublime-text/Packages/User"
			# binLocation="$HOME/.config/sublime-text/bin/subl"
		;;
	esac

	[ ! -d "$appLocation" ] && mkdir -pv "$appLocation" && echo

	if [ -e "$binLocation" ] && [ ! -e /usr/local/bin/subl ];
	then
		subopt "Symlinking subl binary to /usr/local/bin..."
		sudo ln -fsv "$binLocation" /usr/local/bin/subl
		echo
	fi

	subopt "Rsyncing basic config file..."
	case $(/usr/local/bin/subl --version | cut -d ' ' -f 4) in
	4*)
		rsync -ahPv \
		"$DOTFILES"/home/config/sublime-text/v4-BasicPreferences.sublime-settings \
		"$appLocation/Preferences.sublime-settings"
	;;
	3*)
		rsync -ahPv \
		"$DOTFILES"/home/config/sublime-text/v3-BasicPreferences.sublime-settings \
		"$appLocation/Preferences.sublime-settings"
	;;
	esac
	echo

	info "Execute '--text-editors full stext' when you have synced all your" \
	"packages on both text-editors"
	echo
}

basicsSublimeMerge() \
{
	option "Copying Sublime Merge basic settings..."

	case "$(uname -s)" in
		"Darwin")
			appLocation="$HOME/Library/Application Support/Sublime Merge/Packages/User"
			binLocation="/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge"
		;;
		"Linux")
			appLocation="$HOME/.config/sublime-merge/Packages/User"
			# binLocation="$HOME/.config/sublime-merge/bin/smerge"
		;;
	esac

	[ ! -d "$appLocation" ] && mkdir -pv "$appLocation" && echo

	if [ -e "$binLocation" ] && [ ! -e /usr/local/bin/smerge ];
	then
		sudo ln -fsv "$binLocation" /usr/local/bin/smerge
		echo
	fi

	rsync -ahPv --exclude=".*" \
	"$DOTFILES"/home/config/sublime-merge/Packages/User/ "$appLocation"
	echo
}

basicsVScode() \
{
	option "Copying Visual Studio Code basic settings..."

	case "$(uname -s)" in
		"Darwin")
			appLocation="$HOME/Library/Application Support/Code/User"
			binLocation="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
			cfgLocation="$DOTFILES"/home/config/vscode/MacBasicSettings.json
		;;
		"Linux")
			appLocation="$HOME/.config/Code/User"
			# binLocation="$HOME/.config/Code/bin/code"
			cfgLocation="$DOTFILES"/home/config/vscode/LinuxBasicSettings.json
		;;
	esac

	[ ! -d "$appLocation" ] && mkdir -pv "$appLocation" && echo

	if [ -e "$binLocation" ] && [ ! -e /usr/local/bin/code ];
	then
		sudo ln -fsv "$binLocation" /usr/local/bin/code
		echo
	fi

	rsync -ahPv "$cfgLocation" "$appLocation/settings.json"
	echo

	subopt "Installing Visual Studio Code extensions..."

	while IFS=, read -r extension <&9;
	do
			if [ -z "$extension" ]; then
				continue
			fi
			code --install-extension "$extension"
	done \
	9< "$DOTFILES"/home/config/vscode/extensions.csv
	echo

	info "Execute '--text-editors full vscode' when you have synced all your" \
	"packages on both text-editors"
	echo
}

# ------------------------------------------------------------------------------

fullSublimeText() \
{
	option "Copying Sublime Text full-featured settings..."

	case "$(uname -s)" in
		"Darwin")
			appLocation="$HOME/Library/Application Support/Sublime Text/Packages/User"
			binLocation="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
		;;
		"Linux")
			appLocation="$HOME/.config/sublime-text/Packages/User"
			# binLocation="$HOME/.config/sublime-text/bin/subl"
		;;
	esac

	case $(subl --version | cut -d ' ' -f 4) in
		4*)
			rsync -ahPv \
			"$DOTFILES"/home/config/sublime-text/v4-FullPreferences.sublime-settings \
			"$appLocation/Preferences.sublime-settings"
		;;
		3*)
			rsync -ahPv \
			"$DOTFILES"/home/config/sublime-text/v3-FullPreferences.sublime-settings \
			"$appLocation/Preferences.sublime-settings"
		;;
	esac

	rsync -ahPv --exclude=".*" \
	"$DOTFILES"/home/config/sublime-text/Packages/User/ "$appLocation"
	echo
}

fullVscode() \
{
	option "Copying Visual Studio Code full-featured settings..."

	case "$(uname -s)" in
		"Darwin")
			rsync -ahPv "$DOTFILES"/home/config/vscode/MacFullSettings.json \
			"$HOME/Library/Application Support/Code/User/settings.json"
		;;
		"Linux")
			rsync -ahPv "$DOTFILES"/home/config/vscode/LinuxFullSettings.json \
			"$HOME/.config/Code/User/settings.json"
		;;
	esac
	echo
}

################################################################################



########################## WALLPAPERS, LYRICS & FONTS ##########################

setup_wallpapers() \
{
	option "Wallpapers: R-Syncing your favorite wallpapers"

	info "If your wallpapers are on an external drive, halt this command," \
	"plug the drive in, open a new terminal and rerun this script"
	warn "If you want to halt this setup, just type Enter to exit"

	local firstDir
	local secondDir

	echo; subopt "Write the Full Path of the Directory (without final"
	suboptq "trailing slash) you will sync the wallpapers from: "
	read -r firstDir

	if [ -z "$firstDir" ];
	then
		warn "Skipping this step!"; return
	fi

	echo; subopt "Write the Full Path of the Directory (without final"
	suboptq "trailing slash) where the wallpapers will go: "
	read -r secondDir

	if [ -z "$secondDir" ];
	then
		warn "R-Syncing wallpapers halted"; return
	fi

	echo; rsync -ahvz --exclude=".*" "$firstDir/" $secondDir

	echo; success "Wallpapers successfully rsynced!"
	echo
}

setup_lyrics() \
{
	option "Lyrics: R-Syncing your Lyrics files (.lrc) folder content"

	local targetLyricsDir
	case "$(uname -s)" in
		"Darwin") targetLyricsDir="/Users/Shared/LyricsX" ;;
		"Linux") targetLyricsDir="/usr/share/lyrics/" ;;
		*)
			error "$(uname -s) not supported! Skipping..."
			echo; return 126
		;;
	esac

	local sourceLyricsDir

	info "If your lyrics are on an external drive, halt this command, plug the" \
	"drive in, open a new terminal and rerun this script"
	warn "If you want to halt this setup, just type Enter to exit"
	echo
	subopt "Write the Full Path of the Directory (without final"
	subopt "trailing slash) you will sync the lyrics from: "
	read -r lyricsDir

	if [ -z "$sourceLyricsDir" ];
	then
		warn "R-Syncing lyrics halted"; return
	fi

	if [ -d "$sourceLyricsDir" ];
	then
		echo; rsync -ahPvz --exclude=".*" "$sourceLyricsDir/" "$targetLyricsDir"
	else
		error "Source directory not found! Aborting..."
		echo; exit 126
	fi

	echo; success "Lyrics successfully rsynced!"
	echo
}

setup_fonts() \
{
	option "Fonts: Syncing your .ttf's, .otf's and zip files"

	local localDir
	case "$(uname -s)" in
		"Darwin") localDir="$HOME/Library/Fonts/" ;;
		"Linux") localDir="/usr/share/fonts/" ;;
		*)
			error "$(uname -s) not supported! Skipping..."
			echo; return 126
		;;
	esac

	info "If your fonts are on an external drive, halt this command, plug the" \
	"drive in, open a new terminal and rerun this script"
	warn "If you want to halt this setup, just type Enter to exit"
	echo
	subopt "Write the Full Path of the Directory (without final"
	suboptq "trailing slash) you will copy the fonts from: "
	read -r fontsDir

	if [ -z "$fontsDir" ];
	then
		warn "Copying fonts halted"
		echo; exit 126
	fi

	if [ -d "$fontsDir" ];
	then
		echo
		while IFS= read -r -d '' file;
		do
			cp -v "$file" "$localDir"
		done \
		< <(find "$fontsDir" -name "*.ttf" -type f -print0)
		echo

		while IFS= read -r -d '' file;
		do
			cp -v "$file" "$localDir"
			chmod -v 644 "$file"
		done \
		< <(find "$fontsDir" -name "*.otf" -type f -print0)
		echo

		while IFS= read -r -d '' file;
		do
			cp -v "$file" "$localDir"
			chmod -v 644 "$file"

			if command_exists minizip;
			then
				minizip extract "$localDir/$file"
			else
				unzip "$localDir/$file"
			fi
			rm "$localDir/$file"
		done \
		< <(find "$fontsDir" -name "*.zip" -type f -print0)
		echo

		success "Fonts successfully copied!"
	else
		error "Directory not found! Aborting..."
		echo; exit 126
	fi
	echo
}

################################################################################



############################ REMOVE DOTS FUNCTIONS #############################

removeFiles() \
{
	subopt "Unlinking at $HOME"
	verifyTrashUtility

	while IFS= read -r -d '' file;
	do
		case "$(uname -s)" \
		in
			"Darwin")
				trash -v "$file"
			;;
			*)
				trash -v "$file"
			;;
		esac
	done \
	< <(fd . "$HOME" -d 1 -t l -0)
	echo;
}

removeBins() \
{
	subopt "Unlinking at $HOME/.local/bin"
	verifyTrashUtility

	while IFS= read -r -d '' binary;
	do
		case "$(uname -s)" \
		in
			"Darwin")
				trash -v "$binary"
			;;
			*)
				trash -v "$binary"
			;;
		esac
	done \
	< <(fd . "$HOME"/.local/bin -t l -0)
	echo
}

removeFolders() \
{
	subopt "Unlinking at $HOME/.config and $HOME/.local"
	verifyTrashUtility

	while IFS= read -r -d '' configFolder;
	do
		case "$(uname -s)" \
		in
			"Darwin")
				trash -v "$configFolder"
			;;
			*)
				trash -v "$configFolder"
			;;
		esac
	done \
	< <(fd . "$HOME"/.config -t l -0)

	while IFS= read -r -d '' localFolder;
	do
		case "$(uname -s)" \
		in
			"Darwin")
				trash -v "$localFolder"
			;;
			*)
				trash -v "$localFolder"
			;;
		esac
	done \
	< <(fd . "$HOME"/.local -t l -0)
	echo
}

removeTextEditors() \
{
	option "Text Editors: Unlinking existing settings"
	verifyTrashUtility

	case "$(uname -s)" in
		"Darwin")
			appSTLocation="$HOME/Library/Application Support/Sublime Text/Packages/User"
			appSMLocation="$HOME/Library/Application Support/Sublime Merge/Packages/User"
			appVSCLocation="$HOME/Library/Application Support/Code/User"
		;;
		"Linux")
			appSTLocation="$HOME/.config/sublime-text/Packages/User"
			appSMLocation="$HOME/.config/sublime-merge/Packages/User"
			appVSCLocation="$HOME/.config/Code/User"
		;;
	esac

	while IFS= read -r -d '' file;
	do
		trash -v "$file"
	done \
	< <(find "$appSTLocation" -maxdepth 3 -type l -print0)

	while IFS= read -r -d '' file;
	do
		trash -v "$file"
	done \
	< <(find "$appSMLocation" -type l -print0)

	while IFS= read -r -d '' file;
	do
		trash -v "$file"
	done \
	< <(find "$appVSCLocation" -maxdepth 3 -type l -print0)

	echo
}

################################################################################



############################## VERIFY FUNCTIONS ################################

verifyRsyncUtility() \
{
	if ! command_exists rsync;
	then
		error "<rsync> command not found! Aborting..."
		echo; return
	fi
}

verifyFdUtility() \
{
	if ! command_exists fd;
	then
		error "<fd> command not found! Aborting..."
		echo; return
	fi
}

verifyTrashUtility() \
{
	if command_exists trash;
	then
		true
	elif command_exists macos-trash;
	then
		true
	else
		error "<trash> command not found! Aborting..."
		echo; return
	fi
}




# ==============================================================================

usage_sync() \
{
echo
echo "@dievilz' Dotfiles Syncing & Management Script"
echo "Main script for dotfiles symlinking & rsyncing."
echo "Influenced by @mavam's and @ajmalsiddiqui's sync script"
echo
printf "SYNOPSIS: ./%s [-a][-b][-d][-f][-h][-l][-p][-r][-t][-w] \n" "$(basename "$0")"
printf "./%s [--dotfiles [home|etcroot|bins|...]] \n" "$(basename "$0")"
printf "./%s [--text-editors [basics [stext|smerge|...]|full [stext|...]]] \n" "$(basename "$0")"
printf "./%s [--remove][files|bins|folders|text-editors] \n" "$(basename "$0")"
cat <<-'EOF'

OPTIONS:
    -d,--dotfiles       Place the Dotfiles in $HOME/$XDG with:
       home                 Symlink corresponding files in $HOME
       etcroot              Rsync corresponding files in /etc
       optroot              Rsync corresponding files in /opt
       bins                 Copy corresponding binaries in $XDG_BIN_HOME
       makedirs             Makedir common User folders and enforce XDG compliance
       shell                Symlink corresponding Shell files in $XDG_CONFIG_HOME
       config               Symlink custom files in $XDG_CONFIG_HOME
       local                Symlink custom files in $XDG_DATA_HOME
       etcfolders           Rsync etc files in their respective /etc/<folder>
    -t,--text-editors   Configure Text Editors/Dev Apps settings with:
       basics               Rsync settings for a basic use
          stext                 Just for Sublime Text
          smerge                Just for Sublime Merge
          vscode                Just for Vscode
       full                 Rsync full-featured settings/files for a complete dev use
          stext                 Just for Sublime Text
          vscode                Just for Vscode
    -p,--preferences    Rsync preferences files for apps (like Spotify, iTerm2, etc)
    -b,--library        Rsync macOS Library files (Preferences, Services, Containers, etc).
    -w,--wallpapers     Rsync Wallpapers from any external drive/local folder
    -l,--lyrics         Rsync Lyrics from any external drive/local folder
    -f,--fonts          Rsync any Fonts files from any external drive/local folder

    -r,--remove         Delete all the symlinks deployed by this script, or:
       files                Remove only symlinked files in $HOME
       bins                 Remove only symlinked dotfiles binaries in $XDG_BIN_HOME
       folders              Remove only symlinked files in $XDG_CONFIG_HOME
       text-editors         Remove only symlinked text editors settings

    -h,--help           Show this menu

Note: Execute '--text-editors full <app>' when you have finished the Fresh Install
Bootstrapping, and you have synced all your plugins on the text editors.

For full documentation, see: https://github.com/dievilz/punto.sh#readme

EOF
}

menu_sync() \
{
	case $1 in
		"-h"|"--help")
			usage_sync
			exit 0
		;;
		"-d"|"--dotfiles")
			case $2 in
				"home")
					echo; syncHomeFiles_sync
				;;
				"etcroot")
					echo; syncEtcFiles
				;;
				"optroot")
					echo; syncOptFiles
				;;
				"bins")
					echo; syncBins
				;;
				"makedirs")
					echo; makeDirs
				;;
				"shell")
					echo; syncShellFilesFolders_sync
				;;
				"config")
					echo; syncConfigFolders_sync
				;;
				"local")
					echo; syncLocalFolders_sync
				;;
				"etcfolders")
					echo; syncEtcFolders
				;;
				*)
					error "Unknown option-argument for --dotfiles! Use -h/--help"
					return 127
				;;
			esac
		;;
		"-t"|"--text-editors")
			case $2 in
				"basics")
					case $3 in
						"stext")
							echo; basicsSublimeText
						;;
						"smerge")
							echo; basicsSublimeMerge
						;;
						"vscode")
							echo; basicsVScode
						;;
						*)
							error "Unknown operand for basics! Use -h/--help"
							return 127
						;;
					esac
				;;
				"full")
					case $3 in
						"stext")
							echo; fullSublimeText
						;;
						"vscode")
							echo; fullVscode
						;;
						*)
							error "Unknown operand for full! Use -h/--help"
							return 127
						;;
					esac
				;;
				*)
					error "Unknown option-argument for --text-editors! Use -h/--help"
					return 127
				;;
			esac
		;;
		"-p"|"--preferences")
			echo; setup_preferences
		;;
		"-b"|"--library")
			echo; setup_library_macos
		;;
		"-w"|"--wallpapers")
			echo; setup_wallpapers
		;;
		"-l"|"--lyrics")
			echo; setup_lyrics
		;;
		"-f"|"--fonts")
			echo; setup_fonts
		;;
		"-r"|"--remove")
			case $2 in
				"files")
					echo; removeFiles
				;;
				"bins")
					echo; removeBins
				;;
				"folders")
					echo; removeFolders
				;;
				"text-editors")
					# echo; removeTextEditors
				;;
				""|"all")
					echo; red "3, 2, 1... Dropping the nukes! "

					echo
					removeFiles
					removeBins
					removeFolders
					# removeTextEditors

					success "Mission accomplished! Bravo Six, going bark..."
					echo
				;;
				*)
					error "Unknown option-argument for --remove! Use -h/--help"
					return 127
				;;
			esac
		;;
		*)
			error "Unknown option! Use -h/--help"
			return 127
		;;
	esac
}

main_case_sync() \
{
	option "We are going to install a concept one by one."
	until false;
	do
		echo
		subopt "Below are the options:"
		usage_sync

		subopt "Choose one option from the usage..."
		subopt "or [${BO}'skip'${NBD}|${BO}'none'${NBD}][press ${BO}Enter key${NBD}] to halt"
		suboptq "" && read -r syncOpt

		case "$syncOpt" in
			"none"|"None"|"skip"|"Skip"|"")
				warn "Skipping this step!"
				return 1
				break
			;;
			*) menu_sync $syncOpt
			;;
		esac
	done
}

main_sync() \
{
	verifyRsyncUtility
	verifyFdUtility

	if [ "$#" -eq 0 ];
	then
		echo
		main_case_sync
	else
		menu_sync "$@"
	fi
}

main_sync "$@"; exit
