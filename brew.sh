#!/bin/bash

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

brew install bash-completion
brew install brew-cask-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
#brew install grc

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew install grep
echo "# PATH for GNUGrep"
echo 'PATH="/Users/mhume/.homebrew/opt/grep/libexec/gnubin:$PATH"' >> ~/.zshrc

# mtr - ping & traceroute. best.
brew install mtr

# allow mtr to run without sudo
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
sudo chmod 4755 $mtrlocation/sbin/mtr
sudo chown root $mtrlocation/sbin/mtr

# sort "%!sort -k2nr"
# Install other useful binaries
brew install ack
brew install cmatrix
brew install docker-clean
brew install dockutil
brew install fzf
brew install git
brew install gnupg2
brew install jq
brew install md5sha1sum
brew install mongodb
brew install pv
brew install python
brew install rename
brew install task --with-gnutls
brew install testdisk
brew install the_silver_searcher
brew install tmux
brew install tree
brew install unrar
brew install watch
brew install youtube-dl
brew install zopfli
brew install zsh

# Move to post-install 'cause deez guys super-slow
# brew install gpg
# brew install imagemagick --with-webp
# brew install ffmpeg --with-libvpx

# # Ruby
# brew install rbenv ruby-build

# Node and NPM
# https://gist.github.com/DanHerbert/9520689#gistcomment-2129349
brew install node
npm install npm --global

# Remove outdated versions from the cellar
brew cleanup
