#!/bin/bash
# set -eu

source ./utils.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "Installing Homebrew..."
printf "\n\n"

if ! cmd_exists 'brew'; then
  printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &>/dev/null
  #  └─ simulate the ENTER keypress
fi

print_result $? 'Homebrew'

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "Updating Homebrew..."
printf "\n\n"

brew update

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "Upgrading Homebrew..."
printf "\n\n"

brew upgrade

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "Installing brews..."
printf "\n\n"

brew_install "cmatrix" cmatrix
brew_install "dockutil" dockutil
brew_install "command-line fuzzy finder" fzf
brew_install "git" git
brew_install "gnuph" gnupg2
brew_install "golang" go
brew_install "github cli" gh
brew_install "jq: a lightweight and flexible command-line JSON processor" jq
# brew_install "" mas
brew_install "neovim" neovim
brew_install "pinentry-mac: Pinentry for GPG on Mac" pinentry-mac
brew_install "pv: monitor the progress of data through a pipe" pv
brew_install "pyenv: python version manager" pyenv
brew_install "rename: perl-powered file rename script with many helpful built-ins" rename
brew_install "shfmt: a shell parser, formatter, and interpreter" shfmt
brew_install "tfenv: terraform version manager" tfenv
brew_install "ag: u code searching tool similar to ack and grep" the_silver_searcher
brew_install "tmux" tmux
brew_install "imagemagick" imagemagick
brew_install "tree" tree
brew_install "watch" watch
brew_install "wireguard" wireguard-tools
brew_install "wget" wget
brew_install "youtube-dl" youtube-dl
brew_install "zopfli" zopfli
# GNU core utilities (those that come with OS X are outdated)
brew_install "GNU make" make
brew_install "GNU grep" grep
brew_install "GNU sed" gnu-sed
brew_install "GNU coreutils" coreutils
brew_install "GNU findutils" findutils

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "Tapping taps..."
printf "\n\n"

brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "Installing Casks..."
printf "\n\n"

brew_install "Backblaze" backblaze
brew_install "Caffeine" caffeine
brew_install "Docker" docker
brew_install "Google Source Code Pro font" font-source-code-pro
# brew_install "Chrome" google-chrome
brew_install "Steam" steam
brew_install "Keyboard-cleaner" keyboard-cleaner
brew_install "Unrar" rar
brew_install "Slack" slack
brew_install "Spotify" spotify
brew_install "Viscosity" viscosity
brew_install "VLC" vlc

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "brew doctor..."
printf "\n\n"

brew doctor

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

printf "brew cleanup..."
printf "\n\n"

brew cleanup

printf "\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
