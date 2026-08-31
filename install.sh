#!/bin/bash
set -e

HOST="${1:?usage: install.sh <finn|task>}"

echo "=== Installing Homebrew ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "=== Requesting Full Disk Access ==="
# nix-darwin needs TCC permission twice during activation: to create the user
# (kTCCServiceSystemPolicySysAdminFiles) and to update /Applications
# (kTCCServiceSystemPolicyAppBundles). In a graphical session macOS just
# prompts and you can accept; granting FDA up front avoids being prompted on
# every switch. Over SSH there is no prompt and activation aborts outright.
# Note FDA is per-application: granting it here covers only THIS terminal.
echo "Grant Full Disk Access to this terminal, then press Enter."
echo "Without it you will be prompted on each switch (and switching over SSH fails)."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
read -p "Press Enter after granting permissions..."

echo "=== Installing Nix ==="
# Use --prefer-upstream-nix for vanilla linux
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "=== Cloning dotfiles ==="
[ -d "$HOME/dotfiles" ] || nix-shell -p git --run "git clone https://github.com/mhumeSF/dotfiles $HOME/dotfiles"

echo "=== Applying nix-darwin configuration ==="
sudo -i nix run --extra-experimental-features "nix-command flakes" nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dotfiles/#"$HOST"

echo "=== Installation complete! ==="
echo "Restart your terminal to pick up the new shell environment."
echo

# Must run after the switch: `op` comes from the 1password-cli cask, which the
# switch above is what installs. Non-fatal — it reports remaining manual setup.
"$HOME/dotfiles/preflight.sh" || true

# UNINSTALL COMMANDS (commented out):
# nix-darwin: nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
# nix: /nix/nix-installer uninstall
# home-manager cleanup: rm -rf "/Users/${USER}/.local/state/nix/profiles/home-manager*" "/Users/${USER}/.local/state/home-manager/gcroots/current-home"
