#!/bin/bash

./xcode.sh
./zsh.sh
./homebrew.sh
./osx.sh
./npm-setup.sh

# symlink config files
.gitconfig
.gitignore
.zshrc
mkdir -p $HOME/.config/nvim
ln -s $HOME/dotfiles/.config/nvim/init.vim

# Vim Setup
cd $HOME
curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh
