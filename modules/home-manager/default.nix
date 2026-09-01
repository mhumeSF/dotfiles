{ config, pkgs, inputs, pkgs-unstable, ... }:
let
  unstable = pkgs-unstable;

  ghostty-cursor-shaders = pkgs.fetchFromGitHub {
    owner = "sahaj-b";
    repo = "ghostty-cursor-shaders";
    rev = "0a274beac8b93ee6ce6b94402b7313a0417b8e38";
    hash = "sha256-B7B6K7Ee4uJlW8zzLP3ILgddnbcIQyNimY+rVllzbR0=";
  };

  ghostty-shader-playground = pkgs.fetchFromGitHub {
    owner = "KroneCorylus";
    repo = "ghostty-shader-playground";
    rev = "7295ebf717f236f114912ec5de0d8ce91661448f";
    hash = "sha256-Z3jF76MnyEGQuzfeZNTyOhpGAiGfhm6rnkdeBIpsJck=";
  };
in {
  imports = [
    ./git.nix
    ./git-delta.nix
    ./git-aliases.nix
    ./git-ignores.nix
    ./gh.nix
    ./podman-lima.nix
    ./container-credentials.nix
  ];

  # Backwards compat; don't change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";

  xdg.enable = true;

  # specify my home-manager configs
  home.packages = with pkgs; [
    age
    cmatrix
    htop
    ipcalc

    jq
    yq-go

    rsync
    ripgrep
    sops
    tmux
    tree
    viddy
    wireguard-tools

    pyenv
    nodejs
    go
    rustup

    curl
    less
    glow
    certigo
    step-cli

    dust

    awscli2
    google-cloud-sdk

    # ansible-language-server
    # ansible-lint

    # GNU tools
    gnugrep
    gnused
    gnutar
    coreutils

    # Podman tools (Docker replacement)
    podman
    podman-compose
    crane
    skopeo
    dive

    # Kubernetes tools
    kind
    kustomize
    kubectl
    kubectx
    kubectl-neat
    kubernetes-helm
    cilium-cli

    # ai

    # foundry
  ] ++ [
    unstable.neovim
    unstable.tree-sitter
    unstable.fluxcd
    unstable.lima

    # 🤖🤖🤖
    unstable.claude-code
    unstable.codex
  ];

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "/opt/homebrew/bin"
    "$HOME/.config/.foundry/bin"
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    # Move this variable to anything with ansible
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"; # https://github.com/ansible/ansible/issues/76322
    DIRENV_WARN_TIMEOUT = "1m";
    DIRENV_LOG_FORMAT = "";

    # Silence podman-compose's noisy warning banner
    PODMAN_COMPOSE_WARNING_LOGS = "false";

    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };

  # nix-darwin 26.05 has no nh module, so nh is configured here. Sets
  # NH_DARWIN_FLAKE so `nh darwin switch` needs no --flake argument.
  # clean.enable is deliberately off: the home-manager module passes
  # clean.extraArgs to launchd as a single argv element, so anything longer
  # than one token breaks, and nh's defaults (--keep 1) would leave no
  # rollback. Use the nixclean alias instead.
  programs.nh = {
    enable = true;
    darwinFlake = "$HOME/dotfiles";
  };

  programs.atuin.enable = true;
  programs.atuin.enableZshIntegration = true;
  programs.atuin.settings = {
    style = "compact";
    inline_height = 26;

    # Filter out trivial/frequent commands
    history_filter = [
      "^ls$"
      "^ll$"
      "^la$"
      "^l$"
      "^cd$"
      "^cd ..$"
      "^clear$"
      "^pwd$"
      "^exit$"
      "^gst$"        # git status alias
      "^vi$"         # vi without arguments
      "^cat$"        # cat without arguments
      "^which "
      "^echo \\$"    # echo $VAR commands
      "^alias$"
      "^alias "
      "^history"
      "^env$"
      "^type "
      "^fg$"
      "^bg$"
      "^jobs$"
    ];

    # Other useful settings
    search_mode = "fuzzy";
    filter_mode = "global";
    show_preview = true;
    store_failed = true;
    secrets_filter = true;
  };

  programs.bat.enable = true;

  programs.direnv = {
    config.global.hide_env_diff = true;
    config.whitelist.prefix = [ "~/Workspace/" ];
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.direnv.silent = true;

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.eza.enable = true;
  programs.eza.icons = "auto";
  programs.eza.extraOptions = [
    "--group-directories-first"
  ];

  programs.gh.enable = true;

  # programs.neovim.enable = true;
  # programs.neovim.package = unstable.neovim;
  # programs.ssh.extraConfig = ''
  #   IdentityAgent "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  # '';

  programs.zsh.enable = true;
  # Keep zsh dotfiles under the XDG config dir (~/.config/zsh). home-manager
  # writes a ~/.zshenv bootstrap that points ZDOTDIR here, so login shells
  # still find the config.
  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {

    # 1password
    sops = "op run -- sops";
    aws = "op run -- aws";
    gh = "op run -- gh";

    ts = "tailscale";

    # nix
    nixswitch = "nh darwin switch";
    nixup = "nh darwin switch --update";
    nixclean = "nh clean all --keep 5 --keep-since 30d --ask";

    # Misc aliases
    vi = "nvim";
    flushdns = "sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed";
    uuid = "python3 -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | pbcopy && pbpaste && echo";
    zreload = "exec /bin/zsh -l";

    ag = "rg";
    gs = ""; # Alias gs so ghostscript doesn't get invoked

    u = "sudo softwareupdate --install --all";
    k = "kubectl";
    kc = "kubectx";
    kn = "kubens";

    gst = "git status";

    # Docker -> Podman
    docker = "podman";
    docker-compose = "podman-compose";

    # gnu rust replacements
    cat = "bat --style=plain --no-pager";
    watch = "viddy ";
    du = "dust";
  };

  programs.zsh.initContent = ''
    # Required for the 1Password SSH keychain — do not remove
    eval "$(op signin)"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

    source $ZDOTDIR/plugins/aws.plugin.zsh
    source $ZDOTDIR/plugins/lima.plugin.zsh
    source $ZDOTDIR/plugins/git-worktree.plugin.zsh

    # pyenv binary comes from Nix; shims/versions still live in ~/.pyenv
    eval "$(pyenv init -)"
  '';

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.configPath = "$HOME/.config/starship/starship.toml";

  # home.enableNixpkgsReleaseCheck = false;

  home.file = {
    ".config/starship/starship.toml".source              = ../../home/.config/starship/starship.toml;
    ".config/ghostty/config".source                      = ../../home/.config/ghostty/config;
    ".config/ghostty/shaders".source                     = ghostty-cursor-shaders;
    ".config/ghostty/shaders-playground".source          = "${ghostty-shader-playground}/public/shaders";
    ".editorconfig".source                               = ../../home/.editorconfig;
    ".tmux.conf".source                                  = ../../home/.tmux.conf;
    ".config/zsh/plugins/aws.plugin.zsh".source          = ../../home/.zsh/plugins/aws.plugin.zsh;
    ".config/zsh/plugins/lima.plugin.zsh".source         = ../../home/.zsh/plugins/lima.plugin.zsh;
    ".config/zsh/plugins/git-worktree.plugin.zsh".source = ../../home/.zsh/plugins/git-worktree.plugin.zsh;
  };
}
