{ pkgs, inputs, ... }:
let
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/refs/tags/0.15.0.tar.gz";
    sha256 = "01dhrghwa7zw93cybvx4gnrskqk97b004nfxgsys0736823956la";
  };
  unstable = import <nixpkgs-unstable> {};
  # homeDirectory = (if pkgs.stdenv.isDarwin then "/Users/" else "/home/") + "${user}";
in {
  imports = [
    ./git.nix
    ./git-delta.nix
    ./git-aliases.nix
    ./git-ignores.nix
    ./gh.nix
  ];

  # Don't change this when you change package input. Leave it alone. backwards compat; don''t change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";

  xdg.enable = true;

  # specify my home-manager configs
  home.packages = with pkgs; [
    age
    cmatrix
    fzf
    htop
    ipcalc

    jq
    yq-go

    ripgrep
    sops
    tmux
    tree
    viddy
    wireguard-tools

    curl
    less

    du-dust

    google-cloud-sdk

    ansible-language-server
    ansible-lint

    # GNU tools
    gnugrep
    gnused
    gnutar
    coreutils

    # Docker tools
    # lima-bin
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
  ] ++ [
    unstable.neovim
  ];

  home.sessionPath = [ "/opt/homebrew/bin" ];

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

  programs.direnv = {
    config.global.hide_env_diff = true;
    config.whitelist.prefix = [ "~/Workspace/" ];
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.eza.enable = true;
  programs.eza.icons = true;
  # programs.eza.icons = "always";
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
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {

    # 1password
    sops = "op run -- sops";
    aws = "op run -- aws";
    gh = "op run -- gh";

    # nix
    nixswitch = "darwin-rebuild switch --flake ~/dotfiles --impure";
    nixup = "pushd ~/dotfiles; nix flake update; nixswitch; popd";

    # Misc aliases
    vi = "nvim";
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
  programs.zsh.initExtra = ''
    eval "$(op signin)"
  '';
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  home.file = {
    ".aws/op-cred-helper.sh".source           = ../../home/.aws/op-cred-helper.sh;
    ".config/alacritty/alacritty.toml".source = ../../home/.config/alacritty/alacritty.toml;
    ".config/starship/starship.toml".source   = ../../home/.config/starship/starship.toml;
    ".editorconfig".source                    = ../../home/.editorconfig;
    ".tmux.conf".source                       = ../../home/.tmux.conf;
    ".tmuxcolors.conf".source                 = ../../home/.tmuxcolors.conf;
    ".zsh/plugins/aws.plugins.zsh".source     = ../../home/.zsh/plugins/aws.plugin.zsh;
    ".zsh/plugins/cargo.plugins.zsh".source   = ../../home/.zsh/plugins/cargo.plugin.zsh;
  };
}
