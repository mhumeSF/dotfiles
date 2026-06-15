{ config, pkgs, lib, pkgs-unstable, ... }:
# Declarative rootless Podman runtime backed by a Lima VM.
#
# This replaces the old hand-rolled `docker` Lima machine. Nix owns:
#   * the Lima machine definition (rendered to the Nix store, linked at
#     ~/.config/lima/podman.yaml for reference)
#   * `podman-up` / `podman-down` commands to create/start/stop the VM and
#     wire up the podman system connection
#   * an activation hook that auto-creates the VM on `nixswitch` if missing
#
# The host `podman` client (installed in modules/home-manager/default.nix)
# talks to the VM over the forwarded socket via a `podman system connection`.
let
  limaPkg = pkgs-unstable.lima;
  machineName = "podman";

  # Based on Lima's upstream `template:podman` (rootless), pinned to fixed
  # resources and vz + Rosetta so amd64 images run on Apple Silicon.
  limaConfig = pkgs.writeText "lima-podman.yaml" ''
    # Managed by Nix (modules/home-manager/podman-lima.nix). Do not edit by hand.
    minimumLimaVersion: 2.0.0

    base:
    - template:_images/fedora
    - template:_default/mounts

    vmType: vz
    vmOpts:
      vz:
        rosetta:
          enabled: true
          binfmt: true

    containerd:
      system: false
      user: false

    provision:
    - mode: system
      script: |
        #!/bin/bash
        set -eux -o pipefail
        command -v podman >/dev/null 2>&1 && test -e /etc/lima-podman && exit 0
        dnf -y install --best podman && touch /etc/lima-podman
    - mode: system
      script: |
        #!/bin/bash
        set -eux -o pipefail
        # Resolve unqualified image names (e.g. `alpine`) against Docker Hub.
        # With a single search registry, enforcing mode resolves directly
        # without prompting, so non-interactive pulls still work.
        mkdir -p /etc/containers/registries.conf.d
        printf '%s\n' \
          'unqualified-search-registries = ["docker.io"]' \
          'short-name-mode = "enforcing"' \
          >/etc/containers/registries.conf.d/99-lima.conf
    - mode: user
      script: |
        #!/bin/bash
        set -eux -o pipefail
        systemctl --user enable --now podman.socket

    probes:
    - script: |
        #!/bin/bash
        set -eux -o pipefail
        if ! timeout 30s bash -c "until command -v podman >/dev/null 2>&1; do sleep 3; done"; then
          echo >&2 "podman is not installed yet"
          exit 1
        fi
      hint: See "/var/log/cloud-init-output.log" in the guest

    portForwards:
    - guestSocket: "/run/user/{{.UID}}/podman/podman.sock"
      hostSocket: "{{.Dir}}/sock/podman.sock"

    cpus: 6
    memory: "16GiB"
    disk: "100GiB"

    mounts:
    - location: "~"
      writable: true
  '';

  podmanUp = pkgs.writeShellScriptBin "podman-up" ''
    set -euo pipefail
    export PATH="${limaPkg}/bin:${pkgs.podman}/bin:$PATH"
    name="${machineName}"

    if ! limactl list -q 2>/dev/null | grep -qx "$name"; then
      echo "[podman-up] creating Lima machine '$name' (first run downloads the Fedora image)..."
      limactl create --tty=false --name="$name" "${limaConfig}"
    fi

    status="$(limactl list "$name" --format '{{.Status}}' 2>/dev/null || true)"
    if [ "$status" != "Running" ]; then
      echo "[podman-up] starting Lima machine '$name'..."
      limactl start "$name"
    fi

    sock="$(limactl list "$name" --format 'unix://{{.Dir}}/sock/podman.sock')"
    echo "[podman-up] wiring podman system connection -> $sock"
    podman system connection remove "lima-$name" 2>/dev/null || true
    podman system connection add "lima-$name" "$sock"
    podman system connection default "lima-$name"

    echo "[podman-up] ready. Test with: podman run --rm quay.io/podman/hello"
  '';

  podmanDown = pkgs.writeShellScriptBin "podman-down" ''
    set -euo pipefail
    export PATH="${limaPkg}/bin:$PATH"
    limactl stop "${machineName}" 2>/dev/null || true
    echo "[podman-down] stopped Lima machine '${machineName}'."
  '';
in
{
  home.packages = [ podmanUp podmanDown ];

  # Keep a readable copy of the generated machine config on disk for reference.
  home.file.".config/lima/podman.yaml".source = limaConfig;

  # Auto-create the machine on `nixswitch` if it is missing. Runs detached so
  # the (slow, network-bound) first provision never blocks or fails the switch.
  home.activation.limaPodman = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${limaPkg}/bin/limactl list -q 2>/dev/null | grep -qx "${machineName}"; then
      mkdir -p "$HOME/.cache"
      echo "[lima] podman machine missing — creating in background (log: ~/.cache/podman-lima.log)"
      nohup ${podmanUp}/bin/podman-up >"$HOME/.cache/podman-lima.log" 2>&1 &
      disown || true
    fi
  '';
}
