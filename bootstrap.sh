#!/bin/bash

./xcode.sh
./zsh.sh
./homebrew.sh
./osx.sh
./npm-setup.sh

# symlink config files
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
ln -s $HOME/dotfiles/.gitignore $HOME/.gitignore
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
ln -s $HOME/dotfiles/.tmuxcolors.conf $HOME/.tmuxcolors.conf
mkdir -p $HOME/.config/nvim
ln -s $HOME/dotfiles/init.vim ~/.config/nvim/init.vim

# # Vim Setup
# cd $HOME
# curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh
