# zmodload zsh/zprof
# Path to your oh-my-zsh installation.
export ZSH="/Users/finn/.oh-my-zsh"

ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

source $HOME/.aliases

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
NPM_PACKAGES=/Users/finn/.npm-packages
PATH="$NPM_PACKAGES/bin:$PATH"

PATH="/Users/finn/.homebrew/opt/grep/libexec/gnubin:$PATH"
PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye

# Go development
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export GOCACHE=$GOPATH/cache
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# kubectl crew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/Users/finn/.homebrew/opt/nvm/nvm.sh" ] && . "/Users/finn/.homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/Users/finn/.homebrew/opt/nvm/etc/bash_completion" ] && . "/Users/finn/.homebrew/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# zprof
function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}
