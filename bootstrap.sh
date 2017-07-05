#!/bin/bash

sh osx.sh

# Oh-my-zsh setup
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Vim Setup
curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh

sh brew.sh
sh brew-cask.sh
