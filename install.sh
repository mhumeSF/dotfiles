#!/bin/bash

source ./utils.sh

xcode-select --install

###############################################################################
# Symlink config files
###############################################################################
ln -sf $HOME/dotfiles/conf/gitconfig $HOME/.gitconfig
ln -sf $HOME/dotfiles/conf/gitignore $HOME/.gitignore
# ln -sf $HOME/dotfiles/conf/zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/conf/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles/conf/tmuxcolors.conf $HOME/.tmuxcolors.conf

mkdir -p $HOME/.config/.gnupg
ln -sf $HOME/dotfiles/conf/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf
ln -sf $HOME/dotfiles/conf/gpg.conf $HOME/.gnupg/gpg.conf

mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/conf/init.vim ~/.config/nvim/init.vim

./_brew.sh
print_in_green '\n  ---\n\n'

./_osx.sh
 print_in_green '\n  ---\n\n'

./_python.sh
 print_in_green '\n  ---\n\n'
