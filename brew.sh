#!/bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade


# GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --default-names

# Bash 4
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
brew install bash
# regular bash-completion package is held back to an older release, so we get latest from versions.
#   github.com/Homebrew/homebrew/blob/master/Library/Formula/bash-completion.rb#L3-L4
brew tap homebrew/versions
brew install homebrew/versions/bash-completion2

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew install homebrew/dupes/grep

# mtr - ping & traceroute. best.
brew install mtr

# Install other useful binaries
brew install ack
brew install awscli
brew install casperjs
brew install cmatrix
brew install dockutil
brew install ffmpeg --with-libvpx
brew install git
brew install imagemagick --with-webp
brew install jq
brew install md5sha1sum
brew install mongodb
brew install nmap
brew install node
brew install pv
brew install python
brew install rename
brew install task --with-gnutls
brew install testdisk
brew install the_silver_searcher
brew install tmux
brew install tree
brew install unrar
brew install youtube-dl
brew install zopfli
brew install zsh

# brew update --all && brew upgrade && brew cleanup

# Disabled because Haskell takes FOREVER to compile (...like a day)
#brew install pandoc

# Ruby
brew install rbenv ruby-build

