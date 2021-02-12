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

mkdir -p $HOME/.config/starship
ln -sf $HOME/dotfiles/conf/starship.toml $HOME/.config/starship/starship.toml

mkdir -p $HOME/.config/.gnupg
cp $HOME/dotfiles/conf/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> gpg-agent.conf
ln -sf $HOME/dotfiles/conf/gpg.conf $HOME/.gnupg/gpg.conf

mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/conf/init.vim ~/.config/nvim/init.vim

mkdir -p $HOME/.zsh/plugins
ln -sf $HOME/dotfiles/conf/k8s.plugin.zsh ~/.zsh/plugins/k8s.plugin.zsh
ln -sf $HOME/dotfiles/conf/aws.plugin.zsh ~/.zsh/plugins/aws.plugin.zsh
ln -sf $HOME/dotfiles/conf/tf.plugin.zsh ~/.zsh/plugins/tf.plugin.zsh
ln -sf $HOME/dotfiles/conf/spinnaker.plugin.zsh ~/.zsh/plugins/spinnaker.plugin.zsh

./_brew.sh
print_in_green '\n  ---\n\n'

./_osx.sh
 print_in_green '\n  ---\n\n'

./_python.sh
 print_in_green '\n  ---\n\n'
