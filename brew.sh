#!/bin/bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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
brew install homebrew/completions/brew-cask-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew install homebrew/dupes/grep

# mtr - ping & traceroute. best.
brew install mtr

    # allow mtr to run without sudo
    mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
    sudo chmod 4755 $mtrlocation/sbin/mtr
    sudo chown root $mtrlocation/sbin/mtr

# Install other useful binaries
brews=(
ack
awscli
casperjs
cmatrix
dockutil
docker-clean
ffmpeg --with-libvpx
fzf
git
gpg
imagemagick --with-webp
jq
md5sha1sum
mongodb
nmap
pv
python
rename
task --with-gnutls
testdisk
the_silver_searcher
tmux
tree
unrar
watch
youtube-dl
zopfli
zsh
)
for brew in "${brews[@]}"
do
  brew install "$brew"
done

# Ruby
brew install rbenv ruby-build

# Node and NPM
# https://gist.github.com/DanHerbert/9520689#gistcomment-2129349
brew install node npm install npm --global

# Remove outdated versions from the cellar
brew cleanup
