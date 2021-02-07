#!/bin/bash
set -eu

source ./utils.sh

###############################################################################
# HOMEBREW
###############################################################################

if ! cmd_exists 'brew'; then
  printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &>/dev/null
  #  └─ simulate the ENTER keypress
fi

print_result $? 'Homebrew'

###############################################################################
# BREW
###############################################################################

brew update
brew upgrade

brews_installed=$(brew list)
brews=(
  ack
  cmatrix
  docker-clean
  dockutil
  fzf
  git
  gnupg2
  gnu-sed
  go
  hub
  jq
  mas
  md5sha1sum
  neovim
  pinentry-mac
  pv
  pyenv
  rename
  shfmt
  tfenv
  the_silver_searcher
  tmux
  tree
  unrar
  watch
  wget
  youtube-dl
  zopfli
  # GNU core utilities (those that come with OS X are outdated)
  coreutils
  findutils
)

brews=$(echo ${brews[@]} ${brews_installed[@]} | tr ' ' '\n' | sort | uniq -u)
for brew in ${brews[@]}; do
  brew install $brew || break
done

echo 'PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >>~/.zshrc

###############################################################################
# BREW CASK
###############################################################################

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

casks_installed=$(brew cask list)
casks=(
  backblaze
  caffeine
  docker
  font-source-code-pro
  google-chrome
  hub
  keyboard-cleaner
  selfcontrol
  slack
  spotify
  viscosity
  vlc
  wavebox
  wireguard
)

casks=$(echo ${casks[@]} ${casks_installed[@]} | tr ' ' '\n' | sort | uniq -u)
for cask in ${casks[@]}; do
  brew_cask_install $cask || break
done

brew doctor
brew cleanup
