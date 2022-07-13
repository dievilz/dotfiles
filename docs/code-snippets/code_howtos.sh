#
# Shell How-Tos
#

# =========================== STRING OPERATIONS ================================

##### How to print the last part of a line/string separated by only one space.
# EXAMPLE: dscl . -read /Users/"$(id -un)" UserShell
#
echo "UserShell: /bin/zsh" \
| cut -d ' ' -f 2  ## Choose the 2nd part of the line after the first delimiter
| awk '{print $2}' ## Print the second part (only w/two clearly separated substrings)
| sed 's/UserShell: //' ## Substitute the substring for nothing and use the resulting string
##  RESULT: "/bin/zsh"



##### How to extract a known substring with a space from a line with <awk>.
# EXAMPLE: dscl . -read /Users/"$(id -un)" RealName
#
echo "ThisText Then RealName: First Last" \
| awk -F "RealName: " '{print $2}'   ## Use this command with a more complicated string
## RESULT: "First Last"



##### How to extract a known substring with <grep> REGEX.
## EXAMPLE: sudo dscl . -list "/SharePoints"
#
printf "%s\n" \
"First Last's Public Folder" \
"Wirst Sast's Public Folder" \
"Zirst Oast's Public Folder" \
| grep -Eo '^.*?\First Last'   ## With -o, it prints only the substring in the REGEX
## RESULT: "First Last"

| grep -E '^.*?\First Last' ## Without -o, it prints any complete line that matches the REGEX
## RESULT: " First Last's Public Folder"

| grep -E '^.*?\Public'     ## Without -o, it prints any complete line that matches the REGEX
## RESULT:
## First Last's Public Folder
## Wirst Sast's Public Folder
## Zirst Oast's Public Folder



##### How to modify known (sub)strings to a line with "awk substitute".
## EXAMPLE: VARIABLE="value text" (file.ext)
#
sed -i -E 's|^#?(VARIABLE=).*|\1"new value"|g' file.ext
## RESULT:  VARIABLE="new value"

# ------------------------------------------------------------------------


##### How to print a string in lowercase and delete whitespace.
uname -rs | tr '[:upper:]' '[:lower:]' # | tr -d ' '


##### How to delete any character: i.e. a <whitespace>.
uname -rs | tr -d ' '
tr -d ' ' < input.txt > output.txt
tr --delete ' ' < input.txt > output.txt


##### How to replace <a> for <b>, i.e. a <line feed> for <whitespace>.
tr '\n' ' ' < input.txt


##### How to delete ANSI Escape Codes with REGEX.
echo "\033[4m\033[38;34mNetBSD\033[0m" \
| sed 's/\\033\[[0-9;]*[a-zA-Z]//g'
| sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'
| sed 's/\e\[[0-9;]*[a-zA-Z]//g'

echo "\033[4m\033[38;34mNetBSD\033[0m" \
| perl -pe 's/\\033\[[0-9;]*[a-zA-Z]//g'
| perl -pe 's/\x1b\[[0-9;]*[a-zA-Z]//g'
| perl -pe 's/\e\[[0-9;]*[a-zA-Z]//g'


##### How to extract a known substring that has a newline.
## EXAMPLE= "RealName:
##  First Last"
dscl . -read /Users/dievilz RealName \
| tr -d '\n' | sed 's/RealName: //g'     ## Preferred, removes both eol and space
| tr '\n' ' ' | sed 's/RealName:  //g'.  ## Cringe, replaces the newline for a space and the delete de two spaces
## RESULT: "First Last"


##### How to (un)comment a known line inside a file.
sed -i -E 's/^#?(VARIABLE.*)$/\1/g' file.ext   ## Uncomment, ? to match preceding expr once or none
sed -i -E 's/^?(VARIABLE.*)$/#\1/g' file.ext   ## Comment, note the adding of #


##### How to verify if a known string is located inside a file using <grep>.
if [ -f /usr/local/etc/my.cnf.default ];
then
	STRING="pid-file     = /usr/local/var/run/mysql/mysql.pid\nsocket       = /usr/local/var/run/mysql/mysql.sock"

	if grep -Fqx "${STRING}" /usr/local/etc/my.cnf.default; # -F: fixed,-q: quiet,-x:entire line
	then
		sudo zsh -cv 'echo -e "pid-file     = /usr/local/var/run/mysql/mysql.pid\nsocket       = /usr/local/var/run/mysql/mysql.sock" >> /usr/local/etc/my.cnf.default' && echo
	fi
fi


##### How to search for an unknown value of a known key inside a file.
echo "name = FirstName" |
grep -Po '(?<=^name = )\w*$' file.ext
awk -v FS="name = " 'NF>1{print $2}' file.ext
awk -F= -v key="name" '$1==key {print $2}' file.ext
sed -n 's/^name = //p' file.ext



## Below does not work if the file doesn't have an extension, so the      (BASH)
## whole file name is taken.
ln -fsv "$file" "$HOME/.${file##*/}"

# ==============================================================================





# ======================= GET [USER,GROUP,ROOT] NAME ===========================

##### How to print current user username                               (POSIX 1)
## https://stackoverflow.com/questions/19306771/how-can-i-get-the-current-users-username-in-bash/23931327#23931327
id -un
id -gn

##### How to print current user username                               (POSIX 2)
## https://stackoverflow.com/questions/1104972/how-do-i-get-the-name-of-the-active-user-via-the-command-line-in-os-x/52435808#52435808
logname
crontab -u $(logname)

##### How to print current user username [with the current EUID]       (POSIX 3)
## https://stackoverflow.com/questions/19306771/how-can-i-get-the-current-users-username-in-bash/25118029#25118029
ps -o user= -p $$  # | awk '{print $1}'  # (For Solaris use this pipe)

##### How to print current user username                               (POSIX 4) (Not scriptable)
## https://stackoverflow.com/questions/1104972/how-do-i-get-the-name-of-the-active-user-via-the-command-line-in-os-x/1106135#1106135
w

##### How to print current user username                                   (ZSH)
## OMZ/PWRLVL10K scripts
echo"${(%):-%n}"

##### How to print current user username                                  (BASH)
## https://stackoverflow.com/questions/19306771/how-can-i-get-the-current-users-username-in-bash/54265211#54265211
printf '%s\n' "${_@P}"
# : \\u                       ## (doesn't work when I tried it)

# whoami   ##### [only for a user attached to stdin]                (DEPRECATED)

##### How to know if the user is root or not (0:root, >0:user)
id -u





# ================================ FIND [*] ====================================

##### Print out a list of all the files whose names do not end in .c
find / \! -name "*.c" -print





# ================================= FD [*] =====================================

##### Print out absolute paths of files with a depth level of 5
fd . "$DOTFILES/home/local/share" -d 5 --type f -0

##### Look out for, in this case, a folder ".dotfiles", excluding Library and
##### limit to 1st result
fd -g ".dotfiles" "$HOME" -HI --maxdepth 3 --type d -E "Library" --max-results 1





# ================================= GREP [*] ===================================





# ============================ SHELL'S PATH(NAME) ==============================
## grep: -m=Maxcount,E=REGEX,o=output(print only matching part),q=quiet(no outp)

##### How to get the current running Shell  _NAME_  with REGEX #################
## -------------------- For scripts/terminal -----------------------------------
## Look for the shell running this script and:
## 1) Match just one single word with (a quantifier range of, in this case) 0 to
##    6 word characters preceding 'sh'.
## 2) Match the single word 'koi'.
ps -o args= -p $$ | egrep -m 1 -o '\b\w{0,6}sh|koi'
ps -o args= -p $$ | egrep -m 1 -o '\w{0,}sh'  ## from 0 to any, preceding 'sh'

## -------------------- For scripts/terminal -----------------------------------
## Look for the shell running this script that: matches the singlewords bash, sh
ps -o args= -p $$ | egrep -m 1 -o '\b(bash|sh)'
## Look for the shell running this script that: matches the word 'zsh'
ps -o args= -p $$ | egrep -m 1 -o '(zsh)'



##### How to get the current running Shell  _PATH_  without REGEX ##############
## ------------------------ For scripts ----------------------------------------
## How to get the current running Shell path - way #1
lsof -p "$$" | grep -m 1 txt | xargs -n 1 | tail -n

## ------------------------ For terminal ---------------------------------------
## If you need to allow for possible space characters in the shell's path, use:
lsof -p "$$" | grep -m 1 txt | xargs -n 1 | tail -n +9 | xargs
## -----------------------------------------------------------------------------


##### How to get the current running Shell  _PATH_  without REGEX  - way #2 ####
## -------------------- For scripts/terminal -----------------------------------
## (Will depend on variant of <pstree>)
pstree -p $$  | tr ' ()' '\012\012\012' | grep -i "sh$" | grep -v "$0" | tail -1

## -------------------- For scripts/terminal -----------------------------------
## Untested (Works in iTerm2)
lsof -p $$  | tr ' ()' '\012\012\012' | grep -i "sh$" | grep -v "$0" | tail -1





# ============================== MISCELLANEOUS =================================

##### How to download a file using curl
curl -fsSL -o "$HOME/Downloads" "https://raw.githubusercontent.com/dievilz/dotfiles/master/README.md"

##### How to download a file using wget (<curl> is preferable)
wget -qO "$HOME/Downloads" "https://raw.githubusercontent.com/dievilz/dotfiles/master/README.md"

##### How to clear a file
: > file.txt
truncate -s

##### How to copy a file with new permissions
install -C -m 600 "$localShareFile" "$HOME/.local/share$localSharePath"


##### Verify SHA integrity - way 1
shasum -c --ignore-missing shasum.ext file.ext
## The file contents should be: "<checksum>  <file.extension>"

##### Verify SHA integrity - way 2
echo "<checksum>  <file.extension>" | shasum -c-


##### Check PGP signature
gpg --verify "${BOOTSTRAP_TAR_IN_PATH}{.asc,}"
gpg --verify file.ext signature.sig/asc

signify -V -p /etc/signify/void-release-20210930.pub -x sha256sum.sig -m sha256sum.txt
## Signature Verified

minisign -V -p /etc/signify/void-release-20210930.pub -x sha256sum.sig -m sha256sum.txt
## Signature and comment signature verified
## Trusted comment: timestamp:1634597366	file:sha256sum.txt

##### Append data to a file from another one when root privilege is necessary.
sudo tee -a /etc/hosts < /tmp/hosts               # When stdout is needed
sudo tee -a /etc/hosts < /tmp/hosts > /dev/null   # When stdout is not needed

## Above is preferred (because of speed and perfomance) over:
cat /tmp/hosts | sudo tee -a /etc/hosts
curl -fsSL ... | sudo tee -a /etc/hosts
