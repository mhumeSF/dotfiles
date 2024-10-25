{ pkgs, inputs, ... }:
let
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/refs/tags/0.15.0.tar.gz";
    sha256 = "01dhrghwa7zw93cybvx4gnrskqk97b004nfxgsys0736823956la";
  };
  unstable = import <nixpkgs-unstable> {};
in {
  imports = [
    ./gitaliases.nix
    ./delta.nix
    ./gitignores.nix
  ];
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
    du-dust
    fd
    fzf
    gh
    htop
    ipcalc
    jq
    less
    neofetch
    pv
    ripgrep
    silver-searcher
    sops
    tmux
    tree
    tree-sitter
    viddy
    watch
    wireguard-tools
    yq-go
    zopfli

    pyenv

    google-cloud-sdk

    tig
    lf

    go

    direnv

    ansible
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

    # NIX tools
    nixos-generators
    # nixos-anywhere
    # disko
  ] ++ [
    unstable.neovim
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

  programs.direnv.enable = true;

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.eza.enable = true;
  programs.eza.icons = true;
  # programs.eza.icons = "always";
  programs.eza.extraOptions = [
    "--group-directories-first"
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        name = "Mike Hume";
        email = "mhumesf@gmail.com";
      };
      gpg = {
        format = "ssh";
        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };
      commit = {
        gpgsign = true;
      };

      core = {
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.config/git/ignore";
      };

      init = {
        defaultBranch = "main";
      };

      pull = {
        ff = "only";
      };

      merge = {
        tool = "vimdiff";
      };

      mergetool = {
        prompt = true;
        vimdiff = {
          cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        };
      };

      difftool = {
        prompt = false;
      };

      diff = {
        tool = "vimdiff";
        plist = {
          textconv = "plutil -convert xml1 -o -";
        };
        sopsdiffer = {
          textconv = "sops -d";
        };
      };

      color = {
        ui = true;
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
        diff = {
          meta = "yellow";
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
      };

      branch = {
        master = {
          remote = "origin";
          merge = "refs/heads/master";
        };
        main = {
          remote = "origin";
          merge = "refs/heads/main";
        };
      };

      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };


  # DO NOT ENABLE IF SETTING THIS FILE MANUALLY => ".config/git/config"
  # programs.git.enable = true;

  # programs.neovim.enable = true;
  # programs.neovim.package = unstable.neovim;
  # programs.ssh.extraConfig = ''
  #   IdentityAgent "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  # '';

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {
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
    # pyenv currently managed outside Nix
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    # 1Password cli setup
    eval "$(op signin)"
    source /Users/$USER/.zsh/plugins/aws.plugins.zsh
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
