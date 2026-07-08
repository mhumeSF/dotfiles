{ config, pkgs, lib, ... }:
# Store Docker/podman registry credentials in 1Password instead of as plaintext
# base64 in ~/.docker/config.json.
#
# Uses the xebia `docker-credential-1password` credential helper (pinned to a
# commit). Docker/podman call `docker-credential-1password <get|store|list|erase>`
# and the helper reads/writes an "API Credential" item (titled by the registry
# URL) in a 1Password vault (default: "Docker").
#
# podman on this host is a remote client to the lima VM; credential resolution
# happens on the client (the Mac), which is where `op` and the 1Password desktop
# app live, so the helper runs here.
let
  pinnedCommit = "2c51ecd0b0ff261fe90d3aa6199f9bc29265f7e5";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xebia/docker-credential-1password/${pinnedCommit}/bash/docker-credential-1password";
    hash = "sha256-Bhk0h51mC7oEk29dcyEigxS9QOoC/zUGnX6szveudKA=";
  };

  # jq comes from nixpkgs. `op` must be the Homebrew binary: the 1Password
  # desktop app only trusts the CLI binary it was integrated with, so a
  # nix-store `op` would fail the desktop-app auth. Hence /opt/homebrew/bin.
  docker-credential-1password = pkgs.runCommand "docker-credential-1password" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    install -m 0755 ${src} $out/bin/docker-credential-1password
    wrapProgram $out/bin/docker-credential-1password \
      --prefix PATH : ${lib.makeBinPath [ pkgs.jq pkgs.coreutils ]} \
      --suffix PATH : /opt/homebrew/bin
  '';

  # Secret-free config: every registry's credentials go through the helper,
  # so nothing is ever written to config.json in plaintext. (Consumed by the
  # docker CLI / local podman; remote podman ignores helpers — see podman-login.)
  dockerConfig = pkgs.writeText "docker-config.json" (builtins.toJSON {
    auths = { };
    credsStore = "1password";
  });

  # Remote podman (Mac client -> lima VM) does NOT invoke credential helpers;
  # it only forwards *static* creds. So bridge 1Password -> podman: read creds
  # via the helper and `podman login` into the VM once per session. Creds live
  # in 1Password (source of truth) and, transiently, in the VM's auth.json —
  # never in ~/.docker/config.json.
  #   podman-login              # log into every registry stored in the vault
  #   podman-login docker.io    # log into a specific registry
  podman-login = pkgs.writeShellApplication {
    name = "podman-login";
    runtimeInputs = [ pkgs.jq pkgs.podman docker-credential-1password ];
    text = ''
      export PATH="/opt/homebrew/bin:$PATH"   # brew `op`
      vault="''${DOCKER_CREDENTIAL_1PASSWORD_VAULT:-Docker}"

      if [ "$#" -gt 0 ]; then
        registries=("$@")
      else
        mapfile -t registries < <(op item list --vault "$vault" --format json | jq -r '.[].title')
      fi

      rc=0
      for reg in "''${registries[@]}"; do
        creds="$(printf '%s' "$reg" | docker-credential-1password get 2>/dev/null)" || creds=""
        if [ -z "$creds" ]; then echo "no 1Password credential for '$reg'" >&2; rc=1; continue; fi
        user="$(jq -r '.Username' <<<"$creds")"
        secret="$(jq -r '.Secret' <<<"$creds")"
        # Docker Hub is stored under https://index.docker.io/v1/ but you log in to docker.io
        host="$reg"; [ "$reg" = "https://index.docker.io/v1/" ] && host="docker.io"
        if printf '%s' "$secret" | podman login "$host" --username "$user" --password-stdin >/dev/null; then
          echo "logged in: $host (user=$user)"
        else
          echo "login FAILED: $host" >&2; rc=1
        fi
      done
      exit "$rc"
    '';
  };
in
{
  home.packages = [ docker-credential-1password podman-login ];

  # Install ~/.docker/config.json via activation (writable, repo is source of
  # truth) rather than a read-only symlink, so docker/podman can still update
  # non-credential fields.
  home.activation.dockerCredentialConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.docker"
    $DRY_RUN_CMD install -m 0644 ${dockerConfig} "$HOME/.docker/config.json"
  '';
}
