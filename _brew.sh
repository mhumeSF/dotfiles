#!/bin/bash

###############################################################################
# HOMEBREW
###############################################################################

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

###############################################################################
# BREW
###############################################################################

brew update && brew upgrade
# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
brew install moreutils
brew install findutils

# Install more recent versions of some OS X tools
brew install grep

# Other tools
grep
tools=(
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
    mongodb
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
    zsh
)
for tool in ${tools[@]}
do
    brew install $tool
done
brew cleanup

echo 'PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.zshrc

###############################################################################
# BREW CASK
###############################################################################

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

brew install brew-cask-completion

apps=(
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

for app in ${apps[@]}
do
    brew install --cask $app
done
