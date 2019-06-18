#!/bin/bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# GNU core utilities (those that come with OS X are outdated)
#
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed
# Install more recent versions of some OS X tools
brew install grep
echo 'PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.zshrc

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# HAVEN'T NEEDED MTR IN PAST TWO YEARS
#
# # mtr - ping & traceroute. best.
# brew install mtr
#
# # allow mtr to run without sudo
# mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
# sudo chmod 4755 $mtrlocation/sbin/mtr
# sudo chown root $mtrlocation/sbin/mtr

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install other useful binaries
#
# sort "%!sort -k2nr"
tools=(
    ack
    cmatrix
    docker-clean
    dockutil
    fzf
    git
    gnupg2
    go
    hub
    jq
    md5sha1sum
    mongodb
    neovim
    pv
    python
    rename
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Move to post-install 'cause deez guys super-slow
# brew install imagemagick --with-webp
# brew install ffmpeg --with-libvpx

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ruby
# brew install rbenv ruby-build


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install node
#
brew uninstall --force yarn node npm  # remove previously installed node, npm, yarn
brew cleanup  # clean all broken symlinks
brew update  # always good to have the latest

# install Yarn w/o the node dependency
# https://github.com/yarnpkg/website/blob/13e95d80282f028ed7b28a822818ce128ea70b7e/lang/en/docs/_installations/mac.md
brew install yarn --ignore-dependencies  # the option --without-node doesn't seem to work anymore @ Feb 2019

# install current 0.34.0 version (Feb 2019)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# install a node latest lts (currently dubnium, v10.x, on Feb 2019)
nvm install lts/dubnium

echo "lts/dubnium" > .nvmrc # to default to the latest LTS version
nvm alias default lts/dubnium

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Remove outdated versions from the cellar
#
brew cleanup
