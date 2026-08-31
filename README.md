# dotfiles

nix-darwin + home-manager. New machine: `./install.sh <host>`.

## Switching

```sh
nixswitch     # nh darwin switch
nixup         # nh darwin switch --update
nixclean      # nh clean all --keep 5 --keep-since 30d --ask
```

`nh` must **not** be run with sudo — it refuses to run as root and elevates
itself for activation. `darwin-rebuild` is the opposite and requires sudo
([nix-darwin#1457][1457]). The first switch on a new machine has to use it,
since nh isn't installed yet:

```sh
sudo darwin-rebuild switch --flake ~/dotfiles
```

Neither needs `--impure`.

[1457]: https://github.com/nix-darwin/nix-darwin/issues/1457

## Manual setup

`./preflight.sh` checks all of this. Expect failures on a fresh machine — the
switch installs the 1Password app but can't click through its settings.

- 1Password: CLI integration and SSH agent both enabled (Settings > Developer).
- `op` must be the Homebrew binary; the desktop app rejects a nix-store one.
- `op` needs `OP_ACCOUNT` set when more than one account is configured.
- A 1Password vault named `Docker`, items typed *API Credential* and titled by
  registry host (`docker.io`). `podman-login` reads it; without it every
  registry reports "no credential".
- Full Disk Access, on whichever terminal runs the switch. Needed when
  nix-darwin creates users or updates `/Applications`. Optional locally — macOS
  prompts instead — but required over SSH, where no prompt is possible. Granted
  per-application, so approving Terminal.app doesn't cover Ghostty.

## Gotchas

- Homebrew lists are authoritative (`cleanup = "zap"`): anything installed and
  not declared is uninstalled on the next switch, so a hand-installed package
  is temporary. `autoUpdate`/`upgrade` are off — run `brew upgrade` by hand.
- `nix.enable = false`: Determinate owns `/etc/nix/nix.conf` and `nix.settings`
  does nothing. The hook is `/etc/nix/nix.custom.conf`.
- Nothing garbage collects automatically; `nixclean` is manual.
- Only one host gets built regularly. Check the other without switching:
  `nix build --dry-run .#darwinConfigurations.<host>.system`.
