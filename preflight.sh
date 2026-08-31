#!/bin/bash
# Verifies the manual prerequisites this config depends on but cannot install.
#
# Everything checked here fails *silently at runtime* if missing — a hung
# shell, an unsigned commit, a registry login that reports "no credential".
# Read-only: this script never changes anything.
#
# Run any time:  ./preflight.sh

vault="${DOCKER_CREDENTIAL_1PASSWORD_VAULT:-Docker}"
fail=0

ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; printf '      %s\n' "$2"; fail=1; }

echo "=== 1Password ==="

# Must be the Homebrew binary: the desktop app only trusts the CLI it was
# integrated with, so a nix-store `op` fails desktop auth. See
# modules/home-manager/container-credentials.nix.
if [ -x /opt/homebrew/bin/op ]; then
  ok "Homebrew op present"
else
  bad "op not found at /opt/homebrew/bin/op" \
      "Install the 1password-cli cask; a nix-store op will NOT work."
fi

# Probe with a real read, not `op whoami`: whoami only reports on a CLI session
# token from `op signin`, and returns "account is not signed in" even when the
# desktop-app integration is working fine. This config relies on the desktop
# path (op run --, docker-credential-1password), so test what it actually uses.
if /opt/homebrew/bin/op vault list >/dev/null 2>&1; then
  ok "op can read from 1Password"
else
  bad "op cannot read from 1Password" \
      "Enable 1Password > Settings > Developer > 'Integrate with 1Password CLI'."
fi

# podman-login reads registry credentials from this vault. Items are titled by
# registry host (e.g. docker.io) and typed API Credential.
if /opt/homebrew/bin/op vault get "$vault" >/dev/null 2>&1; then
  ok "1Password vault '$vault' reachable"
else
  bad "1Password vault '$vault' not found" \
      "Create it, or set DOCKER_CREDENTIAL_1PASSWORD_VAULT. podman-login needs it."
fi

if [ -S "$HOME/.1password/agent.sock" ]; then
  ok "1Password SSH agent socket present"
else
  bad "no SSH agent socket at ~/.1password/agent.sock" \
      "Enable 1Password > Settings > Developer > 'Use the SSH agent'."
fi

echo "=== macOS permissions ==="

# Reading the TCC database is itself gated on Full Disk Access, so this is a
# direct test rather than a proxy. Needed when nix-darwin creates users or
# updates /Applications; optional locally (you get prompted), mandatory
# over SSH. FDA is per-application, so this only tests THIS terminal.
if ls "$HOME/Library/Application Support/com.apple.TCC" >/dev/null 2>&1; then
  ok "Full Disk Access granted to this terminal"
else
  bad "this terminal lacks Full Disk Access" \
      "Optional locally (expect prompts on switch); required to switch over SSH."
fi

echo "=== git signing ==="

if [ -n "$(git config --get user.signingkey 2>/dev/null)" ]; then
  ok "signing key configured"
else
  bad "no user.signingkey" \
      "Set it in machines/<host>/home-manager.nix, then switch."
fi

if [ -r "$HOME/.ssh/allowed_signers" ]; then
  ok "allowed_signers present"
else
  bad "no ~/.ssh/allowed_signers" \
      "Provided by machines/<host>/allowed_signers via home-manager."
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "All checks passed."
else
  echo "Some checks failed — see above. These are manual steps; no config change fixes them."
fi
exit "$fail"
