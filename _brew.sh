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

brews=(
  cmatrix
  docker-clean
  dockutil
  fzf
  git
  gnupg2
  go
  hub
  jq
  # mas
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
  watch
  wireguard-tools
  wget
  youtube-dl
  zopfli
  # GNU core utilities (those that come with OS X are outdated)
  coreutils
  findutils
  gnu-sed
)

for brew in ${brews[@]}; do
  brew_install $brew
done

echo 'PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >>~/.zshrc

###############################################################################
# BREW CASK
###############################################################################

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

casks=(
  backblaze
  caffeine
  docker
  font-source-code-pro
  google-chrome
  keyboard-cleaner
  rar
  selfcontrol
  slack
  spotify
  viscosity
  vlc
)

for cask in ${casks[@]}; do
  brew_cask_install $cask
done

brew doctor
brew cleanup
