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

brew update && brew upgrade

brew_install coreutils # GNU core utilities (those that come with OS X are outdated)
brew_install findutils

brew_install ack
brew_install cmatrix
brew_install docker-clean
brew_install dockutil
brew_install fzf
brew_install git
brew_install gnupg2
brew_install gnu-sed
brew_install go
brew_install hub
brew_install jq
brew_install mas
brew_install md5sha1sum
brew_install mongodb
brew_install neovim
brew_install pinentry-mac
brew_install pv
brew_install pyenv
brew_install rename
brew_install shfmt
brew_install tfenv
brew_install the_silver_searcher
brew_install tmux
brew_install tree
brew_install unrar
brew_install watch
brew_install wget
brew_install youtube-dl
brew_install zopfli
brew_install zsh

brew cleanup

echo 'PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >>~/.zshrc

###############################################################################
# BREW CASK
###############################################################################

#brew tap homebrew/cask-versions
#brew tap homebrew/cask-fonts
#
#brew install brew-cask-completion
#
#apps=(
#	backblaze
#	caffeine
#	docker
#	font-source-code-pro
#	google-chrome
#	hub
#	keyboard-cleaner
#	selfcontrol
#	slack
#	spotify
#	viscosity
#	vlc
#	wavebox
#	wireguard
#)
#
#for app in ${apps[@]}; do
#	brew_install  $app
#done
