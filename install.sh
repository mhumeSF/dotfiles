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

# Install recommended vanilla using determinate.systems install script as
# perscribed by nix-darwin. Say no when prompted to install Determinate Nix.
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

sudo nix-channel --add https://channels.nixos.org/nixpkgs-unstable nixpkgs-unstable
sudo nix-channel --add https://channels.nixos.org/nixpkgs-24.11-darwin nixpkgs
sudo nix-channel --update

# Clone dotfiles to home
nix-shell -p git --run "git clone https://github.com/mhumesf/nix-dotfiles $HOME/dotfiles"

# Use nix to invoke nix-darwin to install dotfiles
sudo nix run --extra-experimental-features "nix-command flakes" nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch --flake  ~/dotfiles/ --impure

# Uninstall nix-darwin
# nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller

# Uninstall nix
# /nix/nix-installer uninstall

rm -rf "/Users/${USER}/.local/state/nix/profiles/home-manager*"
rm -rf "/Users/${USER}/.local/state/home-manager/gcroots/current-home"
