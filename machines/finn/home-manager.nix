{ pkgs, ... }:

{
  programs.git = {
    settings = {
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjkND6b+zYkXSG5YlUmbD4ammjF60qv+A/3f+nslQIq";
      };
    };
  };

  home.file = {
    ".ssh/allowed_signers".source = ./allowed_signers;
  };

  programs.zsh.initContent = ''
    photo-import() {
      local event="''${1:-import}"
      local server="media.local"
      local dest_root="/photos/inbox"
      local date safe_event src dest

      date="$(date +%Y-%m-%d)"
      safe_event="$(echo "$event" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9._-')"

      src="$(
        find /Volumes -maxdepth 3 -type d \
          \( -name DCIM -o -name PRIVATE -o -name MISC \) \
          2>/dev/null | fzf --prompt="Import from: "
      )"

      if [ -z "$src" ]; then
        echo "No source selected."
        return 1
      fi

      dest="''${server}:''${dest_root}/''${date}-''${safe_event}/"

      echo
      echo "Importing:"
      echo "  from: $src/"
      echo "  to:   $dest"
      echo

      rsync -avhP \
        --ignore-existing \
        --info=progress2 \
        "$src"/ \
        "$dest"
    }
  '';

}
