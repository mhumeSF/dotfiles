{ pkgs, ... }:
let
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/main.tar.gz";
    sha256 = "1ypp731d2h7i8fj5g2pdapwcrrk6ycxwzpvam045qxiajjdp01rw";
  };
in {
  # Don't change this when you change package input. Leave it alone. backwards compat; don''t change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";

  xdg.enable = true;

  # specify my home-manager configs
  home.packages = with pkgs; [
    age
    bat
    bottom
    cmatrix
    curl
    direnv
    du-dust
    fd
    fzf
    gh
    git
    htop
    ipcalc
    jq
    less
    neofetch
    pv
    ripgrep
    silver-searcher
    (pkgs.callPackage "${agenix}/pkgs/agenix.nix" {})
    sops
    tmux
    tree
    tree-sitter
    viddy
    watch
    wireguard-tools
    yq-go
    zopfli

    tig

    ansible
    ansible-language-server
    ansible-lint

    # GNU tools
    gnugrep
    gnused
    gnutar
    coreutils

    # Docker tools
    lima-bin
    docker-client
    docker-buildx
    docker-compose

    # Kubernetes tools
    kind
    kubectl
    kubectx
    kubectl-neat
    kubernetes-helm
    fluxcd

    # OSX tools
    dockutil

    # NIX tools
    nixos-generators
    # nixos-anywhere
    # disko
  ];
  home.sessionPath = [
    "/opt/homebrew/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
  ];
  home.sessionVariables = {
    HUGO_CACHEDIR = "$HOME/.local/share/hugo";
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
    SSH_AUTH_SOCK="$HOME/.1password/agent.sock";
    STARSHIP_CONFIG="$HOME/.config/starship/starship.toml";
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY="YES"; # https://github.com/ansible/ansible/issues/76322
  };
  programs.atuin.enable = true;
  programs.atuin.enableZshIntegration = true;
  programs.atuin.settings.style = "compact";
  programs.atuin.settings.inline_height = 26;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.eza.enable = true;
  programs.eza.icons = true;
  programs.eza.extraOptions = [
    "--group-directories-first"
  ];
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {
    # nix
    nixswitch = "darwin-rebuild switch --flake ~/system-config";
    nixup = "pushd ~/system-config; nix flake update; nixswitch; popd";

    # Misc aliases
    vi = "nvim";
    docker = "DOCKER_BUILDKIT=1 docker";
    flushdns = "sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed";
    uuid = "python3 -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | pbcopy && pbpaste && echo";
    zreload = "exec /bin/zsh -l";

    ag = "rg";
    gs = ""; # Alias gs so ghostscript doesn't get invoked

    u = "sudo softwareupdate --install --all";
    l = "limactl";
    k = "kubectl";
    kc = "kubectx";
    kn = "kubens";

    gst = "git status";

    # gnu rust replacements
    cat = "bat --style=plain --no-pager";
    watch = "viddy ";
    du = "dust";
  };
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  home.file.".config/alacritty/alacritty.toml".source = ../../config/alacritty/alacritty.toml;
  home.file.".config/starship/starship.toml".source = ../../config/starship/starship.toml;
  home.file.".config/git/ignore".source = ../../config/git/ignore;
  home.file.".config/git/config".source = ../../config/git/config;
  home.file.".editorconfig".source = ../../config/home/editorconfig;
  home.file.".tmux.conf".source = ../../config/home/tmux.conf;
  home.file.".tmuxcolors.conf".source = ../../config/home/tmuxcolors.conf;
}
