if [ -z "$(ps -o args= -p $$ | egrep -m 1 -q '\b(zsh)')" ]; then
	if [ -n $ZSH ] && [ -d $ZSH ]; then
		(( $+commands[npm] )) && {
			__NPM_COMPLETION_FILE="${ZSH_CACHE_DIR:-$ZSH/cache}/npm_completion"

			if [ ! -f "$__NPM_COMPLETION_FILE" ]; then
				npm completion >! "$__NPM_COMPLETION_FILE" 2>/dev/null
				[ "$?" -ne 0 ] && rm -f "$__NPM_COMPLETION_FILE"
			fi

			[ -f "$__NPM_COMPLETION_FILE" ] && . "$__NPM_COMPLETION_FILE"

			unset __NPM_COMPLETION_FILE
		}
	fi
fi

#### To more infomration, visit the webpage: https://docs.npmjs.com/cli/install
### NPM package names are lowercase, thus, we've used 'camelCase' for the following aliases:

### NPM INSTALL (in project directory, no arguments):
# By default, it will install all modules listed as dependencies in package.json at the local 'node_modules' folder:
  alias npmI="npm i "
  alias npmI="npm install "

# With the '-g' or '--global' flag, it installs the current package context (ie, the current working directory) as a global package:
  alias npmG="npm install -g "
  alias npmG="npm install --global "

# With the '--production' flag (or when the NODE_ENV environment variable is set
# to production), npm will not install modules listed in devDependencies{}:
 alias npmPd="npm install --production"
###


### NPM INSTALL [<@scope>/]<name>@<version||tag>:
# Installs and saves any specified packages into your dependencies{} in your package.json file.
# Additionally, you can control where and how they get saved with some additional flags.

# As of npm 5.0.0, installed modules are added as a dependency by default,
# so the --save option is no longer needed. The other save options still exist
# and are listed in the documentation for npm install: https://docs.npmjs.com/cli/install.
# 'npms' word/command is already used by https://www.npmjs.com/package/npms

# These are deprecated in favor of the next ones:
  alias npmP="npm install -S "
  alias npmP="npm install --save "

# These are the default unless -D or -O are present:
  alias npmP="npm install -P "
  alias npmP="npm install --save-prod "

# Install and save any specified packages into your devDependencies{} in your package.json file:
# Word 'npmd' is used by https://github.com/dominictarr/npmd
 alias npmDv="npm install -D "
 alias npmDv="npm install --save-dev "

# Install and save any specified packages into your optionalDependencies{} in your package.json file:
  alias npmO="npm install -O "
  alias npmO="npm install --save-optional "

# Install but prevents saving  any specified packages into your dependencies{} in your package.json file:
 alias npmNo="npm install --no-save "
###


# Execute command from node_modules folder based on current directory:
# i.e npmE gulp
  alias npmE='PATH="$(npm bin)":"$PATH"'

# Check which npm modules are outdated:
alias npmOut="npm outdated"

# Check package versions:
  alias npmV="npm -v"

# List local packages:
  alias npmL="npm ls"
  alias npmL="npm list"

# List local top-level installed packages:
 alias npmL0="npm list --depth=0"

# List local level-one installed packages:
 alias npmL1="npm list --depth=1"

# List global packages:
 alias npmLG="npm list -g"
 alias npmLG="npm list --global"

# List global top-level installed packages:
alias npmLG0="npm list -g --depth=0"
alias npmLG0="npm list --global --depth=0"

# List global level-one installed packages:
alias npmLG1="npm list -g --depth=1"
alias npmLG1="npm list --global --depth=1"

# Run npm start
 alias npmSt="npm start"

# Run npm test
  alias npmT="npm test"

# Run npm scripts
  alias npmR="npm run"

# Run npm scripts dev
alias npmRDv="npm run dev"

# Run npm publish
alias npmPub="npm publish"

# Run npm init
 alias npmIn="npm init"

# Uninstall local modules
  alias npmU="npm uninstall "

# Uninstall global modules
 alias npmUG="npm uninstall -g "
 alias npmUG="npm uninstall --global "

# Update packages
 alias npmUp="npm update "
