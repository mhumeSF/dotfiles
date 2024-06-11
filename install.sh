#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

brew install Alacritty --cask
xattr -d com.apple.quarantine /Applications/Alacritty.app

# Open Security & Privacy preferences
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

# Wait for user input
read -p "Press Enter to continue"

# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install nix-darwin
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
echo "Y" | ./result/bin/darwin-installer

source /etc/static/bashrc

nix-channel --add https://channels.nixos.org/nixpkgs-unstable nixpkgs
nix-channel --update

nix-shell -p git --run "git clone https://github.com/mhumesf/nix-dotfiles $HOME/dotfiles"

darwin-rebuild switch --flake $HOME/dotfiles#$(hostname)
