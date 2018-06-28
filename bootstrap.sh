#!/bin/bash

./xcode.sh
./zsh.sh
./homebrew.sh
./osx.sh
./npm-setup.sh

# Vim Setup
cd $HOME
curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh
