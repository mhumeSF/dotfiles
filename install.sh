#!/bin/bash
set -e

echo "=== Installing Homebrew ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "=== Requesting Full Disk Access ==="
echo "Please grant Full Disk Access to your terminal in the Security & Privacy preferences."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
read -p "Press Enter after granting permissions..."

echo "=== Installing Nix ==="
# Use --prefer-upstream-nix for vanilla linux
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "=== Cloning dotfiles ==="
nix-shell -p git --run "git clone https://github.com/mhumesf/nix-dotfiles $HOME/dotfiles"

echo "=== Applying nix-darwin configuration ==="
sudo -i nix run --extra-experimental-features "nix-command flakes" nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake ~/dotfiles/ --impure

echo "=== Installation complete! ==="

# UNINSTALL COMMANDS (commented out):
# nix-darwin: nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
# nix: /nix/nix-installer uninstall
# home-manager cleanup: rm -rf "/Users/${USER}/.local/state/nix/profiles/home-manager*" "/Users/${USER}/.local/state/home-manager/gcroots/current-home"
